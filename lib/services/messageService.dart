import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logafic/controllers/authController.dart';

//  Mesajlaşma gönderme
//  Son mesajları görüntüleme
//  Görüntülenmeyen ve görüntülenen mesaj işlemleri
//  Mesaj şifreleme ve şifrelenmiş mesajı çözme işlemleri

// AuthController nesnesi oluşturuluyor.
AuthController authController = AuthController.to;

// Gönderilen mesaj mesajın gönderildiği userId, profil görseli, kullanıcı adı ve mesajları parametre olarak alır. Gönderilen mesaj firestore messages koleksiyonunda bulunan
// userId ve mesaj gönderilen kullanıcının userId'sinin bulunduğu dökümanlara gönderen veya gönderilen kullanıcını userId'nin bulunduğu koleksiyona mesajlar döküman olarak ekleniyor.
// Örnek firestore tasarımı:  messages->authController.firebaseUser.value.uid->messageSentUserId->documentId->Message
//                            messages->messageSentUserId->authController.firebaseUser.value.uid->documentId->Message
// Mesaj gönderme işlemi iki kullanıcının messages koleksiyonuna yazılması ve o koleksiyonun gerçek zamanlı olarak okunması ile gerçekleşir.
// Gönderilmiş mesaj okunmamış olarak işaretleniyor.
Future<void> sendMessage(String messageSentUserId, String profileImage,
    String messageSentUserName, String message) async {
  CollectionReference sendMessageCollectionRef =
      FirebaseFirestore.instance.collection('messages');
  sendMessageCollectionRef
      .doc(authController.firebaseUser.value!.uid)
      .collection(messageSentUserId)
      .add({
    'messageUserId': authController.firebaseUser.value!.uid,
    'message': encodeMessage(message),
    'created_at': DateTime.now()
  });
  sendMessageCollectionRef
      .doc(messageSentUserId)
      .collection(authController.firebaseUser.value!.uid)
      .add({
    'messageUserId': authController.firebaseUser.value!.uid,
    'message': encodeMessage(message),
    'created_at': DateTime.now()
  }).whenComplete(() => setUnreadMessage(messageSentUserId));
  // Kullanıcının son mesajlarının bulunduğu koleksiyona ekleme işlemi yapılıyor.
  lastMessage(messageSentUserId, profileImage, messageSentUserName, message);
}

// Son mesajlar user koleksiyonunda bulunan lastMessages koleksiyonuna ekleniyor.
Future<void> lastMessage(String messageSentUserId, String profileImage,
    String messageSentUserName, String message) async {
  CollectionReference lastMessageRef =
      FirebaseFirestore.instance.collection('users');
  lastMessageRef
      .doc('${authController.firebaseUser.value!.uid}')
      .collection('lastMessages')
      .doc(messageSentUserId)
      .set({
    'profileImage': profileImage,
    'messageSentUser': messageSentUserName,
    'sender': authController.firebaseUser.value!.uid,
    'message': encodeMessage(message),
    'created_at': DateTime.now().toString()
  });
  lastMessageRef
      .doc('$messageSentUserId')
      .collection('lastMessages')
      .doc('${authController.firebaseUser.value!.uid}')
      .set({
    'profileImage': authController.firestoreUser.value!.userProfileImage,
    'messageSentUser': authController.firestoreUser.value!.userName,
    'sender': messageSentUserId,
    'message': encodeMessage(message),
    'created_at': DateTime.now().toString()
  });
}

// Mesajlar sayfasına girildiğinde okundu olarak işaretleniyor.
Future<void> setReadMessage() async {
  CollectionReference checkUnreadMessageReference =
      FirebaseFirestore.instance.collection('users');

  checkUnreadMessageReference
      .doc(authController.firebaseUser.value!.uid)
      .update({'unreadMessage': false});
}

// Mesajın base64 formatından dönüştürülmesi
String decodeMessage(String message) {
  return utf8.decode(base64.decode(message));
}

// Mesajın base64 formatına dönüştürülmes
String encodeMessage(String message) {
  return base64.encode(utf8.encode(message));
}

// Mesajın okunmadı olarak işaretlenmesi için kullanılan method
Future<void> setUnreadMessage(String messageSentUserId) async {
  CollectionReference checkUnreadMessageReference =
      FirebaseFirestore.instance.collection('users');

  checkUnreadMessageReference
      .doc(messageSentUserId)
      .update({'unreadMessage': true});
}
