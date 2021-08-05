import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

// Paylaşımlara yorum yapılması için kullanılan show dialog
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/report_show_dialog.png '

class ShowReportStatusScreenWidget extends StatefulWidget {
  final String postId;
  ShowReportStatusScreenWidget({Key? key, required this.postId})
      : super(key: key);

  @override
  _ShowReportStatusScreenWidgetState createState() =>
      _ShowReportStatusScreenWidgetState();
}

enum report { spam, kotu, ciplaklik, siddet, taciz, nefret }

class _ShowReportStatusScreenWidgetState
    extends State<ShowReportStatusScreenWidget> {
  CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('report');
  TextEditingController reportController = TextEditingController();
  report? _character = report.spam;
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height: ResponsiveWidget.isSmallScreen(context)
                  ? height * 0.9
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title: const Text('Spam içerik bildir'),
                              leading: Radio<report>(
                                value: report.spam,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title: const Text('Kötüye kullanım bildir'),
                              leading: Radio<report>(
                                value: report.kotu,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title: const Text(
                                  'Çıplaklık içeren paylaşım bildir'),
                              leading: Radio<report>(
                                value: report.ciplaklik,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title:
                                  const Text('Şiddet içeren paylaşım bildir'),
                              leading: Radio<report>(
                                value: report.siddet,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title:
                                  const Text('Nefret içeren paylaşım bildir'),
                              leading: Radio<report>(
                                value: report.nefret,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: ListTile(
                              title: const Text('Taciz içeren paylaşım bildir'),
                              leading: Radio<report>(
                                value: report.taciz,
                                groupValue: _character,
                                onChanged: (report? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              controller: reportController,
                              decoration: InputDecoration(
                                  hintText: "Diğer",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              reportCollection.add({
                                'type': 'status',
                                'reportUserId': widget.postId,
                                'userId':
                                    authController.firebaseUser.value!.uid,
                                'report': _character.toString(),
                                'text': reportController.text
                              }).whenComplete(() => Navigator.pop(context));
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
  }
}
