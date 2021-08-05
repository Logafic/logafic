import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:flutter/material.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/services/notificationService.dart';
import 'package:logafic/widgets/showSettingWidget.dart';

// Anasayfa üst menü

class TopBarContents extends StatefulWidget {
  final double opacity;
  final int fontSize = 16;

  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {
  AuthController authController = AuthController.to;

  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: Theme.of(context).splashColor.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'LOGAFIC',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenSize.width / 8),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[0] = true
                              : _isHovering[0] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, HomeRoute);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Anasayfa',
                            style: TextStyle(
                              color: _isHovering[0] ? Colors.red : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[0],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.black45,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[1] = true
                              : _isHovering[1] = false;
                        });
                      },
                      onTap: () async {
                        Navigator.pushNamed(context, NotificationRoute);
                        setReadNotification();
                      },
                      child: FutureBuilder(
                        future: authController.getNotification,
                        initialData: false,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              snapshot.data == true
                                  ? Text(
                                      'Bildirimler',
                                      style: TextStyle(
                                        color: _isHovering[1]
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Text(
                                      'Bildirimler',
                                      style: TextStyle(
                                        color: _isHovering[1]
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[1],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[2] = true
                              : _isHovering[2] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, MessageRoute);
                        setReadMessage();
                      },
                      child: FutureBuilder(
                        future: authController.getMessage,
                        initialData: false,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              snapshot.data == true
                                  ? Text(
                                      'Mesajlar',
                                      style: TextStyle(
                                        color: _isHovering[2]
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Text(
                                      'Mesajlar',
                                      style: TextStyle(
                                        color: _isHovering[2]
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                              SizedBox(height: 5),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _isHovering[2],
                                child: Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[4] = true
                              : _isHovering[4] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, JobsScreenRoute);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'İş ve Etkinlik ilanları',
                            style: TextStyle(
                              color: _isHovering[4] ? Colors.red : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[4],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.black45,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width / 50,
              ),
              InkWell(
                  onHover: (value) {
                    setState(() {
                      value ? _isHovering[3] = true : _isHovering[3] = false;
                    });
                  },
                  onTap: () {},
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black45,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProfileRoute, arguments: {
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
            ],
          ),
        ),
      ),
    );
  }
}
