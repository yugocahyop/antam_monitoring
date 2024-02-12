import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';

class MyDropDownWhite extends StatelessWidget {
  MyDropDownWhite(
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
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            iconDisabledColor: Colors.black,
            iconEnabledColor: Colors.black,
            value: value,
            dropdownColor: Colors.white,
            onChanged: (value) => onChange(value),
            items: items
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: MyTextStyle.defaultFontCustom(Colors.black, 12),
                    )))
                .toList()),
      ),
    );
  }
}
