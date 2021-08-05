import 'package:flutter/material.dart';

// Text widget first screen
Widget textFirstScreen(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 25, color: Colors.grey[400], fontWeight: FontWeight.w400),
    ),
  );
}
