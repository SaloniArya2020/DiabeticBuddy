import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diebuddy/screens/a1c_screen.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/screens/result_screen.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:diebuddy/ui_elements/text_classes.dart';
import 'package:diebuddy/widgets/card_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/userModel.dart';
import 'glucose_monitoring_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String barcode = '';
  String _productName = '';
  String _sugar = '';
  String _carb = '';
  String _calories = '';
  String _servingWeight = '';
  TextEditingController _recommendedSugarController = TextEditingController();
  int recommendedSugar = 24;
  String?username;
  final _key = GlobalKey<FormState>();

/// getting barcode scanned
  barcodeScanner() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'cancel', true, ScanMode.BARCODE);

    if (barcode.isNotEmpty) {
      /// url for api
      String url =
          'https://trackapi.nutritionix.com/v2/search/item?upc=$barcode';

      try {
        /// passing the headers
        final res = await http.get(Uri.parse(url), headers: {
          'x-app-id': '775232b4',
          'x-app-key': '6717bbca7cfd3ac4d88e9856f47bb5c5',
        });

        /// data body from API
        final body = jsonDecode(res.body);

        /// setting the values of nutrition
        setState(() {
          _productName = body['foods'][0]['food_name'].toString();
          _sugar = body['foods'][0]['nf_sugars'].toString();
          _carb = body['foods'][0]['nf_total_carbohydrate'].toString();
          _calories = body['foods'][0]['nf_calories'].toString();
          _servingWeight = body['foods'][0]['serving_weight_grams'].toString();
        });

        print(body['foods'][0]);
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('Product not found!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        throw e.toString();
      }
    }

    /// Navigating to result page with values received from the api
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  sugar: _sugar,
                  productName: _productName,
                  carb: _carb,
                  calories: _calories,
                  servingWeight: _servingWeight,
                )));
  }

  /// add recommended Sugar intake to firebase
  addSugarIntake() async{
    if(_key.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection('sugarIntake').doc(currentUserId).set({
          'recommendedIntake': _recommendedSugarController.text.trim()
        }).whenComplete(() {
          _recommendedSugarController.clear();
          Future.delayed(Duration(milliseconds: 700),(){
            Navigator.pop(context);
          });
        });
      }catch(e){
        print(e.toString());
      }
    }
  }

  /// bottom sheet for sugar intake
  sugarIntakeBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Text16Medium(
                      color: primaryTextColor,
                      text: 'Add daily recommended sugar intake in gm'),

                  SizedBox(
                    height: 20,
                  ),

                  /// add sugar intake text field
                  TextFormField(
                    validator: (val)=> val!.isEmpty?'please fill the input': null,
                    /// input type is number
                    keyboardType: TextInputType.number,
                    controller: _recommendedSugarController,
                    decoration: InputDecoration(
                        hintText: 'Sugar Intake in gm per Day',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  /// button to add sugar intake
                  GestureDetector(
                    onTap: () {
                      addSugarIntake();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  getUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

   setState(() {
     username = doc['username'];
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    });
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /// app bar
        appBar: AppBar(
          title: Text16Medium(color: Colors.black54, text: 'Diabetic Buddy'),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryAccentColor,
          onPressed: (){
            FirebaseAuth.instance.signOut().whenComplete(() {
              print(currentUserId);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
            });
          },
          child: FaIcon(FontAwesomeIcons.arrowRightFromBracket, color: primaryColor,),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Greeting text
                  Container(
                      child: Text16Medium(
                    text: 'Hello $username !',
                    color: primaryTextColor,
                  )),

                  SizedBox(
                    height: 30,
                  ),

                  /// row for barcode scanner and sugar intake button
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: barcodeScanner,
                            child: CardButton(
                                icon: FontAwesomeIcons.barcode,
                                text: 'Scan Barcode')),
                      ),
                      SizedBox(
                        width: 10,
                      ),

                      /// button to open sugar intake bottom sheet to add sugar intake per day
                      Expanded(
                        child: GestureDetector(
                          onTap: sugarIntakeBottomSheet,
                          child: CardButton(
                            text: 'Sugar Intake/Day',
                            icon: FontAwesomeIcons.cubesStacked,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      /// button for adding glucose level
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GlucoseMonitoringScreen()));
                            },
                            child: CardButton(
                                icon: FontAwesomeIcons.droplet,
                                text: ' Glucose level')),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      /// button to add A1C
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => A1CScreen()));
                          },
                          child: CardButton(
                            text: 'A1C',
                            icon: FontAwesomeIcons.notesMedical,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
