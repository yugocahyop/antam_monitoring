import 'package:antam_monitoring/home/widget/popupInterval.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterInterval extends StatefulWidget {
   FilterInterval({super.key, required this.onChange});

  int interval =1;

  Function onChange;

  @override
  State<FilterInterval> createState() => _FilterIntervalState();
}

class _FilterIntervalState extends State<FilterInterval> {
   double wide = 16 / 9;
   String intervalText = "1 detik";

  int calculateTime(String time, String timeUnit){
    int timeR = 0;
    int val = int.tryParse(time) ?? 0;
    switch (timeUnit) {
      case "detik":
        timeR = val;
        break;
      case "menit":
        timeR = val *60;
        break;
      case "jam":
        timeR = val * 3600;
        break;
      default:
    }

    return timeR;
  }

  @override
  Widget build(BuildContext context) {
      final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: ()async{
        final split = intervalText.split(" ");
        final r = await showDialog(
                          context: context,
                          builder: ((context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.93),
                              child: PopupInterval(
                               time: split[0],
                               timeUnit: split[1],
                              ),
                            );
                          }));
        if(r != null){
          widget.interval = calculateTime(r[0], r[1]);
          setState(() {
            intervalText = "${r[0]} ${r[1]}";
          });

          widget.onChange();
        }
        
      },
      child: SizedBox(
        width: lWidth < 900 ? 100 : 270,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: lWidth < 900 ? 100 : 270,
              decoration: BoxDecoration(
                  color: MainStyle.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(4, 4),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.05).toInt()),
                        blurRadius: 10,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(-4, -4),
                        color: Colors.white.withAlpha((255 * 0.5).toInt()),
                        blurRadius: 13,
                        spreadRadius: 0),
                    BoxShadow(
                        offset: const Offset(6, 6),
                        color: MainStyle.primaryColor
                            .withAlpha((255 * 0.10).toInt()),
                        blurRadius: 20,
                        spreadRadius: 0),
                  ]),
              child: Wrap(
                // alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                      width: 100,
                      child: Text(
                        "Interval",
                        style: MyTextStyle.defaultFontCustom(Colors.black,
                            (lWidth / lheight) < wide && lWidth > 900 ? 24 : 14),
                      )),
                  Container(
                    width: 120,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(10,3,10,3),
                    decoration: BoxDecoration(
                      color: MainStyle.primaryColor,
                      borderRadius: BorderRadius.circular(5) 
                    ),
                    child: Text(intervalText, style: MyTextStyle.defaultFontCustom(Colors.white, 15),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}