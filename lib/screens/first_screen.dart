import 'package:flutter/material.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/appBarSingleAction.dart';
import 'package:logafic/widgets/firstSccreenColumnFirst.dart';
import 'package:logafic/widgets/firstScreenColumnThird.dart';
import 'package:logafic/widgets/smallFirstScreen.dart';

import 'package:logafic/widgets/firstScreenColumnSecond.dart';

// Web sayfasının adresi 'logafic.com/'
// Kullanıcıların karşılandığı sayfa .Giriş yapmamış kullanıcılar bu web sayfasına yönlendiriliyor.
//Kullanıcıların giriş ve kayıt olma arayüzüne yönlendirilmesi sağlanıyor.
// Bu web sayfası büyük ekranlı cihazlar için 3 adet widget bölünmüştür.
// Web sayfasının ekran görüntüsüne linkten ulaşılabilir. ' https://github.com/Logafic/logafic/blob/main/SS/first_screen_large.png '

class FirstScreenTopBarContents extends StatefulWidget {
  final double opacity = 8;
  final int fontSize = 16;
  @override
  _FirstScreenTopBarContentsState createState() =>
      _FirstScreenTopBarContentsState();
}

class _FirstScreenTopBarContentsState extends State<FirstScreenTopBarContents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.6),
        appBar: myAppBar(context, 'LOGAFIC', 'Giriş Yap', LoginRoute),
        body: ResponsiveWidget.isLargeScreen(context) ||
                ResponsiveWidget.isMediumScreen(context)
            ? Row(children: <Widget>[
                // Widget 1 logafic tanıtım yazıları.
                firstSccreenColumnFirst(context),
                // Karşılama ekranı görseli
                firstSccreenColumnSecond(context),
                // Yönlendirme butonları.
                firstScreenColumnThird(context),
              ])
            // Küçük ekranlı cihazlar için kullanılan widget
            : smallScreenFirstScreen(context));
  }
}
