import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/database.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

// İş ve etkinlik ilanlarının ayrıntılarının görüntülendiği show dialog widget
// Ekran görüntüsüne github adresi üzerinden erişilebilir ' https://github.com/Logafic/logafic/blob/main/SS/jobs_apply_show_dialog.png '

CollectionReference _jobsRef = FirebaseFirestore.instance.collection('jobs');
CollectionReference _applyRef = FirebaseFirestore.instance.collection('users');
Future<void> showJobsWidget(BuildContext context, String jobsId) async {
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
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: FutureBuilder(
                      future: _jobsRef.doc(jobsId).get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Birşeyler yanlış gitti'),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'İlan ayrıntıları',
                                style: TextStyle(fontSize: 30),
                              ),
                              Divider(),
                              Text(
                                '${data['title']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              Divider(),
                              Text('İlan sahibi :${data['userName']}',
                                  style: TextStyle(fontSize: 20)),
                              Divider(),
                              Text('Şirket adı :${data['companyName']}',
                                  style: TextStyle(fontSize: 20)),
                              Divider(),
                              Text('Kategori :${data['category']}',
                                  style: TextStyle(fontSize: 20)),
                              Divider(),
                              Text('Konum :${data['location']}',
                                  style: TextStyle(fontSize: 20)),
                              Divider(),
                              Text('Açıklaması :${data['explanation']}',
                                  style: TextStyle(fontSize: 20)),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, bottom: 10, top: 10),
                                  height: 60,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: FutureBuilder(
                                    future: checkIfDocExists(jobsId),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      return snapshot.data == false
                                          ? ElevatedButton(
                                              child: Text('Başvur'),
                                              onPressed: () {
                                                Database()
                                                    .applyJobs(
                                                        jobsId,
                                                        authController
                                                            .firebaseUser
                                                            .value!
                                                            .uid,
                                                        authController
                                                            .firestoreUser
                                                            .value!
                                                            .userName
                                                            .toString(),
                                                        authController
                                                            .firestoreUser
                                                            .value!
                                                            .userProfileImage
                                                            .toString())
                                                    .whenComplete(() {
                                                  Navigator.pushNamed(
                                                      context, JobsScreenRoute);
                                                });
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                'Bu ilana başvurdun.',
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ));
          })));
}

Future<bool> checkIfDocExists(String docId) async {
  try {
    // Get reference to Firestore collection
    var doc = await _applyRef
        .doc('${authController.firebaseUser.value!.uid}')
        .collection('jobs')
        .doc(docId)
        .get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}
