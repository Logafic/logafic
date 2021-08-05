import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/widgets/background.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/messageScreenWidget.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showSettingWidget.dart';
import 'package:logafic/widgets/userMessageScreenWidget.dart';

// Web sayfası adresi ' http://logafic.click/#/message '
// Mesweb sayfası iki bölümden oluşur tüm kullanıcıların görüntülendiği ve istenilen kullanıcıya mesaj gönderilen ve mesaj gönderilmiş kullanıcıların görüntülendiği bölümler.
// Sayfanın ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/message_screen_large.png '
// Gönderilen mesaj hem gönderen hemde mesaj gönderilen kişinin message koleksiyonuna ekleniyor.

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Kullanıcıların görüntülenmesi için Firestore referans adresi
  final Stream<QuerySnapshot> _usersMessageStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  // AuthController nesnesi oluşturuluyor.
  AuthController authController = AuthController.to;

  // Kullanıcıların görüntülendiği widget
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final headerList = new StreamBuilder(
      stream: _usersMessageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Asenkron olarak indirilen veriler snapshot değişkeni içerisinde tutuluyor.

        // Verilerin indirilmesi esnasında ekrana çıktı olarak dairesel işlem göstergesi veriliyor.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // Verilerin indirilmesi sırasında bir hatayla karşılaşılması durumunda ekrana çıktı veriliyor.
        if (snapshot.hasError) {
          return Text('Bir şeyler yanlış gitti');
        }
        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return new Padding(
              padding: EdgeInsets.all(8),
              // Diğer kullanıcıların görüntülenmesi sağlanıyor.
              child: authController.firebaseUser.value!.uid == data['userId']
                  ? Text('')
                  : new InkWell(
                      onTap: () {
                        // Mesaj göndermek ve gönderilen mesajları görüntülemek için kullanılan show  dialog
                        messageShowDialogWidget(context, data['userName'],
                            data['userProfileImage'], data['userId']);
                      },
                      child: new Container(
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Colors.black12,
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  offset: const Offset(3.0, 10.0),
                                  blurRadius: 15.0)
                            ],
                            image: new DecorationImage(
                              image:
                                  NetworkImage('${data['userProfileImage']}'),
                            )),
                        width: 200.0,
                        child: new Stack(
                          children: <Widget>[
                            new Align(
                              alignment: Alignment.bottomCenter,
                              child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: new BorderRadius.only(
                                          bottomLeft: new Radius.circular(10.0),
                                          bottomRight:
                                              new Radius.circular(10.0))),
                                  height: 30.0,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        '${data['userName']}',
                                        style:
                                            new TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
            );
          }).toList(),
          scrollDirection: Axis.horizontal,
        );
      },
    );

    final body = new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
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
        title: Text(
          'Mesajlar',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            letterSpacing: 3,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeRoute);
              },
              child: Text(
                'Anasayfa',
                style: TextStyle(color: Colors.black54),
              )),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: InkWell(
                child: PopupMenuButton(
              icon: Icon(
                Icons.person,
                color: Colors.black54,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileRoute, arguments: {
                        'userId': authController.firebaseUser.value!.uid
                      });
                    },
                    leading: Icon(Icons.person),
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
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        // Sayfa boyutuna göre genişlik ayarlanıyor.
        child: new Container(
          width: ResponsiveWidget.isSmallScreen(context)
              ? MediaQuery.of(context).size.width * 0.9
              : MediaQuery.of(context).size.width * 0.7,
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Padding(
                          padding: new EdgeInsets.only(left: 14.0),
                          child: new Text(
                            'Kişiler',
                            style: new TextStyle(
                                color: Colors.white70, fontSize: 25),
                          )),
                    ),
                    new Container(
                        height: 300.0, width: _width, child: headerList),
                    Padding(
                      padding: EdgeInsets.all(22),
                      child: new Text(
                        'Son Mesajlar',
                        style: TextStyle(
                            fontSize: ResponsiveWidget.isLargeScreen(context)
                                ? 20
                                : 30),
                      ),
                    ),
                    new Expanded(
                        // Kullanıcının diğer kullanıcılara gönderdiği son mesajların görüntülendiği widget
                        child: MessageScreenUserMessagesWidget())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Arka plan tasarımı ekleniyor.
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.black26,
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
            size: new Size(_width, _height),
            painter: new Background(),
          ),
          body,
        ],
      ),
    );
  }
}
