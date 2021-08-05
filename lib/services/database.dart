import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/data_model/jobs_model.dart';

// Post paylaşımı
// Posta yorum ekleme
// İş ve etkinlik ilanı paylaşma
// Posta görsel ekleme işlemleri Databse sınıfı tarafından yapılıyor.

class Database {
  AuthController authController = AuthController.to;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // Yapılan post paylaşımları posts koleksiyuna ekleniyor ekleme işlemi sonrasında kullanıcının userPosts koleksiyonuna paylaşımın postId'si ekleniyor.
  // Profil sayfasının görüntülenmesinde userPost koleksiyonundan alınan postId listesi kullanılmaktadır. Paylaşımı beğenen kullanıcıların bulunduğu likes koleksiyonu ekleniyor.
  // Başarılı paylaşım sonrasında snackbar olarak post gönderildi çıktısı veriliyor.
  Future<void> addPost(String content) async {
    try {
      if (authController.firebaseUser.value!.uid.isNotEmpty) {
        await _firebaseFirestore.collection('posts').add({
          'created_at': DateTime.now().toString(),
          'userId': authController.firebaseUser.value!.uid,
          'userName': authController.firestoreUser.value!.userName,
          'userProfile': authController.firestoreUser.value!.userProfileImage,
          'urlImage': '',
          'content': content,
          'like': 0
        }).then((value) async {
          _firebaseFirestore
              .collection('users')
              .doc('${authController.firebaseUser.value!.uid}')
              .collection('userPosts')
              .add({
            'created_at': DateTime.now().toString(),
            'postId': value.id
          });
          _firebaseFirestore
              .collection('posts')
              .doc(value.id)
              .collection('likes')
              .add({'created_at': DateTime.now().toString()});
          Get.snackbar('Post gönderildi', value.id);
        }).catchError((err) {
          Get.snackbar('Hata', err.toString());
        });
      }
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  // Paylaşıma yorum yapılması için kullanılan method yorum içeriğini ve paylaşımın postId'sini parametre olarak almaktadır.
  // Yorum posts koleksiyonunda bulunan parametre olarak gönderilen postId'ye sahip dokümananın comment koleksiyonuna ekleme işlemi yapılıyor.
  //  Paylaşımı beğenen kullanıcıların bulunduğu likes koleksiyonu ekleniyor.
  Future<void> addPostComment(String comment, String postId) async {
    try {
      if (authController.firebaseUser.value!.uid.isNotEmpty) {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comment')
            .add({
          'userId': authController.firebaseUser.value!.uid,
          'userProfileImage':
              authController.firestoreUser.value!.userProfileImage,
          'userName': authController.firestoreUser.value!.userName,
          'comment': comment,
          'created_at': DateTime.now().toString()
        });
      }
    } catch (err) {
      print(err);
    }
  }

  // Görsel paylaşımı yapmak için kullanılan method firebase storage yüklenen görselin referans adresini ve görsel paylaşımında eklenen notu parametre olarak alır.
  // Paylaşılan görsel post modelinde bulunan urlImage alanına eklenmektedir. Paylaşım sonrasında paylaşımın postId'si userPosts koleksiyonuna eklenmektedir.
  Future<void> addPostImage(String urlImage, String note) async {
    try {
      if (authController.firebaseUser.value!.uid.isNotEmpty) {
        await _firebaseFirestore.collection('posts').add({
          'created_at': DateTime.now().toString(),
          'userId': authController.firebaseUser.value!.uid,
          'userName': authController.firestoreUser.value!.userName,
          'userProfile': authController.firestoreUser.value!.userProfileImage,
          'urlImage': urlImage,
          'content': note,
          'like': 0
        }).then((value) async {
          _firebaseFirestore
              .collection('users')
              .doc('${authController.firebaseUser.value!.uid}')
              .collection('userPosts')
              .add({
            'created_at': DateTime.now().toString(),
            'postId': value.id
          });
          _firebaseFirestore
              .collection('posts')
              .doc(value.id)
              .collection('likes')
              .add({'created_at': DateTime.now().toString()});
          Get.snackbar('Post gönderildi', value.id);
        }).catchError((err) {
          Get.snackbar('Hata', err.toString());
        });
      }
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  // İş ve etkinlik paylaşımı için kullanılan bir JobsModel alan method. Jobs koleksiyonuna ekleme yapılmaktadır.
  Future<void> addJob(JobsModel jobsModel) async {
    try {
      if (authController.firebaseUser.value!.uid.isNotEmpty) {
        await _firebaseFirestore
            .collection('jobs')
            .add(jobsModel.toJson())
            .catchError((err) {
          Get.snackbar('Hata', err.toString());
        });
      }
    } on FirebaseException catch (err) {
      print(err);
    }
  }

  // İş ve etkinlik ilanlarına başvuru yapılması için kullanılan method jobsId, userId, userName ve userProfile referans adresini paremetre olarak alıyor.
  // jobs koleksiyonunda bulunan jobsId'ye sahip dökümanın applications koleksiyonuna başvuru yapan kullanıcının bilgileri ekleniyor. Kullanıcının başvurularının tutulması için
  // users koleksiyonunda bulununa userJobs koleksiyonuna jobsId ekleniyor.
  Future<void> applyJobs(String jobsId, String userId, String userName,
      String userProfileImage) async {
    try {
      if (authController.firebaseUser.value!.uid.isNotEmpty) {
        await _firebaseFirestore
            .collection('jobs')
            .doc(jobsId)
            .collection('applications')
            .add({
          'userId': userId,
          'userName': userName,
          'userProfileImage': userProfileImage,
          'created_at': DateTime.now().toString()
        }).catchError((err) {
          Get.snackbar('Hata', err.toString());
        });
        await _firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('jobs')
            .doc(jobsId)
            .set({'created_at': DateTime.now().toString()});
      }
    } on FirebaseException catch (err) {
      print(err);
    }
  }
}
