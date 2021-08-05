import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/showCommentDialogStatusWidget.dart';
import 'package:logafic/widgets/showReportStatusScreen.dart';
import 'package:logafic/widgets/showSettingWidget.dart';

import 'messageScreenWidget.dart';

// StatusScreen menü bar

//
// ignore: must_be_immutable
class MenuActionBar extends StatelessWidget {
  AuthController authController = AuthController.to;
  String postId;
  String userName;
  String userProfileImage;
  String userId;
  String content;
  String urlImage;
  String createAt;
  MenuActionBar({
    Key? key,
    required this.postId,
    required this.userName,
    required this.userId,
    required this.userProfileImage,
    required this.content,
    required this.urlImage,
    required this.createAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(
              Icons.reply,
              color: Colors.black,
            ),
            tooltip: 'Yanıtla',
            onPressed: () {
              showCommentPostShareWidget(context, postId, userId, content,
                  urlImage, userProfileImage, userName, createAt);
            }),
        IconButton(
            icon: const Icon(
              Icons.message,
              color: Colors.black,
            ),
            tooltip: 'Mesaj Gönder',
            onPressed: () {
              messageShowDialogWidget(
                  context, userName, userProfileImage, userId);
            }),
        IconButton(
            icon: const Icon(
              Icons.notification_important,
              color: Colors.black,
            ),
            tooltip: 'Bildir',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ShowReportStatusScreenWidget(
                      postId: postId,
                    );
                  });
            }),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: InkWell(
              child: PopupMenuButton(
            icon: Icon(
              Icons.person,
              color: Colors.black45,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, ProfileRoute, arguments: {
                      'userId': authController.firebaseUser.value!.uid
                    });
                  },
                  leading: Icon(Icons.reorder),
                  title: Text('Profilim'),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, NotificationRoute);
                  },
                  leading: Icon(Icons.notification_important),
                  title: Text('Bildirimler'),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, MessageRoute);
                  },
                  leading: Icon(Icons.message),
                  title: Text('Mesajlar'),
                ),
              ),
              // authController.firestoreUser.value!.isAdmin == true
              //     ? PopupMenuItem(
              //         child: ListTile(
              //           onTap: () {},
              //           leading: Icon(Icons.message),
              //           title: Text('İlanlarım'),
              //         ),
              //       )
              //     : PopupMenuItem(
              //         child: ListTile(
              //           onTap: () {},
              //           title: Text(''),
              //         ),
              //       ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ShowSettingsWidget();
                        });
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Ayarlar'),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                  child: ListTile(
                onTap: () async {
                  await authController
                      .signOut()
                      .whenComplete(() => Get.offAllNamed(FirstRoute));
                },
                title: Text('Çıkış Yap'),
              )),
            ],
          )),
        ),
      ],
    );
  }
}
