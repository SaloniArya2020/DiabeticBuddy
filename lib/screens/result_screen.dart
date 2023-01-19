import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diebuddy/screens/authentication_screens/login_screen.dart';
import 'package:diebuddy/ui_elements/colors.dart';
import 'package:diebuddy/ui_elements/text_classes.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  String productName;
  String sugar;
  String carb;
  String calories;
  String servingWeight;

  ResultScreen(
      {Key? key,
      required this.productName,
      required this.carb,
      required this.sugar,
      required this.calories,
      required this.servingWeight})
      : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _resultStatement = '';
  bool _isSafe = false;
  int _safeQuantity = 0;
  int recommendedSugar = 24;


  calculateSugar() async{

    /// fetching the recommended sugar data
    DocumentSnapshot doc= await FirebaseFirestore.instance.collection('sugarIntake').doc(currentUserId).get();

    /// if doc exists
    if(doc.exists){
      /// set the recommended sugar value to given value
      setState(() {
        recommendedSugar = int.parse(doc['recommendedIntake']);
      });
    }

    /// checking is sugar equal to null
    if (widget.sugar != 'null') {
      /// converting string into int
      int sugar = int.parse(widget.sugar);

      /// if product contain more sugar than recommended
      if (sugar > recommendedSugar) {
        /// setting values as high sugar contain
        setState(() {
          _resultStatement = 'Warning: High sugar contain!';
          _isSafe = false;
        });
      } else {
        /// if serving weight is not given
        if (widget.servingWeight != 'null') {
          /// calculating the safe quantity of product to consume

          if(sugar != 0){
            setState(() {
              /// calculating safe sugar quantity
              _safeQuantity =((int.parse(widget.servingWeight)*recommendedSugar)/sugar).round();
            });
            setState(() {
              _resultStatement = 'You can have $_safeQuantity gm per day';
              _isSafe = true;
            });

          }else{
            setState(() {
              _resultStatement = 'You can eat it!';
              _isSafe = true;
            });
          }
        } else {
          setState(() {
            _resultStatement = 'You can have it! ';
            _isSafe = true;
          });
        }
      }
    } else {
      _resultStatement = 'No Sugar Contain Given!';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateSugar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,

          /// this is app bar
          appBar: AppBar(
            title:
                Text16Medium(color: primaryTextColor, text: 'Diabetic Buddy!'),
          ),

          /// giving horizontal and vertical padding
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text18Medium(
                          color: primaryTextColor, text: 'Product Name: '),

                      SizedBox(
                        height: 10,
                      ),

                      /// product name
                      Text16Medium(
                        color: primaryTextColor,
                        text: widget.productName != 'null'
                            ? '${widget.productName} '
                            : '-',
                      )
                    ],
                  ),
                ),

                Divider(),

                /// this container contains the value of sugar and carb in the product
                Container(
                  /// padding for left top right bottom sides
                  padding: const EdgeInsets.fromLTRB(20, 10, 40, 20),

                  /// padding for child widgets

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Result sugar contain in the product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text16Medium(color: primaryTextColor, text: 'Sugar'),

                          /// value of sugar
                          Text(
                            widget.sugar != 'null'
                                ? '${widget.sugar} gm'
                                : 'Not Given!',
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /// Result carb contain in the product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text16Medium(color: primaryTextColor, text: 'Carb')
                            ],
                          ),

                          /// value of carb
                          Text(
                            widget.carb != 'null'
                                ? '${widget.carb} gm'
                                : 'Not Given!',
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      /// Result calorie contain in the product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text16Medium(color: primaryTextColor, text: 'Calories'),

                          /// value of Calorie
                          Text(
                            widget.calories != 'null'
                                ? '${widget.calories} gm'
                                : 'Not Given!',
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text16Medium(color: primaryTextColor, text: 'Serving Weight'),

                          /// value of sugar
                          Text(
                            widget.servingWeight != 'null'
                                ? '${widget.servingWeight} gm'
                                : 'Not Given!',
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),


                /// Result for consumption
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: _isSafe ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     Text16Medium(color: primaryTextColor, text: 'Sugar Recommendation : '),
                      Divider(
                        height: 20,
                      ),
                      Text(
                        _resultStatement,
                        style: TextStyle(
                            fontSize: 16,
                            color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
    );
  }
}
