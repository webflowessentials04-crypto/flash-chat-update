import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//
//

class LoginScreen extends StatefulWidget {
  //
  static const String id = 'login_screen';
  //
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  // VARIABLES
  bool showSpinner = false;
  //
  String existingEmail = '';
  String existingPassword = '';
  //
  // create this as a private instance
  final _auth = FirebaseAuth.instance;
  //
  //
  // BUILD
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //
      // use this wrapper to show loading spinner, initially set to false
      //
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //
              // Hero is Flexible about whether it takes up 200 pixels or less
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),

              //
              // EMAIL
              //
              TextField(
                //
                // use this so text shows up against white background
                style: kLoginText,
                textAlign: TextAlign.center,
                //
                // this keyboard type already has '@' symbol, so no need to toggle
                keyboardType: TextInputType.emailAddress,
                //
                //
                onChanged: (value) {
                  //
                  //
                  existingEmail = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),

              //
              // PASSWORD
              //
              TextField(
                style: kLoginText,
                textAlign: TextAlign.center,
                //
                // ensures password is hidden
                obscureText: true,
                //
                //
                onChanged: (value) {
                  //
                  //
                  existingPassword = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              //
              // LOGIN BUTTON
              //
              RoundedButton(
                buttonColour: Colors.lightBlueAccent,
                buttonTitle: 'Log In',
                onUserPress: () async {
                  //
                  // show loading spinner
                  //
                  setState(() {
                    //
                    // show loading spinner
                    //
                    showSpinner = true;
                  });
                  // try this sign in METHOD
                  //
                  try {
                    //
                    // no need to assign output to a variable as it will not be used anywhere else
                    // this output succeeds or fails (try-catch), return value is not required to navigate to ChatScreen
                    //
                    await _auth.signInWithEmailAndPassword(
                      email: existingEmail,
                      password: existingPassword,
                    );
                    //
                    // if sign in successful, navigate to ChatScreen
                    if (mounted) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    //
                    // stop loading spinner
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
