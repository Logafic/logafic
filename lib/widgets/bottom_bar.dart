import 'package:logafic/widgets/bottom_bar_column.dart';
import 'package:logafic/widgets/info_text.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:flutter/material.dart';

// Alt menü
class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Theme.of(context).bottomAppBarColor,
      child: ResponsiveWidget.isSmallScreen(context)
          ? Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomBarColumn(
                      heading: 'Hakkımızda',
                      s1: 'İletişim',
                      s2: 'Hakkımızda',
                      s3: 'Kariyer',
                    ),
                    BottomBarColumn(
                      heading: 'Sosyal Medya',
                      s1: 'Twitter',
                      s2: 'Facebook',
                      s3: 'YouTube',
                    ),
                  ],
                ),
                Container(
                  color: Colors.blueGrey,
                  width: double.maxFinite,
                  height: 1,
                ),
                SizedBox(height: 20),
                InfoText(
                  type: 'Email',
                  text: 'info.logafic.com@gmail.com',
                ),
                SizedBox(height: 5),
                InfoText(
                  type: 'Adres',
                  text:
                      'Üniversitesi Rektörlüğü Çağış Yerleşkesi Üzeri 17. km, Bigadiç Caddesi, 10145 Balıkesir',
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.blueGrey,
                  width: double.maxFinite,
                  height: 1,
                ),
                SizedBox(height: 20),
                Text(
                  'Copyright © 2020 | logafic',
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomBarColumn(
                      heading: 'Hakkımızda',
                      s1: 'İletişim',
                      s2: 'Hakkımızda',
                      s3: 'Kariyer',
                    ),
                    BottomBarColumn(
                      heading: 'Sosyal Medya',
                      s1: 'Twitter',
                      s2: 'Facebook',
                      s3: 'YouTube',
                    ),
                    Container(
                      color: Colors.blueGrey,
                      width: 2,
                      height: 150,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoText(
                          type: 'Email',
                          text: 'info.logafic.com@gmail.com',
                        ),
                        SizedBox(height: 5),
                        InfoText(
                          type: 'Adres',
                          text:
                              'Üniversitesi Rektörlüğü Çağış Yerleşkesi Üzeri 17. km, Bigadiç Caddesi, 10145 Balıkesir',
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.blueGrey,
                    width: double.maxFinite,
                    height: 1,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Copyright © 2021 | Logafic',
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    );
  }
}
