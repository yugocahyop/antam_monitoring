import 'package:flutter/material.dart';

import '../../style/textStyle.dart';
import '../../widget/myButton.dart';

class MyMessage_mobile extends StatefulWidget {
  MyMessage_mobile(
      {super.key, required this.warningMsg, required this.dismiss});

  String warningMsg;

  Function() dismiss;

  @override
  State<MyMessage_mobile> createState() => _MyMessage_mobileState();
}

class _MyMessage_mobileState extends State<MyMessage_mobile> {
  final wide = 16 / 9;

  bool isMsgVisible = true;
  double msgOpacity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(milliseconds: 800), () {
    //   setState(() {
    //     isMsgVisible = true;
    //   });
    // });

    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {
    //     msgOpacity = 1;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Center(
      //warning
      child: Visibility(
        visible: isMsgVisible,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: msgOpacity,
          onEnd: () {
            if (msgOpacity == 0) {
              setState(() {
                isMsgVisible = false;
              });
            }
          },
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.only(top: 30),
              width: lWidth > 600 ? lWidth * 0.7 : 500,
              height: 400,
              decoration: BoxDecoration(
                  color: const Color(0xffFEF7F1),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 30,
                        color: Colors.black26,
                        offset: Offset(0, 20))
                  ]),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 270,
                      decoration: BoxDecoration(
                        color: const Color(0xffDF7B00),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: const Color(0xffDF7B00),
                              size: 50,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Warning Message",
                              style: MyTextStyle.defaultFontCustom(
                                  Colors.black, 20,
                                  weight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: lheight < 450 ? 100 : 200,
                          width: lWidth * 0.6,
                          child: Center(
                            child: Text(
                              widget.warningMsg,
                              textAlign: TextAlign.center,
                              style: MyTextStyle.defaultFontCustom(
                                  Colors.black, lheight < 400 ? 20 : 40,
                                  weight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: lWidth > 600 ? lWidth * 0.6 : 420,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: MyButton(
                                width: 100,
                                color: const Color(0xffFCECDA),
                                text: "Dismiss",
                                onPressed: () {
                                  setState(() {
                                    msgOpacity = 0;
                                  });
                                },
                                textColor: const Color(0xffDF7B00)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
