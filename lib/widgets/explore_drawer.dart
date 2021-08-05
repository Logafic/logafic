import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';

// Küçük ekranlı cihazlar için kullanılan menü
// Ekran görüntüsü github üzerinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/show_menu_bar.png '
// Home page ve JobsShareScreen sayfalarında kullanılıyor.

class ExploreDrawer extends StatefulWidget {
  const ExploreDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _ExploreDrawerState createState() => _ExploreDrawerState();
}

class _ExploreDrawerState extends State<ExploreDrawer> {
  AuthController authController = AuthController.to;
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        authController.firestoreUser.value!.userProfileImage !=
                                null
                            ? NetworkImage(authController
                                .firestoreUser.value!.userProfileImage!)
                            : null,
                    child:
                        authController.firestoreUser.value!.userProfileImage ==
                                null
                            ? Icon(
                                Icons.account_circle,
                                size: 40,
                              )
                            : Container(),
                  ),
                  SizedBox(width: 10),
                  Text(
                    authController.firestoreUser.value!.userName ?? 'Name',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              authController.firebaseUser.value!.uid != ''
                  ? Container(
                      width: double.maxFinite,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                setState(() {
                                  _isProcessing = true;
                                });
                                authController.signOut().then((result) {
                                  Get.offAllNamed(FirstRoute);
                                }).catchError((error) {
                                  print('Çıkış yaparken hata oluştu: $error');
                                });
                                setState(() {
                                  _isProcessing = false;
                                });
                              },
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(15),
                        // ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 15.0,
                            bottom: 15.0,
                          ),
                          child: _isProcessing
                              ? CircularProgressIndicator()
                              : Text(
                                  'Çıkış yap',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : Container(),
              authController.firebaseUser.value!.uid != ''
                  ? SizedBox(height: 20)
                  : Container(),
              InkWell(
                onTap: () {
                  Get.toNamed(HomeRoute);
                },
                child: Text(
                  'Anasayfa',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ProfileRoute, arguments: {
                    'userId': authController.firebaseUser.value!.uid
                  });
                },
                child: Text(
                  'Profil',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(MessageRoute);
                },
                child: Text(
                  'Mesajlar',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(NotificationRoute);
                },
                child: Text(
                  'Bildirimler',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, JobsScreenRoute);
                },
                child: Text(
                  'İş ilanları',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Copyright © 2021 | LOGAFIC',
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
