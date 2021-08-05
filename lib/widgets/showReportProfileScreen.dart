import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

class ShowReportProfileScreenWidget extends StatefulWidget {
  final String reportUserId;
  ShowReportProfileScreenWidget({Key? key, required this.reportUserId})
      : super(key: key);

  @override
  _ShowReportProfileScreenWidgetState createState() =>
      _ShowReportProfileScreenWidgetState();
}

enum report { spam, sahte, nefret, siddet }

class _ShowReportProfileScreenWidgetState
    extends State<ShowReportProfileScreenWidget> {
  TextEditingController reportController = TextEditingController();
  CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('report');
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
                  ? height * 0.7
                  : height / 2,
              width:
                  ResponsiveWidget.isSmallScreen(context) ? width : width * 0.3,
              child: Scrollbar(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: ListTile(
                                title: const Text('Spam hesap bildir'),
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
                                title: const Text('Sahte hesap bildir'),
                                leading: Radio<report>(
                                  value: report.sahte,
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
                                    const Text('Siddet içerikli hesap bildir'),
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
                                    const Text('Nefret içerikli hesap bildir'),
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
                                  'type': 'profile',
                                  'reportUserId': widget.reportUserId,
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
                ),
              ));
        }));
  }
}
