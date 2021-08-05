import 'package:flutter/material.dart';

// Ekran görüntüleri github adresi üzerinden erişilebilir. 'https://github.com/Logafic/logafic/blob/main/SS/setting_show_dialog.png'

// ignore: must_be_immutable
class ShowImageDialogWidget extends StatefulWidget {
  String urlImage;
  ShowImageDialogWidget({Key? key, required this.urlImage}) : super(key: key);

  @override
  _ShowImageDialogWidgetState createState() => _ShowImageDialogWidgetState();
}

class _ShowImageDialogWidgetState extends State<ShowImageDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return Container(
              width: width,
              height: height,
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      color: Colors.black87,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ),
                  body: Center(
                    child: Image.network(widget.urlImage),
                  )));
        }));
  }
}
