import 'package:diebuddy/screens/authentication_screens/signup_screen.dart';
import 'package:diebuddy/screens/home_screen.dart';
import 'package:diebuddy/ui_elements/buttons.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:diebuddy/ui_elements/text_classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? currentUserId;

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();

  clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  logIn(String email, String password) async {
    if (_key.currentState!.validate()) {
      try {
        /// signIn with email and password
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        print(user.user);

        /// setting the current User Id
        setState(() {
          currentUserId = user.user!.uid;
        });

        /// Navigate to home Screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } on FirebaseAuthException catch (e) {
        /// showing the error msg in snackBar
        final snackBar = SnackBar(content: Text(e.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text18Medium(color: primaryColor, text: 'LogIn')),

                SizedBox(
                  height: 40,
                ),

                /// label for email
                Text16Medium(color: primaryTextColor, text: 'Email'),

                SizedBox(
                  height: 20,
                ),

                /// Email text field
                TextFormField(
                  validator: (val) =>
                      val!.isEmpty ? 'Please fill the email' : null,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                /// label for password
                Text16Medium(color: primaryTextColor, text: 'Password'),

                SizedBox(
                  height: 20,
                ),

                /// password text field
                TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Please fill the input';
                    }else if(val!.length <5){
                      return 'password is too short!';
                    }else{
                      return null;
                    }
                  },
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                /// logIn Button
                GestureDetector(
                  onTap: () {
                    logIn(_emailController.text.trim(),
                        _passwordController.text.trim());
                  },
                  child: PrimaryButton(color: primaryColor, text: 'Login'),
                ),

                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    Text(
                      'Don\'t have account?',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: primaryColor))),
                          child: Text(
                            ' SignUp',
                            style: TextStyle(color: primaryColor),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
