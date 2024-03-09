import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';

class MyDropDown extends StatelessWidget {
  MyDropDown(
      {super.key,
      required this.items,
      required this.value,
      required this.onChange});

  String value;
  List<String> items;
  Function(String? value) onChange;

  final double wide = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
      width: lWidth < 900 ? 80 : 150,
      height: 30,
      padding: EdgeInsets.only(
          left: lWidth < 900 ? 3 : 20, right: lWidth < 600 ? 3 : 20),
      decoration: BoxDecoration(
          color: MainStyle.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            value: value,
            dropdownColor: MainStyle.primaryColor,
            onChanged: (value) => onChange(value),
            items: items
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: MyTextStyle.defaultFontCustom(
                          Colors.white,
                          (lWidth / lheight) < wide && lWidth > 900
                              ? 23
                              : lWidth < 900
                                  ? 12
                                  : 14),
                    )))
                .toList()),
      ),
    );
  }
}
