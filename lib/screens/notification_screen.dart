import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/background.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showSettingWidget.dart';

// Web sayfası adresi ' http://logafic.clicki/#/notification '
// Kullanıcı bildirimlerin görüntülendiği web sayfası kullanıcının paylaşımlarına yapılan beğeni ve yorumlarına yapılan işlemlerin görüntülendiği sayfa
// Cloud Firestore notifications koleksiyonu içerisinde her kullanıcının userId'si ile oluşturulan dokümanlar üzerinde depolanmaktadır.
// notificationService ile bildirimlerin eklenmesi ve görüntülenen bildirimlerin işaretlenme işlemleri yapılıyor.
// Ekran görüntüsü github adresi üzerinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/notification_screen_large.png '

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    // AuthController nesnesi oluşturuluyor.
    AuthController authController = AuthController.to;

    // Bildirimleri depolandığı firestore koleksiyonunun referans adresi, bildirimlerin silinmesi için kullanılıyor.
    CollectionReference notiRef =
        FirebaseFirestore.instance.collection('notifications');
    // Bildirimlerin bir liste şeklinde indirilmesi için kullanılan referans adresi
    final Stream<QuerySnapshot> _notificationSteam = FirebaseFirestore.instance
        .collection('notifications')
        .doc('${authController.firebaseUser.value!.uid}')
        .collection('userNotification')
        .snapshots();

    // Web sayfası scaffold sınıfı ile çerçeveleniyor.
    final body = new Scaffold(
      // Üst menü başlangıç
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
          'Bildirimler',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeRoute);
              },
              child: Text(
                'Anasayfa',
                style: TextStyle(color: Colors.black54, fontSize: 17),
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
      // Üst menü bitiş
      backgroundColor: Colors.transparent,
      body: new Container(
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      child: Scrollbar(
                          child: StreamBuilder<QuerySnapshot>(
                    stream: _notificationSteam,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // İndirilen verilerin boş olması durumunda
                      if (snapshot.data == null) {
                        return Center(
                          child: Text(
                            'Henüz bir bildiriminiz bulunmamaktadır.',
                            style: TextStyle(
                                fontSize:
                                    ResponsiveWidget.isLargeScreen(context)
                                        ? 10
                                        : 20),
                          ),
                        );
                      }
                      // Verilerin indirilmesi esnasında ekrana çıktı olarak dairesel işlem göstergesi veriliyor.
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // İndirilen bildirim verilerinin görselleştirilmesi için ListView sınıfı kullanılıyor.
                      return new ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Container(
                                  width: ResponsiveWidget.isSmallScreen(context)
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : MediaQuery.of(context).size.width * 0.5,
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Yorum ve beğeni bildirimlerinin birbirinden ayrılması için type verisi kullanılıyor.
                                        data['type'] == 'Like'
                                            ? TextButton(
                                                child: Text(
                                                  ('${data['userName']} gönderinizi beğendi'),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                                onPressed: () {
                                                  // Beğeni bildirimini yapan kullanıcının profili görüntüleniyor.
                                                  Navigator.pushNamed(
                                                      context, ProfileRoute,
                                                      arguments: {
                                                        'userId': data['userId']
                                                      });
                                                },
                                              )
                                            : TextButton(
                                                child: Text(
                                                  ('${data['userName']} gönderinize yorum yaptı.'),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                                onPressed: () {
                                                  // Yorum yapılan gönderi görüntüleniyor
                                                  Navigator.pushNamed(
                                                      context, StatusRoute,
                                                      arguments: {
                                                        'id': data['userId']
                                                      });
                                                },
                                              ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                    subtitle: Text('${data['created_at']}\n'),
                                    leading:
                                        Image.network('${data['userImage']}'),
                                  ),
                                ),
                              ),
                              IconButton(
                                // Bildirimlerin silinmesi için kullanlan IconButton
                                icon: Icon(Icons.delete_outline_rounded),
                                tooltip: 'Sil',
                                color: Colors.black54,
                                onPressed: () {
                                  try {
                                    // Silme işlemi kullanıcın bildirimlerinin bulunduğu koleksiyon referansından silme işlemi gerçekleştiriliyor.
                                    notiRef
                                        .doc(
                                            '${authController.firebaseUser.value!.uid}')
                                        .collection('userNotification')
                                        .doc('${document.id}')
                                        .delete()
                                        .whenComplete(() {
                                      Get.snackbar('Silindi',
                                          'Bildirim başarıyla silindi.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: Duration(seconds: 7),
                                          backgroundColor: Get.theme
                                              .snackBarTheme.backgroundColor,
                                          colorText: Get.theme.snackBarTheme
                                              .actionTextColor);
                                    });
                                  } catch (err) {
                                    print(err);
                                  }
                                },
                              ),
                              Divider()
                            ],
                          );
                        }).toList(),
                      );
                    },
                  )))
                ],
              ),
            ),
          ],
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
