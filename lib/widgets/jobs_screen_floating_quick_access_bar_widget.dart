import 'package:logafic/controllers/authController.dart';
import 'package:logafic/routing/router_names.dart';
import 'package:logafic/widgets/responsive.dart';
import 'package:flutter/material.dart';
// JobsScreen İş ilanları ve Etkinlik ilanları butonlarının bulunduğu bar

class JobsScreenFloatingQuickAccessBar extends StatefulWidget {
  const JobsScreenFloatingQuickAccessBar({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  _JobsScreenFloatingQuickAccessBar createState() =>
      _JobsScreenFloatingQuickAccessBar();
}

class _JobsScreenFloatingQuickAccessBar
    extends State<JobsScreenFloatingQuickAccessBar> {
  List _isHovering = [false, false];
  List<Widget> rowElements = [];
  AuthController authController = AuthController.to;
  List<String> items = ['İş ilanları', 'Etkinlik ilanları'];
  List<IconData> icons = [
    Icons.code_off_outlined,
    Icons.explore_off,
  ];

  List<Widget> generateRowElements() {
    rowElements.clear();
    for (int i = 0; i < items.length; i++) {
      Widget elementTile = InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onHover: (value) {
          setState(() {
            value ? _isHovering[i] = true : _isHovering[i] = false;
          });
        },
        onTap: () {
          if (i % 2 == 0) {
            authController.isRank = true;
            Navigator.pushNamed(context, JobsScreenRoute);
          } else {
            authController.isRank = false;
            Navigator.pushNamed(context, JobsScreenRoute);
          }
        },
        child: Text(
          items[i],
          style: TextStyle(
            color: _isHovering[i]
                ? Theme.of(context).primaryTextTheme.button!.decorationColor
                : Colors.black54,
          ),
        ),
      );
      Widget spacer = SizedBox(
        height: widget.screenSize.height / 60,
        child: VerticalDivider(
          width: 1,
          color: Colors.blueGrey[100],
          thickness: 1,
        ),
      );
      rowElements.add(elementTile);
      if (i < items.length - 1) {
        rowElements.add(spacer);
      }
    }

    return rowElements;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveWidget.isSmallScreen(context)
              ? widget.screenSize.width / 12
              : widget.screenSize.width / 5,
          right: ResponsiveWidget.isSmallScreen(context)
              ? widget.screenSize.width / 12
              : widget.screenSize.width / 5,
        ),
        child: ResponsiveWidget.isSmallScreen(context)
            ? Column(
                children: [
                  ...Iterable<int>.generate(items.length).map(
                    (int pageIndex) => Padding(
                      padding:
                          EdgeInsets.only(top: widget.screenSize.height / 80),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: widget.screenSize.height / 45,
                              bottom: widget.screenSize.height / 45,
                              left: widget.screenSize.width / 20),
                          child: Row(
                            children: [
                              Icon(
                                icons[pageIndex],
                                color: Theme.of(context).iconTheme.color,
                              ),
                              SizedBox(width: widget.screenSize.width / 20),
                              InkWell(
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () {
                                  if (pageIndex % 2 == 0) {
                                    authController.isRank = true;
                                    Navigator.pushNamed(
                                        context, JobsScreenRoute);
                                  } else {
                                    authController.isRank = false;
                                    Navigator.pushNamed(
                                        context, JobsScreenRoute);
                                  }
                                },
                                child: Text(
                                  items[pageIndex],
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.screenSize.height / 50,
                    bottom: widget.screenSize.height / 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: generateRowElements(),
                  ),
                ),
              ),
      ),
    );
  }
}
