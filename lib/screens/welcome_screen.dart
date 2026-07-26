import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//
//
//
class WelcomeScreen extends StatefulWidget {
  //
  // id set up for named routes in main.dart
  // static is a modifier for this class
  // const ensures value cannot be changed
  //
  static const String id = 'welcome_screen';
  //
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//
// WelcomeScreenSate upgrades to 'ticker' for a SINGLE animation
// concept of mixin allows multiple capabilities for a class
//
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //
  // variable of this type
  //
  late AnimationController controller;
  //
  // declare an object of this type, needed for curved animations
  //
  late Animation animation;
  //
  //
  @override
  void initState() {
    super.initState();

    // CONSTRUCTOR is created but it's invisible
    //
    controller = AnimationController(
      //
      // ticker provider is 'this' WelcomeScreenState as initialised above
      //
      vsync: this,
      duration: Duration(seconds: 3),
      upperBound: 1,
    );
    //
    // CURVED animation
    //
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    //
    // set animation variable to this transition effect, apply to controller
    //
    animation = ColorTween(begin: Colors.indigoAccent, end: Colors.white)
        .animate(controller);
    // proceed with animation 'forward'
    //
    controller.forward();
    //
    // add this method for looping animations
    //
    // animation.addStatusListener(
    //   (status) {
    //     print(status);
    //     if (status == AnimationStatus.completed) {
    //       controller.reverse(from: 1.0);
    //     } else if (status == AnimationStatus.dismissed) {
    //       controller.forward();
    //     }
    //   },
    // );
    //
    // see what controller is doing
    // takes callback for this
    //
    controller.addListener(() {
      //
      // this will give a graduated animation
      //
      setState(() {});
    });
  }

  //
  // use this method otherwise looping animation is eating resources
  //
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //
  // BUILD here
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purpleAccent.withValues(alpha: controller.value),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //
                // for animations
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                //
                // This replaces
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            //
            // located in components folder
            //
            RoundedButton(
              buttonColour: Colors.lightBlueAccent,
              buttonTitle: 'Log In',
              onUserPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            //
            //
            RoundedButton(
              buttonColour: Colors.blueAccent,
              buttonTitle: 'Register',
              onUserPress: () {
                // go to registration screen
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
