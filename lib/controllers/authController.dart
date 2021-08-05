import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logafic/data_model/user_profile_model.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/loading.dart';

// Contoller tasarımında GetX paketi kullanılmıştır. Getx hızlı kod yazılmasını sağlayan hızlı ve performanslı bir flutter paketidir.
// Ayrıntılı bilgi için ' https://pub.dev/packages/get#about-get '
// kimlik doğrulama işlemlerinin yönetildiği kontroller.
// Giriş yapmamış kullanıcılar Başlangıç ekranına yönlendirilir. (firs_screen.dart)
// Yeni kayıt olmuş kullanıcı Profil oluşturma sayfasına yönlendirilir. (user_information_screen.dart)
// Giriş yapmış kullanıcı anasayfaya yönlendirilir. (home_page.dart)
// Email doğrulanmamış kullanıcılar doğrulama ekranına yönlendirilir. (verify_screen.dart)
// Kullanıcı giriş işlemleri, kullanıcı kayıt işlemleri ve giriş yapmış kullanıcı işlemlerinin tümü bu kontrollerda yapılmaktadır.
// Nesne oluşturmak için ' AuthController authController=AuthController.to; ' yeterli olacaktır.
// Giriş yapmış kullanıcının userId'sine ulaşmak için ' authController.firebaseUser.value.uid; ' yeterli olacaktır.
// Giriş yapmış kullanıcının firestore profil bildilerine ulaşmak için ' authController.firestoreUser.value.{X} ' yeterli olacaktır.

class AuthController extends GetxController {
  // AuthController nesnesi oluşturma.
  static AuthController to = Get.find();
  // Kurum mail adresinin tutulduğu değişken.
  TextEditingController eduMailController = TextEditingController();
  // Email adresini tutan değişken
  TextEditingController emailController = TextEditingController();
  // Şifreyi tutan değişken
  TextEditingController passwordController = TextEditingController();
  // FirebaseAuth nesnesi oluşturuluyor.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseFireastore nesneni oluşturuluyor.
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserProfile> firestoreUser = Rxn<UserProfile>();
  // Yeni kullanıcıların profil oluşturulma sayfasına yönlendirilmesi için kullanılıyor.
  bool newUser = false;
  // Anasayfada trend gönderilerin ve akış zamanına göre sıralama işleminde kullanılıyor.
  bool isRank = false;

  // Kullanıcı değişiklikleri dinleniyor.
  @override
  void onReady() {
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(user);
    super.onReady();
  }

  void onClose() {
    eduMailController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) {
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    }
    if (_firebaseUser == null) {
      Get.offAllNamed(FirstRoute);
    } else {
      if (newUser == false) {
        firebaseUser.value!.emailVerified
            ? Get.offAllNamed(HomeRoute)
            : Get.offAllNamed(VerifyScreenRoute);
      } else {
        firebaseUser.value!.emailVerified
            ? Get.offAllNamed(UserInformationRoute)
            : Get.offAllNamed(VerifyScreenRoute);
      }
    }
  }

  Future<bool?> get getNotification async =>
      authController.firestoreUser.value!.unreadNotification;
  Future<bool?> get getMessage async =>
      authController.firestoreUser.value!.unreadMessage;

  // Email doğrulaması kontrol method.
  Future<bool?> get getVerify async => _auth.currentUser!.emailVerified;

  // Giriş yapmış kullanıcı kontrol methodu
  Future<User?> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  Stream<UserProfile> streamFirestoreUser() {
    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserProfile.fromMap(snapshot.data()!));
  }

  Future<UserProfile> getFirestoreUser() {
    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .get()
        .then((snapshot) => UserProfile.fromMap(snapshot.data()!));
  }

  // Mail ve şifreyle giriş
  signInWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
      hideLoadingIndicator();
    } on FirebaseAuthException catch (err) {
      hideLoadingIndicator();
      Get.snackbar('Giriş hatası', '${err.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // Kullanıcı kayıt işlemlerinin gerçekleştiği method
  registerWithEmailAndPassword(BuildContext context) async {
    try {
      showLoadingIndicator();
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) async {
        result.user!.updateDisplayName(eduMailController.text);
        result.user!.sendEmailVerification();
        hideLoadingIndicator();
      });
    } on FirebaseAuthException catch (err) {
      hideLoadingIndicator();
      Get.snackbar('Kayıt işleminde hata oluştu.', err.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  void createUserFirestore(UserProfile user, User _firebaseUser) {
    _db
        .doc('/users/${_firebaseUser.uid}')
        .set(user.toJson())
        .whenComplete(() => Get.offAllNamed(HomeRoute));
  }

  // Şifre yenileme için doğrulama maili gönderen method
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      hideLoadingIndicator();
      Get.snackbar('Şifreme yenileme bağlantı'.tr,
          'Şifrenizi yenilemeniz için bağlantı email adresinize gönderildi.'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (err) {
      hideLoadingIndicator();
      Get.snackbar('Şifre yenileme hatası'.tr, err.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  Future<void> reSendVerifyEmail() async {
    _auth.currentUser!.sendEmailVerification().whenComplete(() {
      Get.snackbar('Şifreme yenileme bağlantı'.tr,
          'Şifrenizi yenilemeniz için bağlantı email adresinize gönderildi.'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    });
  }

  Future<void> updateUserPassword(
      String oldPassword, String newPassword, BuildContext context) async {
    _auth.currentUser!.updatePassword(newPassword).whenComplete(() {
      Navigator.pop(context);
    });
  }

  // Çıkış yapılan method
  Future<void> signOut() {
    eduMailController.clear();
    emailController.clear();
    passwordController.clear();
    return _auth.signOut();
  }
}
