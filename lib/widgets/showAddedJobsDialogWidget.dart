import 'package:flutter/material.dart';
import 'package:logafic/data_model/jobs_model.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/database.dart';
import 'package:logafic/services/messageService.dart';
import 'package:logafic/widgets/responsive.dart';

// İş ilanı oluşturmak için kullanılan show dialog
// Profil sayfasından ulaşılabilir.
// Ekran görüntüsü github adresinden erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/show_dialog_added_jobs.png '

class ShowAddedJobsDialogWidget extends StatefulWidget {
  ShowAddedJobsDialogWidget({Key? key}) : super(key: key);

  @override
  _ShowAddedJobsDialogWidgetState createState() =>
      _ShowAddedJobsDialogWidgetState();
}

class _ShowAddedJobsDialogWidgetState extends State<ShowAddedJobsDialogWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController jobsNameController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    categoryController.text = 'İş ilanı';
    return new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              height:
                  ResponsiveWidget.isSmallScreen(context) ? height : height / 2,
              width: ResponsiveWidget.isSmallScreen(context)
                  ? width * 0.9
                  : width * 0.3,
              child: Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Icon(Icons.add),
                              title: Text(
                                'İş ilanı oluştur',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                validator: _validateEmptyString,
                                controller: titleController,
                                decoration: InputDecoration(
                                    labelText: 'İlan başlığı :'),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                validator: _validateEmptyString,
                                controller: companyNameController,
                                decoration:
                                    InputDecoration(labelText: 'Şirket Adı :'),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                validator: _validateEmptyString,
                                controller: categoryController,
                                enabled: false,
                                decoration: InputDecoration(
                                    labelText: 'İlan kategorisi :'),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                validator: _validateEmptyString,
                                controller: locationController,
                                decoration:
                                    InputDecoration(labelText: 'Konum :'),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: explanationController,
                                minLines: 5,
                                maxLines: 10,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    labelText: 'İlan açıklaması :'),
                              )),
                        ],
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
                              child: TextFormField(
                                validator: _validateEmptyString,
                                controller: jobsNameController,
                                decoration: InputDecoration(
                                    hintText: "İlana bir isim veriniz..",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  JobsModel jobsModel = JobsModel(
                                      categoryController.text,
                                      authController.firebaseUser.value!.uid,
                                      authController
                                          .firestoreUser.value!.userName
                                          .toString(),
                                      authController
                                          .firestoreUser.value!.userProfileImage
                                          .toString(),
                                      jobsNameController.text,
                                      titleController.text,
                                      companyNameController.text,
                                      locationController.text,
                                      explanationController.text);
                                  Database().addJob(jobsModel).whenComplete(() {
                                    categoryController.clear();
                                    jobsNameController.clear();
                                    titleController.clear();
                                    companyNameController.clear();
                                    locationController.clear();
                                    explanationController.clear();
                                    Navigator.pushNamed(
                                        context, ProfileRoute, arguments: {
                                      'userId':
                                          authController.firebaseUser.value!.uid
                                    });
                                  });
                                }
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              backgroundColor: Colors.amber,
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

String? _validateEmptyString(String? email) {
  RegExp regex = RegExp(r'\w+@\w+\.\w+');
  if (email!.isEmpty || !regex.hasMatch(email)) if (email.isEmpty)
    return 'Bu alanı boş bırakamazsınız.';
}
