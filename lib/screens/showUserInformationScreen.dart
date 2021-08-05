import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/widgets/responsive.dart';

// Web sayfası adresi ' http://logafic.click/#/fullProfile '
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/user_information_screen_large.png '
// Profile sayfasında kullanıcının bütün bilgilerinin görüntülendiği web sayfası
// Sayfaya gönderilen userId ile kullanıcı bilgileri indiriliyor ve görselleştiriliyor.

// ignore: must_be_immutable
class ShowFullUserInformationScreen extends StatelessWidget {
  final String userId;
  ShowFullUserInformationScreen({Key? key, required this.userId})
      : super(key: key);

  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        title: Text(
          'Kullanıcının bütün bilgileri..',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Scrollbar(
          // Kullanıcı bilgileri indiriliyor.
          child: FutureBuilder<DocumentSnapshot>(
        future: user.doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Birşeyler yanlış gitti daha sonra tekrar deneyiniz.");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Kullanıcı bilgilerine ulaşılamıyor");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Scrollbar(
                  // Küçük ekran boyutuna sahip cihazlar için
                  child: ResponsiveWidget.isSmallScreen(context)
                      ? Card(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 400,
                                  height: 400,
                                  child:
                                      Image.network(data['userProfileImage']),
                                ),
                              ),
                              textField('Kullanıcı Adı', data['userName']),
                              textField('Email', data['email']),
                              textField('Doğum tarihi', data['birtday']),
                              textField('Şehir', data['city']),
                              textField('Üniversite', data['universty']),
                              textField('Bölüm', data['department']),
                              textField('Cinsiyet', data['gender']),
                              textField('Biyografi', data['biograpfy']),
                              textField('Instagram', data['instagram']),
                              textField('Twitter', data['twitter']),
                              textField('Linkedin', data['linkedin']),
                            ],
                          ),
                        )
                      // Diğer cihazlar için
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Card(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: SizedBox(
                                    width: 400,
                                    height: 400,
                                    child:
                                        Image.network(data['userProfileImage']),
                                  ),
                                ),
                                textField('Kullanıcı Adı', data['userName']),
                                textField('Email', data['email']),
                                textField('Doğum tarihi', data['birtday']),
                                textField('Şehir', data['city']),
                                textField('Üniversite', data['universty']),
                                textField('Bölüm', data['department']),
                                textField('Cinsiyet', data['gender']),
                                textField('Biyografi', data['biograpfy']),
                                textField('Instagram', data['instagram']),
                                textField('Twitter', data['twitter']),
                                textField('Linkedin', data['linkedin']),
                              ],
                            ),
                          ),
                        )),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }

  // Bilgilerin ekrana yazdırılması için kullanılan widget
  Widget textField(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(),
          Text(title, style: TextStyle(fontSize: 25)),
          Text(
            ' $content',
            style: TextStyle(fontSize: 20),
          ),
          Divider(),
        ],
      ),
    );
  }
}
