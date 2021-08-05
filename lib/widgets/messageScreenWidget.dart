import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

TextEditingController messageController = TextEditingController();
// Mesaj gönderme ve gönderilen mesajların okunduğu show dialog widget

Future<void> messageShowDialogWidget(BuildContext context, String userName,
    String userProfile, String messageSentUserId) async {
  AuthController authController = AuthController.to;
  final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
      .collection('messages')
      .doc(authController.firebaseUser.value!.uid)
      .collection(messageSentUserId)
      .orderBy('created_at', descending: false)
      .snapshots();
  return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;
                return Container(
                    height: height,
                    width: ResponsiveWidget.isSmallScreen(context)
                        ? width
                        : width * 0.3,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: messageStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Bir hatayla karşılaştık '),
                            );
                          }
                          return Scaffold(
                              appBar: AppBar(
                                elevation: 0,
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.white,
                                flexibleSpace: SafeArea(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(userProfile),
                                          maxRadius: 20,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, ProfileRoute,
                                                      arguments: {
                                                        'userId':
                                                            messageSentUserId
                                                      });
                                                },
                                                child: Text(
                                                  userName,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.settings,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              body: Stack(
                                children: <Widget>[
                                  ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;
                                      return new Container(
                                        padding: EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                            top: 10,
                                            bottom: 10),
                                        child: Align(
                                          alignment: (data['messageUserId'] ==
                                                  messageSentUserId
                                              ? Alignment.topLeft
                                              : Alignment.topRight),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: (data['messageUserId'] ==
                                                      messageSentUserId
                                                  ? Colors.grey.shade200
                                                  : Colors.blue[200]),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              decodeMessage(data['message']),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10, bottom: 10, top: 10),
                                      height: 60,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlue,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: messageController,
                                              decoration: InputDecoration(
                                                  hintText: "Mesaj gönder...",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              if (messageController.text !=
                                                  '') {
                                                sendMessage(
                                                    messageSentUserId,
                                                    userProfile,
                                                    userName,
                                                    messageController.text);
                                                messageController.text = '';
                                              }
                                            },
                                            child: Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            backgroundColor: Colors.blue,
                                            elevation: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        }));
              },
            ),
          ));
}
