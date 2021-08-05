import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logafic/routing/router.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/authController.dart';

// BALIKESİR ÜNİVERSİTESİ BİLGİSAYAR MÜHENDİSLİĞİ
//           BİTİRME PROJESİ
// KAMPÜS İÇİ SOSYAL AĞ VE MEZUN OTOMASYONU

// DANIŞMAN
// Dr. Öğr. Üyesi Fatih AYDIN

// ÖĞRENCİLER
// YUNUS EMRE ARSLAN 201713709032
// MELAHAT BÜŞRA EKREN 201713709041

//  Mockuplar github adresi üzerinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/Mockup/mockup_2.jpg '

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put<AuthController>(AuthController());
  // Get.put<ThemeController>(ThemeController());
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // ThemeController themeController = ThemeController.to;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LOGAFIC',
      debugShowCheckedModeBanner: false,
      initialRoute: FirstRoute,
      navigatorKey: NavigationService().navigatorKey,
      // theme: themeController.getThemeModeFromStore(),
      onGenerateRoute: generateRoute,
    );
  }
}
