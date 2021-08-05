import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logafic/extensions/string_extensions.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/database.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/services/notificationService.dart';
import 'package:logafic/widgets/responsive.dart';

// Paylaşımlara yorum yapılması için kullanılan show dialog
// Ekran görüntüsü github adresinden erişilebilir.

TextEditingController commentController = TextEditingController();
PickedFile? postImage;
bool isLoading = false;
String urlImage = '';
Future<void> showCommentPostShareWidget(
    BuildContext context,
    String postId,
    String postUserId,
    String postContent,
    String postUrlImage,
    String postUserProfileImage,
    String postUserName,
    String postCreatedAt) async {
  return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
                height: ResponsiveWidget.isSmallScreen(context)
                    ? height
                    : height / 2,
                width: ResponsiveWidget.isSmallScreen(context)
                    ? width
                    : width * 0.3,
                child: Stack(
                  children: <Widget>[
                    isLoading == false
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    leading:
                                        Image.network(postUserProfileImage),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            (postUserName),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, ProfileRoute,
                                                arguments: {
                                                  'userId': postUserId
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      postCreatedAt,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: postUrlImage == ''
                                      ? Text(truncateString(postContent, 240))
                                      : Column(children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Image.network(postUrlImage),
                                          ),
                                          postContent != ''
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Text(truncateString(
                                                      postContent, 240)),
                                                )
                                              : Text('')
                                        ]),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                    hintText: "Yorumu ekle..",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                await Database()
                                    .addPostComment(
                                        commentController.value.text, postId)
                                    .then((value) => addNotification(
                                        authController.firestoreUser.value!
                                            .userProfileImage
                                            .toString(),
                                        authController
                                            .firestoreUser.value!.userName
                                            .toString(),
                                        postUserId,
                                        postId,
                                        'Comment'))
                                    .whenComplete(() {
                                  commentController.clear();
                                  Navigator.popAndPushNamed(
                                      context, StatusRoute,
                                      arguments: {'id': postId});
                                });
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
          })));
}
