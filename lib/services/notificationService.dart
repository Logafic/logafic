import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logafic/services/messageService.dart';

// Bildirim ekleme
// Bildirimleri okunmadı olarak işaretleme
// Bildirimleri okundu olarak işaretleme

// Bildirimlerin eklenmesi için kullanılan method userImage, userName, userId, userIdNoti ve type değişkenlerini parametre olarak alır.
// Örnek firestore tasarımı : notifications->userId->userNotification->documentId
// Bildirim ekleme işlemi sonrasında bildirim okunmadı olarak işaretleniyor.
Future<void> addNotification(String userImage, String userName, String userId,
    String userIdNoti, String type) async {
  CollectionReference notificationRef =
      FirebaseFirestore.instance.collection('notifications');

  notificationRef.doc('$userId').collection('userNotification').add({
    'userId': userIdNoti,
    'userImage': userImage,
    'type': type,
    'userName': userName,
    'created_at': DateTime.now().toString()
  }).whenComplete(() => setUnreadNotification());
}

// Bildirimlerin okunmadı olarak işaretlenmesi için kullanılan method.
Future<void> setUnreadNotification() async {
  CollectionReference checkUnreadMessageReference =
      FirebaseFirestore.instance.collection('users');

  checkUnreadMessageReference
      .doc(authController.firebaseUser.value!.uid)
      .update({'unreadNotification': true});
}

// Bildirimlerin okundu olarak işaretlenmesi için kullanılan method.
Future<void> setReadNotification() async {
  CollectionReference checkUnreadMessageReference =
      FirebaseFirestore.instance.collection('users');

  checkUnreadMessageReference
      .doc(authController.firebaseUser.value!.uid)
      .update({'unreadNotification': false});
}
