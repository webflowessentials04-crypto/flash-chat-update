import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//
//

class RegistrationScreen extends StatefulWidget {
  //
  static const String id = 'registration_screen';
  //
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //
  // VARIABLES
  bool showSpinner = false;
  //
  String email = '';
  String password = '';
  //
  // for NEW REGISTRATION instance, kept private
  final _auth = FirebaseAuth.instance;

  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //
      // this is an overlay to indicate when a screen is loading
      //
      body: ModalProgressHUD(
        //
        // loading spinner initially set to false
        //
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //
              // HERO can take up 200 pixels or less, remains flexible
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
              TextField(
                //
                // otherwise text in white & doesn't show
                style: kLoginText,
                textAlign: TextAlign.center,
                //
                // special keyboard with @ symbol, no need to toggle!
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                //
                // from constants.dart
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: kLoginText,
                textAlign: TextAlign.center,
                //
                // so password is hidden
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                //
                // from constants.dart
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              //
              // REGISTER BUTTON
              //
              RoundedButton(
                buttonColour: Colors.lightBlueAccent,
                buttonTitle: 'Register',
                onUserPress: () async {
                  //
                  // loading spinner now shows
                  //
                  setState(() {
                    //
                    // show loading spinner
                    //
                    showSpinner = true;
                  });
                  //
                  // Firebase async method for creating a user (account), assigned to newUser
                  // returns a Future, hence await keyword
                  //
                  // use try, in case of user input errors, catch any exceptions
                  try {
                    // modern Firebase (2026) returns a UserCredential object
                    // no need to store this in 'final newUser ='
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    //
                    // NOTE no need for null check as try-catch handles it
                    // instead, check context is 'mounted'
                    // as 'newUser' guaranteed if no error
                    if (mounted) {
                      // access static variable through class name 'ChatScreen', not as an instance
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    //
                    // if user found, stop the loading spinner
                    //
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                    if (mounted) {
                      setState(() {
                        showSpinner = false;
                      });
                    }
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
