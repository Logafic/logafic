import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';

import 'package:logafic/widgets/formVerticalSpacing.dart';
import 'package:logafic/widgets/labelButton.dart';
import 'package:logafic/widgets/primaryButton.dart';
import 'package:logafic/widgets/formInputFieldWithIcon.dart';

// Login sayfasında yönlendirilen Şifreyi yenileme sayfası.
// şifresini unutan kullanıcılar için sistemde kayıtlı mail adresine şifre yenileme bağlantısı gönderen sayfa.
// Web sayfası adresi ' http://logafic.click/#/reset '
// Ekran görüntüsüne github adresi üzerinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/reset_screen_large.png '

class ResetPasswordUI extends StatelessWidget {
  // AuthController nesnesi oluşturulluyor.
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
                child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Şifre yenileme bağlantısı gönderilecek mail adresini tutan TextField
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'Email',
                    obscureText: false,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.emailController.text = value as String,
                  ),
                  FormVerticalSpace(),
                  PrimaryButton(
                      labelText: 'Yenileme bağlantısı gönder',
                      onPressed: () async {
                        // Mail adresinin siteme kayıtlı olması gerekir.
                        if (_formKey.currentState!.validate()) {
                          // Yenileme bağlantısı gönderiliyor.
                          await authController.sendPasswordResetEmail(context);
                        }
                      }),
                  FormVerticalSpace(),
                  signInLink(context),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  appBar(BuildContext context) {
    if (authController.emailController.text == '') {
      return null;
    }
    return AppBar(title: Text('auth.resetPasswordTitle'.tr));
  }

  // Geçerli mail adresi için bir validation methodu
  String? _validateEmail(String? email) {
    // 1
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    // Add the following line to set focus to the email field
    if (email!.isEmpty || !regex.hasMatch(email)) {}
    // 2
    if (email.isEmpty)
      return 'Bir e-posta adresine ihtiyacımız var';
    else if (!regex.hasMatch(email))
      // 3
      return "Bu bir e-posta adresine benzemiyor";
    else
      // 4
      return null;
  }

  // Giriş sayfasına yönlendirme işlemi gerçekleştiriliyor.
  signInLink(BuildContext context) {
    if (authController.emailController.text == '') {
      return LabelButton(
          labelText: 'Giriş Yap',
          onPressed: () {
            Navigator.pushNamed(context, LoginRoute);
          });
    }
    return Container(width: 0, height: 0);
  }
}
