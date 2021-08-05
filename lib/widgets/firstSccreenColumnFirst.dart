import 'package:flutter/material.dart';
import 'package:logafic/widgets/textFirstScreen.dart';

// FirstScreen 1. Sütun
Widget firstSccreenColumnFirst(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 3 / 10,
        height: MediaQuery.of(context).size.height * 9 / 10,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              textFirstScreen('Karşılaştığın sorunları bizlerle paylaş.'),
              textFirstScreen('Başkalarının hayatlarına dokun.'),
              textFirstScreen('Senin gibi düşünen arkadaşlar edin.'),
            ],
          ),
        ),
      ),
    ],
  );
}
