import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';

class MyDropDownGreen extends StatelessWidget {
  MyDropDownGreen(
      {super.key,
      required this.items,
      required this.value,
      this.width = 100,
      required this.onChange});

  String value;
  List<String> items;
  Function(String? value) onChange;

  double width;

  final double wide = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: 30,
      padding: EdgeInsets.only(
        left: 2,
        // right: 20,
      ),
      decoration: BoxDecoration(
          color: MainStyle.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            isDense: true,
            isExpanded: true,
            iconSize: 10,
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
                      style: MyTextStyle.defaultFontCustom(Colors.white, 10),
                    )))
                .toList()),
      ),
    );
  }
}
