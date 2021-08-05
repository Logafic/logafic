// Validation işlemleri için kullanılan sınıf

class HelpersValidate {
  String? validateEmail(String? email) {
    // 1
    RegExp regex = RegExp(r'\w+@\w+\.\w+');

    if (email!.isEmpty || !regex.hasMatch(email))

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

  String? validatePassword(String? pass1) {
    RegExp hasUpper = RegExp(r'[A-Z]');
    RegExp hasLower = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    if (!RegExp(r'.{8,}').hasMatch(pass1!))
      return 'Şifreler en az 8 karakter içermelidir';
    if (!hasUpper.hasMatch(pass1))
      return 'Parolalar en az bir büyük harf içermelidir';
    if (!hasLower.hasMatch(pass1))
      return 'Parolalar en az bir küçük harf içermelidir';
    if (!hasDigit.hasMatch(pass1))
      return 'Parolalar en az bir rakam içermelidir';
    return null;
  }

  String? validateTerms(bool agree) {
    return agree ? null : "Kullanıcı şözleşmesini kabul etmelisiniz !";
    // It's invalid if the user hasn't opted in by checking the box
  }
}
