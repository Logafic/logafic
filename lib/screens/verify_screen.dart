import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/formVerticalSpacing.dart';

// Web sayfası adresi ' http://logafic.click/#/verify '
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/verify_screen.png '
//Email adresi doğrulanmamış kullanıcılar bu sayfaya yönlendirilir.

class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mail adresinizi onaylamanız gerekmektedir.',
              style: TextStyle(fontSize: 30),
            ),
            Text(
                'Lütfen mail kutunuzu kontrol ediniz. Onayladıktan sonra giriş yapabilirsiniz.',
                style: TextStyle(fontSize: 22)),
            ElevatedButton(
                onPressed: () {
                  authController
                      .signOut()
                      .whenComplete(() => Get.offAllNamed(LoginRoute));
                },
                child: Text('Giriş sayfasına git')),
            FormVerticalSpace(),
            ElevatedButton(
                onPressed: () {
                  authController.reSendVerifyEmail();
                },
                child: Text('Tekrar Gönder')),
          ],
        ),
      )),
    ));
  }
}
