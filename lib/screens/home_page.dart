import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/extensions/string_extensions.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/services/database.dart';
import 'package:logafic/services/notificationService.dart';
import 'package:logafic/widgets/appBarHomePageWidget.dart';
import 'package:logafic/widgets/bottom_bar.dart';
import 'package:logafic/widgets/explore_drawer.dart';
import 'package:logafic/widgets/floating_quick_access_bar.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showDialogPostImageUploadWidget.dart';
import 'package:logafic/widgets/showImageDialog.dart';
import 'package:logafic/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';
import 'package:logafic/widgets/background.dart';

// Projemizde yapılan paylaşımların kullanıcılara gösterildiği web sayfasıdır.
// Web sayfasının adresş 'http://logafic.click/#/home'
// Sayfanın ekran görüntüsüne aşağıdaki github adresinden ulaşılabilir. ' https://github.com/Logafic/logafic/blob/main/SS/home_screen_large.png '
// Post paylaşımlarının gerçek zamanlı görüntülenmesi için Firebase firestore kullanılmıştır.

// Kullanıcı ile etkileşime girildiğinden dolayı sayfa StatefulWidget olarak tasarlanmıştır.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Paylaşımların oluşturulma zamanına göre listelenmesi için kullanılan reference adresi.Posts firebase firestore üzerinde post paylaşımlarının tutulduğu
  //koleksiyonun adı
  int count = 20;
  // Paylaşımı beğenen kullanıcıların tutulduğu ve giriş yapmış kullanıcının paylaşımı beğenip beğenmediğinin kontrolünün sağlandığı koleksiyonun referans adresi.
  CollectionReference likeRef = FirebaseFirestore.instance.collection('posts');
  // AuthControllerın bir nesnesi oluşturuluyor.
  AuthController authController = AuthController.to;

  // Paylaşım yapmak için kullanılan TextField'controller nesnesi.
  final postController = TextEditingController();
  // Sayfada scroll konumunun tutulduğu değişken.
  bool isLoading = false;
  double _scrollPosition = 0;
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    void sumCount() async {
      count = count + 5;
      setState(() {});
    }

    print(count);
    final Stream<QuerySnapshot> _usersStreamCreatedAt = FirebaseFirestore
        .instance
        .collection('posts')
        .limit(count)
        .orderBy('created_at', descending: true)
        .snapshots();

    // Paylaşımların begeni sayısına göre sıralanması için kullanılan ref adresi
    final Stream<QuerySnapshot> _usersStreamRanked = FirebaseFirestore.instance
        .collection('posts')
        .limit(count)
        .orderBy('like', descending: true)
        .snapshots();
    // Ekran boyutu bir değişkene atanıyor.
    var screenSize = MediaQuery.of(context).size;
    // Scroll konumuna göre opacity değeri değişiyor.
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    _opacity = 1;
    // Sayfada scaffold çerçevesi kullanıldı.
    final body = new Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        // Üst menünün sayfa boyurna göre ayarlanması sağlanıyor.

        appBar: ResponsiveWidget.isSmallScreen(context)
            ? appBarHomePageWidget()
            // PreferredSize özel bir uygulama çubuğu oluşturmamıza imkan veren özel bir penceredir.İncelemek için ' https://api.flutter.dev/flutter/widgets/PreferredSize-class.html '
            : PreferredSize(
                preferredSize: Size(screenSize.width, 1000),
                // Navbar olarak tasarlan özel uygulama çubuğu widgetı.
                child: TopBarContents(_opacity),
              ),
        // Küçük ekran için kullanılan açılır menü ekran görüntüsü için github adresi ->>
        drawer: ExploreDrawer(),
        // Paylaşımların görüntülenebilmesi için Scrollbar widget kullanılıyor.Ayrıntı için ' https://api.flutter.dev/flutter/material/Scrollbar-class.html '
        body: LazyLoadScrollView(
          isLoading: isLoading,
          onEndOfPage: sumCount,
          child: ListView(
            children: [
              // Kullanıcın paylaşım yapmasın için kullanılan TextField sayfanın ortasına ayarlanıyor.
              Center(
                // Flutter stack sınıfı içerisinde bulunan öğeleri bir yığın şeklinde üst üste ekler bu bize bir arka plan görseli üzerine paylaşım widgetını eklememizi sağlar.
                //Ayrıntısı için ' https://api.flutter.dev/flutter/widgets/Stack-class.html '
                child: Stack(
                  children: [
                    // Kullanılan arka plan görseli.
                    Container(
                      child: SizedBox(
                        height: screenSize.height * 0.34,
                        width: screenSize.width,
                        child: Image.asset(
                          'assets/images/back_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Paylaşım yapılması için kullanılan TextField bileşenleri
                    // Ekran görüntüsü için github adresi ziyaret edilebilir.
                    Center(
                      child: Container(
                        // İçerisinde card sınıfı bulunan container sınıfı genişliği ayarlanıyor.Sayfa genişliğinin %60 kadar.
                        width: MediaQuery.of(context).size.width * 6 / 10,
                        margin: EdgeInsets.only(top: 100),
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white60,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.memory_rounded),
                                  title: const Text(
                                    'Bizimle bişeyler paylaş',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                // Paylaşım yapılan TextField başlangıç
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Form(
                                            child: TextFormField(
                                          controller: postController,
                                          decoration: const InputDecoration(
                                            icon: Icon(Icons.message),
                                            hintText:
                                                'Bu textbox nasıl kullanman gerektiğini biliyorsun.',
                                          ),
                                          minLines: 2,
                                          maxLines: 4,
                                          keyboardType: TextInputType.multiline,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Lütfen boş bırakma null kalmasın.';
                                            }
                                            return null;
                                          },
                                        )),
                                      ),
                                      // Görsel paylalımı için kullanılan IconButton
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            // Görsel seçiminin ve sonrasında önizlemenin yapıldığı show dialog
                                            // Ekran görüntüsü için github adresi ziyaret edilebilir. -->
                                            uploadImageShowDialog(context);
                                            // paylaşımların tutulduğu controller temizleniyor.
                                            postController.clear();
                                          } catch (Err) {
                                            print(Err);
                                          }
                                        },
                                        // IconButton bulunduğu container sınıfı
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent[100],
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Icon(
                                            Icons.photo_library_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Paylaşım yapılan TextField bitişi.
                                // Paylaşımın posts koleksiyonuna eklenmesi için kullanılan buton.
                                ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      child: Text(
                                        'Gönder',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      onPressed: () async {
                                        // Post paylaşımı için kullanılan database servisi
                                        await Database()
                                            .addPost(postController.text);
                                        postController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              // Akış zamanı ve Trend gönderilerin seçimi için kullanılan bar widgetı
              Center(
                child: FloatingQuickAccessBar(screenSize: screenSize),
              ),
              // Asenkron olarak indirilen paylaşım verilerinin gerçek zamanlı olarak görselleştirilmesi sağlayan StreamBuilder sınıfı
              // Kullanılan yöntemin anlaşılması için doküman adresi ' https://firebase.flutter.dev/docs/firestore/overview/ '
              StreamBuilder(
                  // Verilerin oluşturulma zamanına göre veya beğeni sayısına göre indirilmesi sağlanıyor.
                  stream: authController.isRank == true
                      ? _usersStreamCreatedAt
                      : _usersStreamRanked,
                  // İndirilen verilerin görselleştirlmesi işlemleri
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // Asenkron olarak indirilen veriler snapshot değişkeni içerisinde tutuluyor.

                    // Verilerin indirilmesi sırasında bir hatayla karşılaşılması durumunda ekrana çıktı veriliyor.
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Birşeyler yanlış gitti'),
                      );
                    }
                    // Verilerin indirilmesi esnasında ekrana çıktı olarak dairesel işlem göstergesi veriliyor.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // İndirilen verilerin bir listView sınıfı içerisinde görselleştirilmesi sağlanıyor.
                    return new ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      // indirilen verilerin json formatından dönüştürülme işlemi yapılıyor.
                      children: snapshot.data.docs
                          .map<Widget>((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return new Center(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: GestureDetector(
                                  onTap: () {
                                    // Paylaşımın görüntülenmesi için Durum sayfasına indirilen paylaşım id argüment olarak gönderiliyor
                                    Navigator.pushNamed(context, StatusRoute,
                                        arguments: {'id': document.id});
                                  },
                                  // Paylaşım görselleştirme başlangıç
                                  //Ekran görüntüsü için github adresi ziyaret edilebilir.
                                  child: Card(
                                      color: Colors.grey[50],
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            // Paylaşım içerisinde bulunan kullanıcı profile resminin adresi .
                                            leading: Image.network(
                                                data['userProfile']),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  child: Text(
                                                    (data['userName']),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        // Paylaşımı yapan kullanıcının profil görüntülenmesi için profile sayfasına userId argüment olarak gönderiliyor.
                                                        context,
                                                        ProfileRoute,
                                                        arguments: {
                                                          'userId':
                                                              data['userId']
                                                        });
                                                  },
                                                ),
                                              ],
                                            ),
                                            // Paylaşım oluşturulma zamanı
                                            subtitle: Text(
                                                data['created_at'].toString()),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            // Paylaşımın bir görsel içerip içermediği kontrol ediliyor.
                                            child: data['urlImage'] == ''
                                                ? Text(truncateString(
                                                    data['content'], 240))
                                                : Column(children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      child: GestureDetector(
                                                        child: Image.network(
                                                            data['urlImage']),
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) {
                                                                return ShowImageDialogWidget(
                                                                    urlImage: data[
                                                                        'urlImage']);
                                                              });
                                                        },
                                                      ),
                                                    ),
                                                    data['content'] != ''
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20.0),
                                                            child: Text(
                                                                // Paylaşımların içeriklerinin 240 karakter ile sınırlı olacak şekilde görselleştirilmesi sağlanıyor.
                                                                truncateString(
                                                                    data[
                                                                        'content'],
                                                                    240)),
                                                          )
                                                        : Text('')
                                                  ]),
                                          ),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                // Paylaşıma yapılan yorumların görüntülenmesi için TextButton
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      // Paylaşımın görüntülenmesi için Durum sayfasına indirilen paylaşım id argüment olarak gönderiliyor
                                                      context,
                                                      StatusRoute,
                                                      arguments: {
                                                        'id': document.id
                                                      });
                                                },
                                                child: Text(
                                                  'Yorumlar',
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              ),
                                              // Kullanıcı tarafından beğenilmiş paylaşımların kontrolü ve bunların belirlenmesi işlemleri
                                              // Beğenilmiş paylaşım ıcon rengi farklı olmaktadır.

                                              // Beğenilmiş paylaşımların kontorlü için kullanılan asenkron olarak çalışan method
                                              FutureBuilder(
                                                future: checkIfDocExists(
                                                    '${document.id}'),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.data == false) {
                                                    // Document dosyası yok ise ıcon rengi yeşil
                                                    return IconButton(
                                                        icon: Icon(
                                                          Icons.star_outline,
                                                          color: Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          // Icona basıldığı durumda paylaşımı beğenen kullanıcıların bulunduğu koleksiyona kullanıcı ekleniyor ve bu
                                                          // işlem başarılı olursa paylaşımın like değeri 1 değer arttırılıyor.
                                                          likeRef
                                                              .doc(
                                                                  '${document.id}')
                                                              .get()
                                                              .then((value) {
                                                            var like = value
                                                                .get('like');
                                                            print(like);
                                                            likeRef
                                                                .doc(
                                                                    '${document.id}')
                                                                .update({
                                                              'like': like + 1
                                                            });
                                                          });

                                                          likeRef
                                                              .doc(
                                                                  '${document.id}')
                                                              .collection(
                                                                  'likes')
                                                              .doc(
                                                                  '${authController.firebaseUser.value!.uid}')
                                                              .set({
                                                            'like': true
                                                          }).then((value) {
                                                            // Beğenilen paylaşımın sahibi kullanıcının bildirim koleksiyonua bildirim olarak ekleme işlemi yapılıyor.
                                                            addNotification(
                                                                data[
                                                                    'userProfile'],
                                                                '${authController.firestoreUser.value!.userName}',
                                                                data['userId'],
                                                                authController
                                                                    .firebaseUser
                                                                    .value!
                                                                    .uid,
                                                                'Like');
                                                          });
                                                        });
                                                  } else {
                                                    return IconButton(
                                                        // Document dosyası yok ise ıcon rengi koyu sarı
                                                        icon: Icon(
                                                          Icons.star_outline,
                                                          color: Colors.amber,
                                                        ),
                                                        onPressed: () {
                                                          // Icona basıldığı durumda paylaşımı beğenen kullanıcıların bulunduğu koleksiyondan kullanıcı siliniyor ve bu
                                                          // işlem başarılı olursa paylaşımın like değeri 1 değer azaltılıyor.
                                                          likeRef
                                                              .doc(
                                                                  '${document.id}')
                                                              .get()
                                                              .then((value) {
                                                            var like = value
                                                                .get('like');
                                                            print(like);
                                                            likeRef
                                                                .doc(
                                                                    '${document.id}')
                                                                .update({
                                                              'like': like - 1
                                                            });
                                                          });
                                                          likeRef
                                                              .doc(
                                                                  '${document.id}')
                                                              .collection(
                                                                  'likes')
                                                              .doc(
                                                                  '${authController.firebaseUser.value!.uid}')
                                                              .delete();
                                                        });
                                                  }
                                                },
                                              ),
                                              // Paylaşımın beğeni sayılarının gerçek zamanlı görüntülenmesi işlemi
                                              FutureBuilder(
                                                  future:
                                                      getSize('${document.id}'),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<int>
                                                              snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(snapshot.data
                                                          .toString());
                                                    }
                                                    return Text('0');
                                                  }),
                                            ],
                                          )
                                        ],
                                      )),

                                  // Paylaşım görselleştirme bitişi
                                )));
                      }).toList(),
                    );
                  }),
              // Alt menü
              Padding(
                padding: EdgeInsets.only(top: 300),
                child: BottomBar(),
              )
            ],
          ),
        ));
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.black26,
      ),
      child: new Stack(
        children: <Widget>[
          new CustomPaint(
            size: new Size(screenSize.width, screenSize.height),
            painter: new Background(),
          ),
          body,
        ],
      ),
    );
  }

// Kullanıcı her beğeni işlemini gerçekleştirdiğinde postu beğenen kullanıcıların tutulduğu koleksiyon adresinde kendi userId'si  ile bir document oluşturur.
//Paylaşımların kullanıcı tarafından beğenilmediği asenkron olarak kullanılan ve true false dönüşü yapan method sayesinde gerçekleşir. Bir paylaşımın beğenen kullanıcılarının
// tutulduğu collectionda kullanıcının userId'si bulunuyorsa true bulunmuyosa false değeri döner. Beğeni geri alınırsa document silinir. Bu işlem her paylaşım için tekrar edilir.
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var doc = await likeRef
          .doc(docId)
          .collection('likes')
          .doc('${authController.firebaseUser.value!.uid}')
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  // Paylaşımların gerçek zamanlı olarak beğeni sayılarının asenkron olarak görselleştirilmesini sağlayan method. Beğeni sayısını dönmektedir.

  Future<int> getSize(String documentId) async {
    var size = 0;
    await likeRef
        .doc(documentId)
        .collection('likes')
        .get()
        .then((value) => size = value.size);
    return size;
  }
}
