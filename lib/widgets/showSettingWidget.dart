import 'package:flutter/material.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

// Ekran görüntüleri github adresi üzerinden erişilebilir. 'https://github.com/Logafic/logafic/blob/main/SS/setting_show_dialog.png'

class ShowSettingsWidget extends StatefulWidget {
  ShowSettingsWidget({Key? key}) : super(key: key);

  @override
  _ShowSettingsWidgetState createState() => _ShowSettingsWidgetState();
}

class _ShowSettingsWidgetState extends State<ShowSettingsWidget> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  // ThemeController themeController = ThemeController.to;

  @override
  Widget build(BuildContext context) {
    // String themeMode = themeController.currentTheme;
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height * 0.7
                  : height / 2,
              width:
                  ResponsiveWidget.isSmallScreen(context) ? width : width * 0.3,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              'Şifrenizi değiştirin',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                authController.updateUserPassword(
                                    oldPassController.text,
                                    newPassController.text,
                                    context);
                              },
                              icon: Icon(Icons.password_outlined),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            width: 400,
                            child: TextField(
                              controller: oldPassController,
                              obscureText: true,
                              decoration:
                                  InputDecoration(labelText: 'Geçerli şifre'),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: TextField(
                              controller: newPassController,
                              obscureText: true,
                              decoration:
                                  InputDecoration(labelText: 'Yeni şifre'),
                            ),
                          ),
                          // ListTile(
                          //   title: Text(
                          //     'Temayı değiştirin',
                          //     style: TextStyle(fontSize: 20.0),
                          //   ),
                          //   trailing: IconButton(
                          //     onPressed: () async {
                          //       themeController.currentTheme == 'light'
                          //           ? themeController.setThemeMode('dark')
                          //           : themeController.setThemeMode('light');
                          //       Get.changeThemeMode(themeController.isDarkModeOn
                          //           ? ThemeMode.light
                          //           : ThemeMode.dark);
                          //       setState(() {
                          //         themeMode = themeController.currentTheme;
                          //       });
                          //     },
                          //     icon: Icon(Icons.theater_comedy),
                          //   ),
                          // ),
                          // Divider(),
                          // SizedBox(
                          //     width: 400,
                          //     child: Text(
                          //       'Seçili tema : $themeMode',
                          //       style: TextStyle(fontSize: 20),
                          //     )),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }));
  }
}
