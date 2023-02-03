import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/screens/home_screen.dart';
import 'package:diebuddy/screens/result_screen.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animationActive = false;

  startAnimation() {
    setState(() {
      Future.delayed(Duration(milliseconds: 800)).whenComplete(() {
        animationActive = true;
      });
    });
  }



  @override
  void initState() {
    startAnimation();
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if(user == null){
        print('userSignOut');
      }else{
        print('userSignIn!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          duration:2000,
            splash:  Splash(),
            backgroundColor: primaryColor,
            animationDuration: Duration(milliseconds: 1200),
            splashTransition: SplashTransition.fadeTransition,
            nextScreen: FirebaseAuth.instance.currentUser !=null ? HomeScreen() :LogInScreen())
      )
    );
  }
}

Widget Splash(){
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Diabetic Buddy!', style: TextStyle(
            color: primaryColor,
            fontSize: 40
        ),),
      ],
    ),
  );
}
