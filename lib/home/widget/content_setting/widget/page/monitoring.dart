import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonitoringSetting extends StatefulWidget {
  const MonitoringSetting({super.key});

  @override
  State<MonitoringSetting> createState() => _MonitoringSettingState();
}

class _MonitoringSettingState extends State<MonitoringSetting> {
  final List<Map<String, dynamic>> settingWidgetText = [
    {
      "label": "Maximum suhu",
      "hint": "Minimal 80",
      "unit": "Celcius",
      "value": 80
    },
    {
      "label": "Maximum tegangan",
      "hint": "Minimal 2, maksimal 4",
      "value": 3,
      "unit": "Volt"
    },
    {
      "label": "Maximum arus",
      "hint": "Minimal 100, masksimal 200",
      "unit": "Ampere",
      "value": 150
    },
  ];

  Map<String, Mytextfield_label> mapTextField = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < settingWidgetText.length; i++) {
      final val = settingWidgetText[i];

      Mytextfield_label tf = Mytextfield_label(
        isBorder: true,
        width: 400,
        obscure: false,
        hintText: val["hint"],
        suffixText: val["unit"],
      );

      mapTextField.putIfAbsent(val["unit"], () => tf);

      mapTextField[val["unit"]]!.con.text = (val["value"] as int).toString();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 540,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Monitoring Setting",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      Text(
                        "Merupakan menu untuk mengganti parameter monnitoring ",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      ),
                    ],
                  )
                ],
              ),
              const Icon(
                Icons.bar_chart,
                color: MainStyle.primaryColor,
                size: 60,
              )
            ],
          ),
          MainStyle.sizedBoxH10,
          const SizedBox(
            width: 500,
            child: Divider(
              color: Color(0xff9ACAC8),
            ),
          ),
          Column(
              children: settingWidgetText
                  .map((e) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e["label"],
                            style: MyTextStyle.defaultFontCustom(
                                MainStyle.primaryColor, 16),
                          ),
                          mapTextField[e["unit"]]!
                        ],
                      ))
                  .toList()),
          MainStyle.sizedBoxH10,
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 200,
              child: MyButton(
                  color: MainStyle.primaryColor,
                  text: "Submit",
                  onPressed: () {},
                  textColor: Colors.white),
            ),
          ),
          MainStyle.sizedBoxH10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/database.svg",
                color: MainStyle.primaryColor,
                width: 60,
              ),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Node ",
                            style: MyTextStyle.defaultFontCustom(
                                Colors.black, 22,
                                weight: FontWeight.w700)),
                        Text("Synchronization",
                            style: MyTextStyle.defaultFontCustom(
                                Colors.black, 22,
                                weight: FontWeight.w700)),
                      ],
                    ),
                    MainStyle.sizedBoxH10,
                    SizedBox(
                      width: 200,
                      child: Wrap(
                        children: [
                          Text(
                            "Singkronisasi timer pada sensor Node dengan Web Server ",
                            style: MyTextStyle.defaultFontCustom(
                                const Color(0xff919798), 14),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 200,
                height: 135,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    // color: const Color(0xff9ACAC8),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Synchronization: 12/12/2023 10:00",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 14),
                    ),
                    MainStyle.sizedBoxH10,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 200,
                        child: MyButton(
                            color: MainStyle.primaryColor,
                            text: "Synchronize Now",
                            onPressed: () {},
                            textColor: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
