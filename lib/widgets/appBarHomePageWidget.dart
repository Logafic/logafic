import 'package:flutter/material.dart';

// HomePage ve JobsShareScreende kullanılan üst menü widget

AppBar appBarHomePageWidget() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      'LOGAFIC',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 20,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w400,
        letterSpacing: 3,
      ),
    ),
  );
}
