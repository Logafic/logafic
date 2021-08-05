import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/appBarHomePageWidget.dart';
import 'package:logafic/widgets/background.dart';
import 'package:logafic/widgets/explore_drawer.dart';
import 'package:logafic/widgets/jobs_screen_floating_quick_access_bar_widget.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:logafic/widgets/showJobsWdiget.dart';
import 'package:logafic/widgets/top_bar_contents.dart';

class JobsShareScreen extends StatefulWidget {
  JobsShareScreen({Key? key}) : super(key: key);

  @override
  _JobSharesScreenState createState() => _JobSharesScreenState();
}

// Web sayfasının adresi ' http://logafic.click/#/jobs '
// Kullanıcıların paylaşılmış ilanları görüntülemeleri bu ilanlara başvuruda bulunabilmeleri için oluşturulmuş web sayfası.
// Sayfanın ekran görüntüsüne github adresi üzerinden ulaşılabilir. ' https://github.com/Logafic/logafic/blob/main/SS/jobs_screen_large.png '

class _JobSharesScreenState extends State<JobsShareScreen> {
  // İş ilanları ve etkinlik ilanlarını kategorik olarak listelememizi sağlayan referanslar
  final Stream<QuerySnapshot> _jobsStreamCreatedAt = FirebaseFirestore.instance
      .collection('jobs')
      .where('category', isEqualTo: 'İş ilanı')
      .snapshots();
  final Stream<QuerySnapshot> _jobsStreamRanked = FirebaseFirestore.instance
      .collection('jobs')
      .where('category', isEqualTo: 'Etkinlik ilanı')
      .snapshots();
  // AuthController nesnesi oluşturuluyor.
  AuthController authController = AuthController.to;
  double _scrollPosition = 0;
  double _opacity = 0;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    _opacity = 1;
    // Sayfada scaffold çerçevesi üzerine inşa ediliyor.
    final body = new Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
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
        body: Scrollbar(
          child: ListView(
            children: [
              // İş ilanları ve Etkinlik ilanları arasında seçimi sağlayan  bar widgetı
              Center(
                child: JobsScreenFloatingQuickAccessBar(screenSize: screenSize),
              ),
              StreamBuilder(
                  // İlanların kategorik olarak listelenmesi
                  stream: authController.isRank == true
                      ? _jobsStreamCreatedAt
                      : _jobsStreamRanked,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // Asenkron olarak indirilen veriler snapshot değişkeni içerisinde tutuluyor.

                    // Verilerin indirilmesi sırasında bir hatayla karşılaşılması durumunda ekrana çıktı veriliyor.
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Bir şeyler yanlış gitti'),
                      );
                    }
                    // Verilerin indirilmesi esnasında ekrana çıktı olarak dairesel işlem göstergesi veriliyor.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // İndirilen verilerin ListView üzerinde görselleştirilmesi sağlanıyor.
                    return new ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: snapshot.data.docs
                          .map<Widget>((DocumentSnapshot document) {
                        // indirilen verilerin json formatından dönüştürülme işlemi yapılıyor.
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return new Center(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: GestureDetector(
                                  onTap: () {
                                    // İlanın detaylı görüntülenmesi için kullanılan show dialog ekran görüntüsü github adresinde erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/jobs_apply_show_dialog.png '
                                    showJobsWidget(context, document.id);
                                  },
                                  child: Card(
                                      color: Colors.grey[50],
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            // Paylaşım içerisinde bulunan kullanıcı profile resminin adresi .
                                            leading: Image.network(
                                                data['userProfileImage']),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  child: Text(
                                                    (data['userName']),
                                                  ),
                                                  onPressed: () {
                                                    // İlan paylaşımını yapan kullanıcının profil görüntülenmesi için profile sayfasına userId argüment olarak gönderiliyor.

                                                    Navigator.pushNamed(
                                                        context, ProfileRoute,
                                                        arguments: {
                                                          'userId':
                                                              data['userId']
                                                        });
                                                  },
                                                ),
                                              ],
                                            ),
                                            // İlanın oluşturulma zamanı .
                                            subtitle: Text(
                                                data['created_at'].toString()),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'İlan başlığı : ${data['title']}',
                                                style: TextStyle(fontSize: 30),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'İlan veren firma : ${data['companyName']}',
                                                style: TextStyle(fontSize: 25),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'İlan konumu : ${data['location']}',
                                                style: TextStyle(fontSize: 25),
                                              )),
                                          ButtonBar(
                                            alignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: TextButton(
                                                  onPressed: () {
                                                    // İlanın detaylı görüntülenmesi için kullanılan show dialog ekran görüntüsü github adresinde erişilebilir. ' https://github.com/Logafic/logafic/blob/main/SS/jobs_apply_show_dialog.png '
                                                    showJobsWidget(
                                                        context, document.id);
                                                  },
                                                  child: Text(
                                                    'Görüntüle',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                )));
                      }).toList(),
                    );
                  })
              // BottomBar()
            ],
          ),
        ));

    //Arka plan tasarımı olarak kullanılan widget
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
}
