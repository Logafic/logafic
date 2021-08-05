import 'package:flutter/material.dart';
// FirstScreen sayfasında kullanılan appbar widget

AppBar myAppBar(BuildContext context, String title, String? action1Name,
    String? routeName) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black.withOpacity(0.6),
        fontSize: 25,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: Text(
            action1Name!,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.pushNamed(context, routeName!);
          },
        ),
      )
    ],
  );
}
