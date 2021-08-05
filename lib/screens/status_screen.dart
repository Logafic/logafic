import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/menubaraction.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showCommentDialogStatusWidget.dart';
import 'package:logafic/widgets/showImageDialog.dart';

// Web sayfası adresi ' http://logafic.click/#/status '
// Ekran görüntüsü github adresi üzerinden ziyaret edilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/status_screen_large.png '
// Paylaşımların anasayfada 240 karakterlik kısmı gösteriliyor, kullanıcının paylaşımın bütününü görüntülemesi için kullanlır
// Paylaşıma yapılan yorumlar bu sayfada görüntülenir, paylaşıma yorum yapılabilir. Paylaşımı yapan kullanıcının profili görüntülenebilir.
// Kullanıcıya mesaj gönderilebilir ve paylaşım bildirilebilir.
// Paylaşım sayfaya argüment olarak gönderilen postId ile indiriliyor.

// ignore: must_be_immutable
class StatusScreen extends StatelessWidget {
  // Argüment olarak gönderilen postId
  final String id;
  // AuthController nesnesi oluşturuluyor
  AuthController authController = AuthController.to;
  // Paylaşımın indirilmesi için koleksinyon referans adresi
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  StatusScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Paylaşım verilerinin indirilmesi için FutureBuilde sınıfı kullanılıyor.
    return FutureBuilder(
      future: posts.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          // İndirilen veriler Json formatından dönüştürülüyor.
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
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
                'Gönderi',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              actions: <Widget>[
                // Menü için kullanılan widget
                MenuActionBar(
                    postId: id,
                    userId: data['userId'],
                    userName: data['userName'],
                    userProfileImage: data['userProfile'],
                    content: data['content'],
                    createAt: data['created_at'],
                    urlImage: data['urlImage'])
              ],
            ),
            body: Center(
              child: SizedBox(
                width: ResponsiveWidget.isSmallScreen(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width * 0.6,
                child: Card(
                    child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(data['userProfile']),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                child: Text(
                                  (data['userName']),
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  // Paylaşımı yapan kullanıcının profiline yönlendirme
                                  Navigator.pushNamed(context, ProfileRoute,
                                      arguments: {'userId': data['userId']});
                                },
                              ),
                            ],
                          ),
                          subtitle: Text(
                            data['created_at'],
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      Divider(),
                      // Paylaşımın bir görsel içerip içermediği kontrol ediliyor.
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: data['urlImage'] == ''
                            ? Text(data['content'])
                            : Column(children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: GestureDetector(
                                    child: Image.network(data['urlImage']),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ShowImageDialogWidget(
                                                urlImage: data['urlImage']);
                                          });
                                    },
                                  ),
                                ),
                                data['content'] != ''
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(data['content']),
                                      )
                                    : Text('')
                              ]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                              onPressed: () {
                                // Post paylaşımı için kullanılan show dialog widget
                                showCommentPostShareWidget(
                                    context,
                                    id,
                                    data['userId'],
                                    data['content'],
                                    data['urlImage'],
                                    data['userProfile'],
                                    data['userName'],
                                    data['created_at']);
                              },
                              child: Text(
                                'Yorum Yap',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                            ),
                          ),
                          // Paylaşımı beğenme için yapılan işlemler
                          FutureBuilder(
                            future: checkIfDocExists('$id'),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == false) {
                                return IconButton(
                                    icon: Icon(
                                      Icons.star_outline,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      posts
                                          .doc('$id')
                                          .collection('likes')
                                          .doc(
                                              '${authController.firebaseUser.value!.uid}')
                                          .set({'like': true});
                                    });
                              } else {
                                return IconButton(
                                    icon: Icon(
                                      Icons.star_outline,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      posts
                                          .doc('$id')
                                          .collection('likes')
                                          .doc(
                                              '${authController.firebaseUser.value!.uid}')
                                          .delete();
                                    });
                              }
                            },
                          ),
                          // Paylaşımın beğeni boyutu
                          FutureBuilder(
                              future: getSize('$id'),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                }
                                return Text('0');
                              }),
                        ],
                      ),
                      Text(
                        'Yorumlar',
                        style: TextStyle(fontSize: 20),
                      ),
                      // Paylaşıma yapılan yorumların indirilmesi ve bir listView üzerinden görselleştirilmesi sağlanıyor.

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(id)
                            .collection('comment')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            Center(
                              child: Text(
                                  'Birşeyler yanlış lütfen daha sonra tekrar deneyiniz.'),
                            );
                          }

                          return new ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              return new Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    leading:
                                        Image.network(data['userProfileImage']),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            (data['userName']),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, ProfileRoute,
                                                arguments: {
                                                  'userId': data['userId']
                                                });
                                          },
                                        ),
                                        Text(
                                          data['comment'],
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                    subtitle: Text(
                                      data['created_at'],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    // Kullanıcı kendi yorumlarını silme işlemi yapabiliyor.
                                    trailing: authController
                                                .firebaseUser.value!.uid ==
                                            data['userId']
                                        ? IconButton(
                                            onPressed: () {
                                              posts
                                                  .doc(id)
                                                  .collection('comment')
                                                  .doc(document.id)
                                                  .delete();
                                              print(document.id);
                                            },
                                            icon: Icon(
                                                Icons.delete_forever_outlined))
                                        : null,
                                  ));
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var doc = await posts
          .doc(docId)
          .collection('likes')
          .doc('${authController.firebaseUser.value!.uid}')
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<int> getSize(String documentId) async {
    var size = 0;
    await posts
        .doc(documentId)
        .collection('likes')
        .get()
        .then((value) => size = value.size);
    return size;
  }
}
