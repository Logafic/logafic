import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/deleteMessegaScreenWidget.dart';
import 'package:logafic/widgets/responsive.dart';

import 'messageScreenWidget.dart';

// Son mesajların görüntülendiği widget
// Ekran görüntüsü github adresi üzerinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/message_screen_small.png '

class MessageScreenUserMessagesWidget extends StatelessWidget {
  MessageScreenUserMessagesWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController.to;
    Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection('users')
        .doc('${authController.firebaseUser.value!.uid}')
        .collection('lastMessages')
        .snapshots();
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: messageStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return new ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return new Padding(
                      padding: EdgeInsets.all(12),
                      child: ListTile(
                        onTap: () {
                          messageShowDialogWidget(
                              context,
                              data['messageSentUser'],
                              data['profileImage'],
                              document.id);
                        },
                        leading: new Container(
                          height: 72.0,
                          width: 72.0,
                          decoration: new BoxDecoration(
                              color: Colors.black12,
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 2.0)
                              ],
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(12.0)),
                              image: new DecorationImage(
                                image: NetworkImage(data['profileImage']),
                              )),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              data['messageSentUser'],
                              style: new TextStyle(
                                  fontSize:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? 15
                                          : 22,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            new Text(
                              decodeMessage(data['message']),
                              style: new TextStyle(
                                  fontSize:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? 14
                                          : 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                        subtitle: new Text(data['created_at']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever_outlined),
                          onPressed: () {
                            showDeleteMessegaScreenWidget(context, document.id);
                          },
                        ),
                      ));
                }).toList(),
              );
            }));
  }
}
