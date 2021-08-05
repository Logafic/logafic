import 'package:flutter/material.dart';
import 'package:logafic/routing/router_names.dart';
// FirstScreen 3. sütun

Widget firstScreenColumnThird(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 4 / 10,
        height: MediaQuery.of(context).size.height * 9 / 10,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'İçerikleri görüntülemek için Giriş yap veya Kayıt ol.',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400),
                ),
              ),
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
        ),
      ),
    ],
  );
}
