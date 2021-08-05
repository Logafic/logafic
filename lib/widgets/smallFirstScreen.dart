import 'package:flutter/material.dart';
import 'package:logafic/routing/router_names.dart';

// Küçük ekranlar için kullanılan first screen widget
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/first_screen_small.png '

Widget smallScreenFirstScreen(BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/FirstScreenImage.png',
              width: MediaQuery.of(context).size.width * 6 / 10,
              height: MediaQuery.of(context).size.height * 6 / 10,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'İçerikleri görüntülemek için Giriş yap veya Kayıt ol.',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w200),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black26)),
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginRoute);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  child: Text(
                    'Kayıt Ol',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterRoute);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
