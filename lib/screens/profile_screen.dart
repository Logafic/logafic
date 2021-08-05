import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/extensions/string_extensions.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/background.dart';
import 'package:logafic/widgets/deletePostProfileScreenWidget.dart';
import 'package:logafic/widgets/messageScreenWidget.dart';
import 'package:logafic/widgets/profileBarAction.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showImageDialog.dart';
import 'package:logafic/widgets/updatePostWidget.dart';

// Kullanıcı paylaşımlarının ve bilgilerinin görüntülendiği web sayfası
// Web sayfasının adresi ' http://logafic.click/#/profile '
// Kullanıcı userId sayfa içerisine argüment olarak gönderiliyor ve kullanıcı bilgilerinin depolandığı koleksiyondan kullanıcı verileri indiriliyor.
// Kullanıcı kendi profilini düzenleyebilir başkasının profilinden mesaj gönderebilir.
// Yetkiye sahip kullanıcılar etkinlik ve iş ilanı paylaşımı üst menüden yapılabilir.
// Ekran görüntüsü github adresinden ulaşılabilir. ' https://github.com/Logafic/logafic/blob/main/SS/profile_screen_large.png '
// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  // AuthController nesnesi oluşturuluyor.
  AuthController authController = AuthController.to;
  // Argüment olarak gönderilen userId'nin tutulduğu değişken
  final String userId;
  ProfileScreen({Key? key, required this.userId}) : super(key: key);

  // Kullanıcının paylaşımlarının görüntülenmesi için kullanılan koleksiyon referans adresi
  CollectionReference likeRef = FirebaseFirestore.instance.collection('posts');
  // Paylaşımların düzenlenmesi için kullanılan değişken.
  TextEditingController updateContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var screenSizeW = MediaQuery.of(context).size.width * 8 / 10;
    // Sayfa scaffold sınıfı ile çerçeveleniyor.
    final body = new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return new IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black54,
                ),
                onPressed: () {
                  // Önceki sayfaya yönlendirme yapılıyor.
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: new Text(
            'LOGAFIC',
            style: TextStyle(
              color: Colors.black54,
              fontSize: screenSizeW > 400 ? 20 : 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
            ),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            ProfileActionBar(
              userProfileId: userId,
            )
          ],
        ),
        // Kullanıcı bilgilerinin indirilmesi için kullanılan asenkron FutureBuilder sınıfı
        body: FutureBuilder<Map>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // Büyük ve orta ekran boyutlu cihazlar için
              return ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? new Container(
                      child: Scrollbar(
                      child: ListView(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Kullanıcı arka plan fotoğrafı
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: SizedBox(
                                      width: 400,
                                      height: 200,
                                      child: GestureDetector(
                                        child: Image.network(
                                            snapshot.data['userBackImage']),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return ShowImageDialogWidget(
                                                    urlImage: snapshot
                                                        .data['userBackImage']);
                                              });
                                        },
                                      ))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 100),
                                child: Text(
                                  'Gönderiler',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 25,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 100, right: 100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenSizeW * 3 / 10,
                                    child: Column(
                                      children: [
                                        // Kullanıcı profil fotoğrafı
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 100, top: 10),
                                            child: Card(
                                                color: Colors.grey,
                                                child: GestureDetector(
                                                  child: Image.network(
                                                      snapshot.data[
                                                          'userProfileImage']),
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return ShowImageDialogWidget(
                                                              urlImage: snapshot
                                                                      .data[
                                                                  'userProfileImage']);
                                                        });
                                                  },
                                                ))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 100, top: 10),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(Icons
                                                      .account_circle_outlined),
                                                ),
                                                new Text(
                                                  snapshot.data['userName'] ??
                                                      'Name',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenSizeW > 900
                                                        ? 20
                                                        : 13,
                                                    fontFamily: 'sans',
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Divider(
                                          indent: 8,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 100, top: 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(Icons
                                                      .location_city_outlined),
                                                ),
                                                Text(
                                                  snapshot.data['city'] ??
                                                      'city',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenSizeW > 900
                                                        ? 20
                                                        : 13,
                                                    fontFamily: 'sans',
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Divider(
                                          indent: 8,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 100, top: 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child:
                                                      Icon(Icons.book_outlined),
                                                ),
                                                Text(
                                                  snapshot.data['department'] ??
                                                      'department',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenSizeW > 900
                                                        ? 20
                                                        : 13,
                                                    fontFamily: 'sans',
                                                  ),
                                                )
                                              ],
                                            )),
                                        new Divider(
                                          indent: 8,
                                        ),
                                        // Kullanıcı kendi profilini ziyaret ediyorsa profili düzenleme butonu aktif olacaktır.
                                        authController
                                                    .firebaseUser.value!.uid ==
                                                userId
                                            ? new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 100, top: 5),
                                                child: new Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              UpdateUserInformationRoute,
                                                              arguments: {
                                                                'userId': userId
                                                              });
                                                        },
                                                        child: Text(
                                                          'Profili Düzenle',
                                                          style: TextStyle(
                                                              color: Colors
                                                                      .lightBlue[
                                                                  100]),
                                                        ))
                                                  ],
                                                ))
                                            // Kullanıcı başka bir kullanıcının profil sayfasını ziyaret ediyor ise mesaj gönderme butonu aktif olacaktır.
                                            : Text(''),
                                        authController
                                                    .firebaseUser.value!.uid !=
                                                userId
                                            ? new Padding(
                                                padding: EdgeInsets.only(
                                                    left: 100, top: 5),
                                                child: new Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          messageShowDialogWidget(
                                                              context,
                                                              snapshot.data[
                                                                  'userName'],
                                                              snapshot.data[
                                                                  'userProfileImage'],
                                                              userId);
                                                        },
                                                        child: Text(
                                                          'Mesaj Gönder',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber),
                                                        ))
                                                  ],
                                                ))
                                            : Text('')
                                      ],
                                    ),
                                  ),
                                  // Kullanıcıya ait paylaşımların görüntülendiği widget parametre olarak userId almaktadır.
                                  Expanded(child: streamPosts(userId))
                                ],
                              ))
                        ],
                      ),
                    ))

                  // Mobil cihazların ekran boyutu için kullanılan sayfa yapısı
                  : Container(
                      child: new ListView(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    // Kullanıcı profil fotoğrafı
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Image(
                                          image: NetworkImage(snapshot
                                              .data['userProfileImage'])),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    snapshot.data['userName'] ??
                                        'Kullanıcı Adı',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSizeW > 400 ? 20 : 12,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    snapshot.data['department'] ?? 'Bölüm',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSizeW > 400 ? 20 : 12,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Gönderiler',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSizeW > 400 ? 20 : 20,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                )
                              ]),
                          // Kullanıcıya ait paylaşımların görüntülendiği widget parametre olarak userId almaktadır.
                          streamPosts(userId),
                        ],
                      ),
                    );
            }));
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
          body
        ],
      ),
    );
  }

  // // Kullanıcıya ait paylaşımların görüntülendiği widget parametre olarak userId almaktadır.
  Widget streamPosts(String userId) {
    return StreamBuilder(
      // Paylaşımların tutulduğu koleksiyon içerisinden isEqualTo parametresi ile gönderilen userId' ait paylaşımlar bir listeye ekleniyor.
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // return Text(snapshot.data.docs[index]['content']);
          // İndirilen paylaşım verilerini görselleştirmek için LisView kullanılıyor.
          return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Center(
                    child: SizedBox(
                        width: ResponsiveWidget.isSmallScreen(context)
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width * 0.7,
                        child: GestureDetector(
                          onTap: () {
                            // Paylaşımın görüntülenmesi için yönlendirme veriliyor
                            Navigator.pushNamed(context, StatusRoute,
                                arguments: {
                                  'id': snapshot.data.docs[index].id
                                });
                          },
                          child: Card(
                            color: Colors.grey[50],
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                    leading: Image.network(snapshot
                                        .data.docs[index]['userProfile']),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            (snapshot.data.docs[index]
                                                ['userName']),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(snapshot
                                        .data.docs[index]['created_at']
                                        .toString()),
                                    trailing: authController
                                                .firebaseUser.value!.uid ==
                                            userId
                                        ? PopupMenuButton(
                                            icon: Icon(
                                              Icons.more_horiz,
                                              color: Colors.black45,
                                            ),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              PopupMenuItem(
                                                  child: ListTile(
                                                      onTap: () {
                                                        // Paylaşım düzenleme için kullanılan show dialog widget
                                                        postUpdataShowDialog(
                                                            context,
                                                            '${snapshot.data.docs[index].id}',
                                                            '${snapshot.data.docs[index]['content']}',
                                                            '${snapshot.data.docs[index]['created_at']}');
                                                      },
                                                      title: Text('Düzenle'),
                                                      leading:
                                                          Icon(Icons.edit))),
                                              const PopupMenuDivider(),
                                              PopupMenuItem(
                                                  child: ListTile(
                                                      onTap: () {
                                                        // Paylaşımları silmek için kullanılan show dialog widget
                                                        showDeletePostProfileScreenWidget(
                                                            context,
                                                            '${snapshot.data.docs[index].id}');
                                                      },
                                                      title: Text('Sil'),
                                                      leading:
                                                          Icon(Icons.delete))),
                                            ],
                                          )
                                        : Text('')),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // Paylaşımın bir görsel içerip içermediği kontrol ediliyor.
                                  child: snapshot.data.docs[index]
                                              ['urlImage'] ==
                                          ''
                                      ? Text(truncateString(
                                          snapshot.data.docs[index]['content'],
                                          240))
                                      : Column(children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: GestureDetector(
                                              child: Image.network(snapshot.data
                                                  .docs[index]['urlImage']),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return ShowImageDialogWidget(
                                                          urlImage: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['urlImage']);
                                                    });
                                              },
                                            ),
                                          ),
                                          snapshot.data.docs[index]
                                                      ['content'] !=
                                                  ''
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Text(truncateString(
                                                      snapshot.data.docs[index]
                                                          ['content'],
                                                      240)),
                                                )
                                              : Text('')
                                        ]),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, StatusRoute, arguments: {
                                          'id': snapshot.data.docs[index].id
                                        });
                                      },
                                      child: Text(
                                        'Yorumlar',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: checkIfDocExists(
                                          '${snapshot.data.docs[index].id}'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data == false) {
                                          return IconButton(
                                              icon: Icon(
                                                Icons.star_outline,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                likeRef
                                                    .doc(
                                                        '${snapshot.data.docs[index].id}')
                                                    .collection('likes')
                                                    .doc(userId)
                                                    .set({'like': true});
                                              });
                                        } else {
                                          return IconButton(
                                              icon: Icon(
                                                Icons.star_outline,
                                                color: Colors.amber,
                                              ),
                                              onPressed: () {
                                                likeRef
                                                    .doc(
                                                        '${snapshot.data.docs[index].id}')
                                                    .collection('likes')
                                                    .doc(userId)
                                                    .delete();
                                              });
                                        }
                                      },
                                    ),
                                    FutureBuilder(
                                        future: getSize(
                                            '${snapshot.data.docs[index].id}'),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<int> snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString());
                                          }
                                          return Text('0');
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )));
              });
        }
      },
    );
  }

  // Paylaşımın beğenilip beğenilmediğini kontrol eden asenkron method
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var doc = await likeRef.doc(docId).collection('likes').doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  // Beğeni sayılarının getirilmesini sağlayan method.
  Future<int> getSize(String documentId) async {
    var size = 0;
    await likeRef
        .doc(documentId)
        .collection('likes')
        .get()
        .then((value) => size = value.size);
    return size;
  }

  // Kullanıcı bilgilerinin getirilmesini sağlayan method
  Future<Map<String, dynamic>> getUser() async {
    final documentId = userId;
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userSnap = await user.doc(documentId).get();
    Map<String, dynamic> data = userSnap.data() as Map<String, dynamic>;
    return data;
  }
}
