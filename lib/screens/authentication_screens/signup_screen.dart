import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/screens/glucose_monitoring_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../ui_elements/buttons.dart';
import '../../ui_elements/colors.dart';
import '../../ui_elements/text_classes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();


  clearTextField(){
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
  }

  signUp(String email, String password) async{

    /// validating the form text fields
    if(_key.currentState!.validate()){
      try{
        /// Creating user with email and password
        UserCredential user= await _auth.createUserWithEmailAndPassword(email: email, password: password);

        /// Creating user in firebase
        await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
          'uid': user.user!.uid,
          'username': _usernameController.text.trim(),
          'email': email,
        }).whenComplete(() {
          /// clear all the textFields
          clearTextField();
              print('user created');
              /// navigate to logIn screen
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
        });

      }on FirebaseAuthException catch(e) {
        /// showing the error in snackBar
        final SnackBar snackBar = SnackBar(content: Text(e.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),

            /// giving the column alignment of center vertical and left horizontal
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// heading signup
                  Container(
                      alignment: Alignment.center,
                      child: Text18Medium(color: primaryColor, text: 'SignUp')),

                  SizedBox(height: 40,),

                  /// label of username field
                  Text16Medium(color: primaryTextColor, text: 'Username'),

                  SizedBox(height: 20,),

                  /// text form field for username
                  TextFormField(
                    validator: (val)=> val!.trim().isEmpty? 'please give a username':null,
                    /// username controller
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Username',
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  /// text form field for email
                  Text16Medium(color: primaryTextColor, text: 'Email'),

                  SizedBox(height: 20,),

                  /// text form field for email
                  TextFormField(
                    validator: (val)=> val!.trim().isEmpty? 'please enter an email':null,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      hintText: 'Enter your Email',
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFf5f2f0))
                      ),
                    ),

                  ),

                  SizedBox(height: 20,),

                  /// text form field for password
                  Text16Medium(color: primaryTextColor, text: 'Password'),

                  SizedBox(height: 20,),

                  /// text form field for password
                  TextFormField(
                    validator: (val){
                      if(val!.trim().isEmpty){
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      hintText: '  Enter your Password',
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                  ),


                  SizedBox(height: 30,),

                  /// Button for signUp
                  GestureDetector(
                    onTap: (){
                      signUp(_emailController.text.trim(), _passwordController.text.trim());
                    },
                    child:PrimaryButton(color: primaryColor, text: 'SignUp'),
                  ),

                  SizedBox(height: 10,),


                  Row(
                    children: [
                      Text('Already have an account?', style: TextStyle(color: secondaryTextColor),),

                      GestureDetector(
                        onTap: (){
                          /// navigate to logIn page
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 1, color: primaryColor))
                            ),
                            child: Text(' LogIn',  style: TextStyle(color: primaryColor),)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
