import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/database.dart';
import 'package:logafic/services/upload_image.dart';
import 'package:logafic/widgets/responsive.dart';

// Paylaşımlara görsel eklemek için kullanılan show dialog
// Database service kullanılıyor.
// Ekran görüntüsü github üzerinden erişilebilir

TextEditingController messageController = TextEditingController();
PickedFile? postImage;
ImagePicker _picker = ImagePicker();
bool isLoading = false;
String urlImage = '';
Future<void> uploadImageShowDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
                height: height,
                width: ResponsiveWidget.isSmallScreen(context)
                    ? width * 0.9
                    : width * 0.3,
                child: Stack(
                  children: <Widget>[
                    isLoading == false
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                postImage == null
                                    ? Text('Görsel seçmek için tıklayın.')
                                    : Center(
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: Image.network(
                                                postImage!.path))),
                                IconButton(
                                    onPressed: () async {
                                      final file = await _picker.getImage(
                                          source: ImageSource.gallery);

                                      postImage = file!;
                                      urlImage = await uploadFile(postImage!);
                                      (context as Element).markNeedsBuild();
                                    },
                                    icon: Icon(Icons.add)),
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
                                controller: messageController,
                                decoration: InputDecoration(
                                    hintText: "Not Ekle...",
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
                                    .addPostImage(
                                        urlImage, messageController.value.text)
                                    .whenComplete(() {
                                  postImage = null;
                                  Navigator.pushNamed(context, HomeRoute);
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
