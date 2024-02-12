import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_animator/flutter_animator.dart';
import '../style/textStyle.dart';

class Mytextfield_label extends StatefulWidget {
  String hintText;
  bool obscure;
  TextEditingController con = TextEditingController();
  GlobalKey<AnimatorWidgetState> shake = GlobalKey<AnimatorWidgetState>();
  FocusNode focusNode = FocusNode();
  TextInputType? inputType = TextInputType.text;
  IconData? prefixIcon;
  double width;
  String suffixText;
  bool isCapitalize, isBorder;
  bool isInvalid = false;
  Function(String val)? onTap;

  Mytextfield_label(
      {Key? key,
      this.onTap,
      this.isBorder = false,
      this.inputType,
      this.prefixIcon,
      this.suffixText = "",
      this.isCapitalize = false,
      required this.width,
      required this.hintText,
      required this.obscure})
      : super(key: key) {}

  void startShake() {
    isInvalid = true;
    shake.currentState!.forward(from: 0.5);

    // focusNode.requestFocus();
  }

  void selectAll() {
    focusNode.requestFocus();

    con.selection = TextSelection(baseOffset: 0, extentOffset: con.text.length);
  }

  @override
  _Mytextfield_labelState createState() => _Mytextfield_labelState();
}

class _Mytextfield_labelState extends State<Mytextfield_label> {
  bool hidePass = true, focused = false, isCapitalize = false;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      focused = widget.focusNode.hasFocus;

      if (mounted) setState(() {});
    });

    widget.con.addListener(() {
      // print("text ${widget.con.text.length}");
      if (widget.onTap != null) {
        widget.onTap!(widget.con.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xff007591);

    var logicalScreenSize = MediaQuery.of(context).size;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;

    if (widget.inputType == null) widget.inputType = TextInputType.text;

    return Container(
        // margin: const EdgeInsets.only(top: 5),
        // padding: const EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        width: widget.width,
        height: 50,
        child: Focus(
            // onFocusChange: (focused) => {
            //       // setState(() {
            //       //   hasFocus = focused;
            //       // })
            //     },
            child: Shake(
          // springController: spring,
          // animDuration: Duration(milliseconds: 300),
          // start: 200,
          // end: 40,
          preferences:
              const AnimationPreferences(autoPlay: AnimationPlayStates.None),
          key: widget.shake,
          child: TextField(
            textCapitalization: widget.isCapitalize
                ? (widget.con.text.length < 1
                    ? TextCapitalization.words
                    : TextCapitalization.none)
                : TextCapitalization.none,
            enableInteractiveSelection: true,
            focusNode: widget.focusNode,
            enableSuggestions: false,
            autocorrect: false,
            style: MyTextStyle.defaultFontCustom(Colors.black, 14),
            cursorColor: blue,
            controller: widget.con,
            obscureText: widget.obscure && hidePass,
            keyboardType: widget.inputType!,
            decoration: InputDecoration(
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(5),
              filled: true,
              // fillColor: !focused ? Color(0xff00FBC2) : blue,
              enabledBorder: !widget.isBorder
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey))
                  : OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
              labelStyle: MyTextStyle.defaultFontCustom(
                  focused ? blue : Colors.black38, 14

                  // color: Color(0xff00FBC2),
                  ),
              hintText: widget.hintText,
              focusedBorder: !widget.isBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: widget.isInvalid
                              ? Colors.red
                              : MainStyle.primaryColor))
                  : OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
              suffixText: widget.suffixText,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: focused ? MainStyle.primaryColor : Colors.grey,
                    )
                  : null,
              suffixIcon: !widget.obscure
                  ? null
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (!mounted) return;
                          setState(() {
                            hidePass = hidePass ? false : true;
                            // obscure = hidePass ? true : false;
                          });
                        },
                        child: Icon(
                          hidePass
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                          color: Colors.black54,
                        ),
                      ),
                    ),
            ),
          ),
        )));
  }
}
