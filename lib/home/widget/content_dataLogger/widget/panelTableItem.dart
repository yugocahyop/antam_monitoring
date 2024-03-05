import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PanelItem extends StatelessWidget {
  PanelItem(
      {super.key,
      required this.primaryColor,
      required this.date,
      required this.title});

  Color primaryColor;
  int date;
  String title;

  final df = DateFormat("dd/MM/yyyy HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
            width: 60,
            child: Icon(
              Icons.radio_button_on,
              color: const Color(0xffC4C4C4),
              size: 25,
            )),
        Expanded(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        df.format(DateTime.fromMillisecondsSinceEpoch(date)),
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 14,
                            weight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 14,
                            weight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 500,
                height: 20,
                child: Divider(
                  thickness: 2,
                  color: const Color(0xff9ACAC8),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
