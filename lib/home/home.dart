library home;

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'widget/menu.dart';
part 'widget/content_home.dart';
part 'widget/account_alarm.dart';
part 'widget/filterTgl.dart';
part 'widget/myDropDown.dart';
part 'widget/filterTangki.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final menuItems = [
    {"title": "Home", "icon": Icons.home_outlined, "isActive": true},
    {
      "title": "Data Logger",
      "icon": Icons.description_outlined,
      "isActive": false
    },
    {"title": "Emergency Call", "icon": Icons.call_outlined, "isActive": false},
    {"title": "Settings", "icon": Icons.settings_outlined, "isActive": false},
  ];
  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: lWidth,
        // height: lheight,
        child: Row(
          children: [
            Menu(
              menuItem: menuItems,
            ),
            Content_home()
          ],
        ),
      ),
    );
  }
}
