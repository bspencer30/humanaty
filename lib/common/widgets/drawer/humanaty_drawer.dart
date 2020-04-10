import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humanaty/util/logger.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/humanaty_mode.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';

class HumanatyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final mode = Provider.of<HumanatyMode>(context);
    final log = getLogger('HumanatyDrawer');
    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: auth.user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData || auth.isAnonUser()) {
          UserData userData = snapshot.data;
          return _drawer(context, auth, userData, mode);
        }
        //Navigator.pop(context); _auth.signOut();
        return Drawer();
      });
  }

  Widget _drawer(BuildContext context, AuthService auth, UserData userData, HumanatyMode mode) {
    return Drawer(
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
              children: <Widget>[
                DrawerHeader(child: auth.isAnonUser() ? _anonHeader() : _userHeader(context, userData),),            
                _profileTile(context, auth, userData),
                _settingsTile(context, userData),
                _loginTile(context, auth),
                _aboutTile(context),
                _contactTile(context),
              ],
        ), Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _switchModeTile(context, mode)))
            ],
          ),
      ));
  }

  Widget _anonHeader(){
    return Container(
      padding: EdgeInsets.only(top: 32.0),
      child: Text('Welcome to huMANAty', style: TextStyle(fontSize: 20)));
  }

  Widget _userHeader(BuildContext context, UserData userData){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: (){
            Navigator.pop(context);
            Navigator.of(context).pushNamed('/profile');
          },
          child: CircleAvatar(radius: 70, 
            backgroundColor: Pallete.humanGreen,
            backgroundImage : NetworkImage(userData.photoUrl)),),
        SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(userData.displayName, style: TextStyle(fontSize: 24)),
            HumanatyRating(rating: userData.guestRating, starSize: 15)
        ],)
      ],
    );
  }

  Widget _profileTile(BuildContext context, AuthService auth, UserData userData){
    return ListTile(
      title: Text('Profile', style: TextStyle(fontSize: 16)),
      onTap: (){
        Navigator.pop(context);
        auth.isAnonUser() ? 
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Please Log-In to view your profile'))) :
          Navigator.of(context).pushNamed('/profile');
      },);
  }

  Widget _settingsTile(BuildContext context, UserData userData){
    return ListTile(
      title: Text('Settings', style: TextStyle(fontSize: 16)),
      onTap: (){Navigator.of(context).pushNamed('/settings');},
    );
  }

  Widget _loginTile(BuildContext context, AuthService _auth){
    if (_auth.isAnonUser()) {
      return ListTile(
        title: Text('Login'),
        onTap: () {
          Navigator.pop(context);
          _auth.signOut();
        },
        );
    } else {
      return Container();
    }
  }

  Widget _aboutTile(BuildContext context){
    return ListTile(
      title: Text('About', style: TextStyle(fontSize: 16)),
      onTap:() => Navigator.of(context).pushNamed('/about'),
    );
  }

  Widget _contactTile(BuildContext context){
    return ListTile(
      title: Text('Contact Us', style: TextStyle(fontSize: 16)),
      onTap:() => Navigator.of(context).pushNamed('/contact'),
    );
  }

  Widget _switchModeTile(BuildContext context, HumanatyMode mode){
    SvgPicture chefHat = SvgPicture.asset('assets/chef-hat.svg', width: 24, color: Colors.black54);
    return Container(
      color: Pallete.humanGreen54,
      child: ListTile(
        trailing: mode.isHostMode() ? chefHat : Icon(Icons.local_dining),
        title: Text(mode.isHostMode() ? 'Switch to Guest' : mode.isConsumerMode() ? 'Switch to Host': '', 
          style: TextStyle(fontSize: 16)),
        onTap:() {
          Navigator.pop(context);
          mode.switchMode();},
      ),
    );
  }
}