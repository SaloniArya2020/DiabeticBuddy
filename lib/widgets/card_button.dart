import 'package:diebuddy/ui_elements/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CardButton extends StatelessWidget {
  IconData icon;
  String text;

  CardButton({Key? key,  required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 40, horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.grey,
          offset: Offset(
            0.2,
            0.2
          ),
          blurRadius:0.1,
          spreadRadius: 0.1
        )],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
         Container(
           decoration: BoxDecoration(shape: BoxShape.circle, color: primaryAccentColor),
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: FaIcon(icon, size: 16, color: primaryColor,),
           ),
         ),

          SizedBox(
            height: 16,
          ),

          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
            ),
          )
        ],
      ),
    );
  }
}
