import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:diebuddy/ui_elements/text_classes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class A1CScreen extends StatefulWidget {
  const A1CScreen({Key? key}) : super(key: key);

  @override
  _A1CScreenState createState() => _A1CScreenState();
}

class _A1CScreenState extends State<A1CScreen> {
  TextEditingController _a1cController = TextEditingController();
  final _key = GlobalKey<FormState>();

  deleteData(String id) async {
    await FirebaseFirestore.instance
        .collection('A1C')
        .doc(currentUserId)
        .collection('readings')
        .doc(id)
        .delete()
        .whenComplete(() {
      print('delete');
    });
  }

  addingData(String a1c) async {
    /// validating the form
    if (_key.currentState!.validate()) {
      try {
        /// random id
        String id = FirebaseFirestore.instance.collection('A1C').doc().id;

        /// Adding the reading to database
        await FirebaseFirestore.instance
            .collection('A1C')
            .doc(currentUserId)
            .collection('readings')
            .doc(id)
            .set({
          'id': id,
          'userId': currentUserId,
          'A1C': a1c,
          'timestamp': DateTime.now()
        });

        /// clear the input field
        _a1cController.clear();

        /// show snack bar after function completed its work
        final snackBar = SnackBar(content: Text('data added!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text16Medium(
          text: 'Diabetic Buddy!',
          color: primaryTextColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// text field label
              Text('HbA1C < 6.5 is higher level'),
              SizedBox(
                height: 20,
              ),

              Text16Medium(
                  color: primaryTextColor, text: 'Add Your 3 Month A1C'),

              SizedBox(
                height: 10,
              ),

              /// text field to add A1C
              Form(
                key: _key,
                child: TextFormField(
                  validator: (val) => (val!.trim().isEmpty ||
                          double.parse(val!) > 10 ||
                      double.parse(val!) < 4)
                      ? 'HbA1C should be between 4-10'
                      : null,
                  controller: _a1cController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Write A1C here...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              /// button to submit
              GestureDetector(
                onTap: () {
                  addingData(_a1cController.text.trim());
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              Divider(
                height: 40,
              ),

              /// heading row for date and reading
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        Text16Medium(color: primaryTextColor, text: 'Date'),
                        Text16Medium(color: primaryTextColor, text: 'Reading')
                      ],
                    ),
                    Divider(
                      height: 40,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('A1C')
                            .doc(currentUserId)
                            .collection('readings')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          deleteData(doc['id']);
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.circleMinus,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                      Text(
                                        /// formatting timestamp to date format
                                        DateFormat('MMMM, dd yyyy')
                                            .format(doc['timestamp'].toDate())
                                            .toString(),
                                      ),

                                      /// if the A1C is 6 show it in red
                                      double.parse(doc['A1C']) > 6
                                          ? Text(
                                              doc['A1C'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          : Text(doc['A1C'])
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
