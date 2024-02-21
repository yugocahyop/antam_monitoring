import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  MyForm(
      {super.key,
      required this.title,
      required this.listTextParam,
      required this.onSubmit,
      required this.height});

  String title;
  List<Map<String, dynamic>> listTextParam;
  Function(Map<String, Mytextfield_label> mapTextField) onSubmit;
  double height;
  // Function validate;

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  Map<String, Mytextfield_label> mapTextField = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < widget.listTextParam.length; i++) {
      final val = widget.listTextParam[i];

      Mytextfield_label tf = Mytextfield_label(
        isBorder: true,
        width: 400,
        obscure: false,
        hintText: val["hint"] ?? "",
        suffixText: val["unit"] ?? "",
      );

      mapTextField.putIfAbsent(val["label"], () => tf);

      mapTextField[val["label"]]!.con.text = (val["value"] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 500,
          height: widget.height,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: 500,
                height: 50,
                decoration: BoxDecoration(
                    color: MainStyle.thirdColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                child: Text(
                  widget.title,
                  style: MyTextStyle.defaultFontCustom(Colors.black, 18,
                      weight: FontWeight.w700),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                width: 500,
                decoration: BoxDecoration(
                  color: MainStyle.secondaryColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Column(
                      children: widget.listTextParam
                          .map((e) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e["label"],
                                    style: MyTextStyle.defaultFontCustom(
                                        MainStyle.primaryColor, 16),
                                  ),
                                  mapTextField[e["label"]]!
                                ],
                              ))
                          .toList(),
                    ),
                    MainStyle.sizedBoxH10,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 100,
                              child: MyButton(
                                color: MainStyle.primaryColor,
                                text: "cancel",
                                textColor: Colors.white,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: MyButton(
                                color: MainStyle.primaryColor,
                                text: "Submit",
                                textColor: Colors.white,
                                onPressed: () {
                                  widget.onSubmit(mapTextField);
                                  // Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
