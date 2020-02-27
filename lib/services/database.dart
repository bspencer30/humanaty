import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/models/user.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> createUserDoc(String displayName, String email) async{
    String currentYMD = DateTime.now().toString();
    return await userCollection.document(uid).setData({
      'displayName': displayName,
      'email' : email,
      'aboutMe' : "",
      'birthday' : currentYMD.substring(0, currentYMD.indexOf(" ")),
      'allergies' : Allergy().allergyMap,
      'accessibilityAccommodations' : false,
      'uid': uid
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
   return UserData(
      uid: uid,
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email'],
      aboutMe: snapshot.data['aboutMe'],
      birthday: DateTime.parse(snapshot.data['birthday']),
      allergies: Map.from(snapshot.data['allergies']),
      accessibilityAccommodations: snapshot.data['accessibilityAccommodations']
    );
  }

  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> updateAllergyData(Map userAllergies) async{
    return await userCollection.document(uid).updateData({
      'allergies' : userAllergies
    });
  }

  Future<void> updateUserData(UserData userData) async{
    String userBirthday = userData.birthday.toString();
    return await userCollection.document(uid).updateData({
      'displayName': userData.displayName,
      //'email' : userData.email,
      'aboutMe' : userData.aboutMe,
      'birthday' : userBirthday.substring(0, userBirthday.indexOf(" ")),
      'accessibilityAccommodations' : userData.accessibilityAccommodations
    });
  }
}