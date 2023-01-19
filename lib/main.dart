import 'package:diebuddy/screens/splash_screen.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    print("Initialize on Android!");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        backgroundColor: Colors.white,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black
          )
        )
      ),
      home: SplashScreen(),
    );
  }
}


