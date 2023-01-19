import 'package:flutter/material.dart';

class Text16Medium extends StatelessWidget {
  final String text;
   final Color color;

  Text16Medium({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: color),
    );
  }
}

class Text18Medium extends StatelessWidget {
 final String text;
 final Color color;

  Text18Medium({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: color),
    );
  }
}

class Text16Bold extends StatelessWidget {
  final String text;
  final Color color;

  Text16Bold({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: color),
    );
  }
}
