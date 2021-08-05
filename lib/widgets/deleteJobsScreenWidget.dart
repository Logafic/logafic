import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//Profil sayfası paylaşımların silinme onayı için kullanılan show dialog
// Ekran görüntüsü github adresi üzerinden erişilebilir.

CollectionReference _myJobsDeleteCollection =
    FirebaseFirestore.instance.collection('jobs');
Future<void> showDeleteMoyJobsScreenWidget(
    BuildContext context, String jobsId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('İlanı sil'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('İlanı silmek istediğinize emin misiniz?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Vazgeç'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _myJobsDeleteCollection.doc(jobsId).delete();
              },
              child: Text('Sil'))
        ],
      );
    },
  );
}
