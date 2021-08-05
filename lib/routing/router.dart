import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/screens/jobs_share_screen.dart';
import 'package:logafic/screens/showUserInformationScreen.dart';
import 'package:logafic/screens/show_my_jobs_posts.dart';
//Screens
import 'package:logafic/screens/status_screen.dart';
import 'package:logafic/screens/home_page.dart';
import 'package:logafic/screens/login_screen.dart';
import 'package:logafic/screens/message_screen.dart';
import 'package:logafic/screens/notification_screen.dart';
import 'package:logafic/screens/profile_screen.dart';
import 'package:logafic/screens/register_screen.dart';
import 'package:logafic/screens/first_screen.dart';
import 'package:logafic/screens/reset_password_screen.dart';
//Extensions
import 'package:logafic/extensions/string_extensions.dart';
import 'package:logafic/screens/update_user_information.dart';
import 'package:logafic/screens/user_information_screen.dart';
import 'package:logafic/screens/verify_screen.dart';

// Yönlendirme işlemlerinin yapıldığı ana method.
// Giriş yapmamış kullanıcı Login,Register,Reset ve FirstScreen sayflarını görüntüleyebilir.
// Ayrıntılı incleme için ' https://medium.com/flutter/flutter-web-navigating-urls-using-named-routes-307e1b1e2050 '
Route<dynamic> generateRoute(RouteSettings settings) {
  // AuthController nesnesi oluşturuluyor.
  AuthController authController = AuthController.to;

  var routingData = settings.name?.getRoutingData;
  switch (routingData?.route) {

    // Başlangıç sayfası yönlendirmesi '/'
    case FirstRoute:
      return _getPageRoute(FirstScreenTopBarContents(), settings);
    // Anasayfa yönlendirmesi '/home'
    case HomeRoute:
      return _getPageRoute(HomePage(), settings);
    // Mesaj sayfası yönlendirmesi '/message'
    case MessageRoute:
      return authController.firebaseUser.value!.uid == ''
          ? _getPageRoute(FirstScreenTopBarContents(), settings)
          : _getPageRoute(MyHomePage(), settings);
    // Bildirim sayfası yönlendirmesi '/notification'
    case NotificationRoute:
      return authController.firebaseUser.value!.uid == ''
          ? _getPageRoute(FirstScreenTopBarContents(), settings)
          : _getPageRoute(NotificationScreen(), settings);
    // İş ve etkinlik ilanı yönlendirmesi '/jobs'
    case JobsScreenRoute:
      return _getPageRoute(JobsShareScreen(), settings);
    // Kullanıcı profil bilgilerinin görüntülendiği sayfa '/fullProfile' parametre olarak userId almaktadır.
    case FullProfileRoute:
      final arguments = settings.arguments as Map<String, dynamic>;
      return _getPageRoute(
          ShowFullUserInformationScreen(
            userId: arguments['userId'],
          ),
          settings);
    // Profil sayfasının yönlendirmesi '/profile' parametre olarak userId almaktadır.
    case ProfileRoute:
      final arguments = settings.arguments as Map<String, dynamic>;
      return authController.firebaseUser.value!.uid == ''
          ? _getPageRoute(FirstScreenTopBarContents(), settings)
          : _getPageRoute(
              ProfileScreen(
                userId: arguments['userId'],
              ),
              settings);
    // Kullanıcı profil bilgilerinin güncellendiği sayfa yönlendirmesi '/update' paremetre olarak userId almaktadır.
    case UpdateUserInformationRoute:
      final arguments = settings.arguments as Map<String, dynamic>;
      return authController.firebaseUser.value!.uid == ''
          ? _getPageRoute(FirstScreenTopBarContents(), settings)
          : _getPageRoute(
              UpdateUserInformation(userId: arguments['userId']), settings);

    // Kullanıcı kayıt sayfası yönlendirmesi '/register'
    case RegisterRoute:
      return _getPageRoute(RegisterScreen(), settings);
    // Email doğrulama sayfası yönlendirmesi '/verify'
    case VerifyScreenRoute:
      return _getPageRoute(VerifyScreen(), settings);
    // Kullanıcının paylaştığı iş ve etkinliklerin görüntülendiği sayfanın yönlendirmesi '/myJobs'
    case MyJobsRoute:
      return _getPageRoute(ShowMyJobsPostScreen(), settings);
    // Şifre yenileme bağlantısının gönderildiği sayfa yönlendirmesi '/reset'
    case ResetRoute:
      return _getPageRoute(ResetPasswordUI(), settings);
    // Paylaşımların görüntülendiği sayfanın yönlendirilmesi '/status' parametre olarak postId almaktadır.
    case StatusRoute:
      final arguments = settings.arguments as Map<String, dynamic>;
      return _getPageRoute(
          StatusScreen(
            id: arguments['id'],
          ),
          settings);
    // Kullanıcı profilinin oluşturulduğu sayfa yönlendirmesi '/save'
    case UserInformationRoute:
      return authController.firebaseUser.value!.uid == ''
          ? _getPageRoute(FirstScreenTopBarContents(), settings)
          : _getPageRoute(UserInformation(), settings);

    // Varsayılan olarak giriş sayfasına yönlendirme işlemi yapılıyor '/login'
    default:
      return _getPageRoute(LoginScreen(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String? routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
