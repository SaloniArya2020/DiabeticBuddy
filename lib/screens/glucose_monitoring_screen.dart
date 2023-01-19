import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/ui_elements/buttons.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:diebuddy/ui_elements/text_classes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class GlucoseMonitoringScreen extends StatefulWidget {
  const GlucoseMonitoringScreen({Key? key}) : super(key: key);

  @override
  _GlucoseMonitoringScreenState createState() =>
      _GlucoseMonitoringScreenState();
}

class _GlucoseMonitoringScreenState extends State<GlucoseMonitoringScreen> {
  TextEditingController _fastingSugarController = TextEditingController();
  TextEditingController _afterMealSugarController = TextEditingController();

  clearInput() {
    _fastingSugarController.clear();
    _afterMealSugarController.clear();
  }

  ///deleting data from firebase
  deleteReading(String id) async {
    await FirebaseFirestore.instance
        .collection('GlucoseReadings')
        .doc(currentUserId)
        .collection('readings')
        .doc(id)
        .delete()
        .whenComplete(() {
      print('delete');
    });

    final snackBar = SnackBar(content: Text('data deleted!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// adding blood glucose function
  addGlucoseReading(String fasting, String afterMeal) async {
    try {
      String id =
          FirebaseFirestore.instance.collection('GlucoseReadings').doc().id;

      /// adding the glucose reading to firebase
      await FirebaseFirestore.instance
          .collection('GlucoseReadings')
          .doc(currentUserId)
          .collection('readings')
          .doc(id)
          .set({
        'id': id,
        'userId': currentUserId,
        'fastingBloodSugar': fasting,
        'afterMealBloodSugar': afterMeal,
        'timestamp': DateTime.now()
      }).whenComplete(() {
        final snackBar = SnackBar(content: Text('Data added!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      clearInput();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// this is app bar
      appBar: AppBar(
        title: Text('Diabetic Buddy'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// fasting sugar label
                Text16Medium(
                    color: secondaryTextColor, text: 'Fasting Sugar reading'),

                SizedBox(
                  height: 20,
                ),

                /// fasting blood sugar text field
                TextField(
                  controller: _fastingSugarController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Fasting Blood Sugar'),
                ),

                SizedBox(
                  height: 20,
                ),

                /// label for after meal sugar
                Text16Medium(
                    color: secondaryTextColor,
                    text: 'After Meal Sugar reading'),

                SizedBox(
                  height: 20,
                ),

                ///text field for after meal blood sugar
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _afterMealSugarController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Blood Sugar After Meal'),
                ),

                SizedBox(
                  height: 20,
                ),

                /// Button to add sugar reading
                GestureDetector(
                    onTap: () {
                      addGlucoseReading(_fastingSugarController.text.trim(),
                          _afterMealSugarController.text.trim());
                    },
                    child: PrimaryButton(color: primaryColor, text: 'Add')),

                Divider(
                  height: 50,
                ),

                /// Previous sugar readings
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Text('')),
                        Expanded(
                            flex: 2,
                            child: Text16Medium(
                              text: 'Date',
                              color: primaryTextColor,
                            )),
                        Expanded(
                            child: Text16Medium(
                          text: 'Fasting',
                          color: primaryTextColor,
                        )),
                        Expanded(
                            child: Text16Medium(
                          text: 'After Meal',
                          color: primaryTextColor,
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('GlucoseReadings')
                            .doc(currentUserId)
                            .collection('readings')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          /// if there is delay in data show circular indicator
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          return Column(
                              children: snapshot.data!.docs.map((doc) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// delete button
                                  GestureDetector(
                                    onTap: () {
                                      deleteReading(doc['id']);
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.circleMinus,
                                      color: Colors.red[400],
                                    ),
                                  ),

                                  SizedBox(
                                    width: 20,
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      /// formatting timestamp to date format
                                      DateFormat('MMMM, dd yyyy')
                                          .format(doc['timestamp'].toDate())
                                          .toString(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),

                                  /// showing fasting blood glucose reading
                                  Expanded(
                                    /// if the fasting sugar is more than 120 show it in red
                                    child: int.parse(doc['fastingBloodSugar']) >
                                            120
                                        ? Text(
                                            doc['fastingBloodSugar'],
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(
                                            doc['fastingBloodSugar'],
                                          ),
                                  ),

                                  /// showing after meal blood glucose reading
                                  Expanded(
                                    /// if the after meal sugar is more than 180 show it in red
                                    child: int.parse(doc['fastingBloodSugar']) >
                                            180
                                        ? Text(
                                            doc['afterMealBloodSugar'],
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(
                                            doc['afterMealBloodSugar'],
                                          ),
                                  )
                                ],
                              ),
                            );
                          }).toList());
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
