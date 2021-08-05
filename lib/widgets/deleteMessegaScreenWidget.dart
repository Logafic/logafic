import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';

// Mesaj silme işleminin onaylanması için show dialog
// Ekran görüntüsü github adresinden erişilebilir.
// AuthController nesnesi oluşturuluyor.
AuthController authController = AuthController.to;

Future<void> showDeleteMessegaScreenWidget(
    BuildContext context, String documentId) async {
  CollectionReference messageRef = FirebaseFirestore.instance
      .collection('messages')
      .doc('${authController.firebaseUser.value!.uid}')
      .collection(documentId);
  CollectionReference lastMessageRef = FirebaseFirestore.instance
      .collection('users')
      .doc('${authController.firebaseUser.value!.uid}')
      .collection('lastMessages');
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Mesajı sil'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Mesajı silmek istediğinize emin misiniz?'),
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
                messageRef.get().then((value) {
                  value.docs.forEach((element) {
                    messageRef.doc(element.id).delete();
                  });
                });
                lastMessageRef.doc(documentId).delete();
              },
              child: Text('Sil'))
        ],
      );
    },
  );
}
