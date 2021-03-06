import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/login/reset_dialog.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:humanaty/util/validator.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  
  final _signInFormKey = GlobalKey<FormState>();
  bool _passwordObscured;
  String _errorMessage;

  @override
  void initState() {
    _passwordObscured = true;
    _errorMessage = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);

    return Scaffold(
      appBar: HumanatyAppBar(actions: <Widget>[_continueAnonymously(auth)],),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Image(
              alignment: Alignment.centerLeft,
              height: 100,
              image: AssetImage('assets/images/logo/temporary_logo.png'), 
              color: Pallete.humanGreen,),
            Text('Welcome Back,',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
            ),
            Text('Sign in with huMANAty', 
              style: TextStyle(fontSize: 16)),
            SizedBox(height: SizeConfig.screenHeight * .05),
            _errorText(),
            Form(
                key: _signInFormKey,
                child: Column(
                  children: <Widget>[
                    _emailField(),
                    _passwordField(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[_forgotPassword()],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * .05),
                    _loginButton(auth),
                    SizedBox(height: SizeConfig.screenHeight * .025),
                    _googleSignIn(auth),
                    SizedBox(height: SizeConfig.screenHeight * .05),
                    _newUser()
                  ],
                ))
          ]),
    );
  }

  Widget _errorText() {
    return SizedBox(
        height: 20,
        child: Text(_errorMessage != null ? _errorMessage : '',
            style: TextStyle(color: Colors.red, fontSize: 13.0)));
  }

  Widget _emailField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        decoration: textInputDecoration.copyWith(
            hintText: 'Email',
            prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: emailValidator,
        onFieldSubmitted: (term) {_fieldFocusChange(_emailFocus, _passwordFocus);},
      ),
    );
  }

  Widget _passwordField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _passwordObscured,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocus,
        decoration: textInputDecoration.copyWith(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordObscured ? Icons.visibility_off : Icons.visibility),
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  _passwordObscured = !_passwordObscured;
                });
              },
            )),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: passwordValidator,
      ),
    );
  }

  Widget _loginButton(AuthService auth) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
          color: Pallete.humanGreen,
          onPressed: () async {
            if (_signInFormKey.currentState.validate()) {
              String email = _emailController.text.trim();
              String password = _passwordController.text;

              if (!await auth.signInWithEmailAndPassword(email, password)) {
                setState(() {
                  _errorMessage = auth.error;
                  _signInFormKey.currentState.reset();
                });
              }
            }
          },
          child: Text(auth.status == Status.Authenticating ? 'Logging In' : 'Login',
            style: TextStyle(color: Colors.white, fontSize: 16.0))),
    );
  }

  Widget _googleSignIn(AuthService auth) {
    return Container(
      height: 50.0,
      child: RaisedButton(
          onPressed: () async {
            if (!await auth.signInWithGoogle()) {}
          },
          color: Colors.white,
          // shape: RoundedRectangleBorder(side: BorderSide(
          //   color: Pallete.googleBlue,
          //   width: 2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('assets/images/logo/google_logo.png')),
              Text("Sign in with Google", style: TextStyle(fontSize: 16.0))
            ],
          )),
    );
  }

  Widget _newUser() {
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: Text('Don\'t have an account? Sign up'));
  }

  Widget _forgotPassword() {
    return InkWell(
      onTap:() => showDialog(context: context, builder: (_) {return ResetDialog();}),
      child: Text('Forgot Password?'));
  }

  Widget _continueAnonymously(AuthService auth) {
    return FlatButton(
      onPressed:() => auth.signinAnon(),
      child: Text('Skip for now',
        style: TextStyle(color: Colors.black))
    );
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}
