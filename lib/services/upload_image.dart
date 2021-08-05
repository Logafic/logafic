import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:logafic/controllers/authController.dart';

// Firebase storage görsel yüklemesi yapılıyor görselin referans adresi veritabanına ekleniyor.
// Ayrıntı için ' https://firebase.flutter.dev/docs/storage/usage '

AuthController authController = AuthController.to;

Future<String> uploadFile(PickedFile file) async {
  try {
    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(
            '${authController.firebaseUser.value!.uid}->${DateTime.now()}.jpg');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      await ref.putData(await file.readAsBytes(), metadata);
    } else {
      var io;
      await ref.putFile(io.File(file.path), metadata);
    }
    return await ref.getDownloadURL();
  } catch (err) {
    print(err);
  }
  return '';
}
