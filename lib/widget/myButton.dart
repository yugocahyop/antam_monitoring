import 'package:flutter/material.dart';

import '../style/textStyle.dart';



class MyButton extends StatelessWidget{
  final Color color;
  final String text;

  Widget? icon;
  final Function() onPressed;
  Color textColor;
  // double? height;
  double? width;

  MyButton({Key? key, required this.color, required this.text, required this.onPressed, this.icon, required this.textColor, this.width});


  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        )),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        // ),
        backgroundColor: MaterialStateProperty.all(color),
        elevation: MaterialStateProperty.all(5),
        // minimumSize: Size(88, 36),

        // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30)),
       
        shadowColor: MaterialStateProperty.all(const Color(0xff6CB6D4)),
      ).copyWith(
        // shadowColor: MaterialStateProperty.resolveWith((states) =>  color),
        overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) return color;
          if (states.contains(MaterialState.hovered)) return Colors.green;
          if (states.contains(MaterialState.pressed))
            return Colors.black.withOpacity(0.5);
          return Colors.black; // D,
        }),
      );

      final logicalScreenSize = MediaQuery.of(context).size;
    final logicalWidth = logicalScreenSize.width;
    final logicalHeight = logicalScreenSize.height;
     final MyTextStyle ts = MyTextStyle(logicalHeight);


    // TODO: implement build
      return Container(
         constraints: width ==null? null: BoxConstraints.tightFor( width: width!  ),
          child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility( visible: icon != null, child: Center(child: icon ?? const Icon(Icons.dangerous)) ),
                   Visibility(visible: icon != null && text.isNotEmpty, child: SizedBox(width: icon != null? 10: 0,)),
                  Visibility(
                    visible: text.isNotEmpty,
                    child: Text(
                      text,
                      style: ts.defaultFontSmall(textColor),
                    ),
                  ),
                ],
              )));
  }

    
}