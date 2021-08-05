import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/responsive.dart';

// İş veya Etkinlik ilanlarına başvuranları görüntülendiği show dialog
// İlanlarım sayfasından erişilebilir
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/activty_jobs_show_dialog.png '

Future<void> showJobsApplyWidget(BuildContext context, String jobsId) async {
  final Stream<QuerySnapshot> _applicationstream = FirebaseFirestore.instance
      .collection('jobs')
      .doc(jobsId)
      .collection('applications')
      .snapshots();
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: _applicationstream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          body: Stack(
                            children: <Widget>[
                              new ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  return new Column(children: [
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              ('${data['userName']}'),
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
                                        ],
                                      ),
                                      isThreeLine: true,
                                      subtitle: Text('${data['created_at']}\n'),
                                      leading: Image.network(
                                          '${data['userProfileImage']}'),
                                    ),
                                    Divider()
                                  ]);
                                }).toList(),
                              )
                            ],
                          ));
                    }));
          })));
}
