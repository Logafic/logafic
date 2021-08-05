import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//Profil sayfası paylaşımların silinme onayı için kullanılan show dialog
// Ekran görüntüsü github adresi üzerinden erişilebilir.

CollectionReference likeRef = FirebaseFirestore.instance.collection('posts');
Future<void> showDeletePostProfileScreenWidget(
    BuildContext context, String postId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Gönderiyi sil'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Gönderiyi silmek istediğinize emin misiniz?'),
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
                likeRef.doc(postId).delete();
              },
              child: Text('Sil'))
        ],
      );
    },
  );
}
