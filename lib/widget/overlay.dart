import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyOverlay extends StatelessWidget {
  MyOverlay({super.key, this.isTransparent = false, this.isBlur = false});

  bool isTransparent;
  bool isBlur;

  final loadingAnimation = SizedBox(
    width: 350,
    child: const FlareActor("assets/xirkaLoading.flr",
        alignment: Alignment.center,
        fit: BoxFit.fitWidth,
        animation: "Untitled"),
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final double cWidth = width > 450 ? width - (width > 1000 ? 250 : 0) : 500;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(
            isTransparent ? (255 * 0.2).toInt() : 255, 178, 216, 220),
      ),
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      child: Stack(
        children: [
          // Opacity(
          //   opacity: 0.3,
          //   child: Stack(
          //     children: [
          //       Align(
          //         alignment: Alignment.bottomRight,
          //         child: Transform.translate(
          //           offset: Offset(120, 100),
          //           child: Container(
          //             width:  cWidth,
          //             height: cWidth,
          //             decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               gradient: RadialGradient(colors: [
          //                 // Colors.white,
          //                 // MainStyle.textColorBlue.withAlpha((255*0.05).toInt()),
          //                 // Color.fromARGB(255, 83, 210, 224),
          //                 // Color.fromARGB(255, 168, 230, 237),
          //                    Colors.white,
          //                  Color.fromARGB(255, 189, 242, 220),
          //                         // MainStyle.textColorBlue,
          //                         Color.fromARGB(255, 178, 216, 220),

          //               ],
          //               )
          //             ),
          //           ),
          //         ),
          //       ),
          //       Align(
          //         alignment: Alignment.topLeft,
          //         child: Transform.translate(
          //           offset: Offset(-100, -100),
          //           child: Container(
          //             width: cWidth -100,
          //             height: cWidth -100,
          //             decoration:  BoxDecoration(
          //               shape: BoxShape.circle,
          //               gradient: RadialGradient(colors: [

          //                 // MainStyle.textColorBlue.withAlpha((255*0.1).toInt()),
          //                 // // Color.fromARGB(255, 83, 210, 224),
          //                 // // Color.fromARGB(255, 168, 230, 237),

          //                 // Colors.white.withAlpha(width> 500 ? 65: 123),
          //                   Colors.white,
          //                  Color.fromARGB(255, 189, 242, 220),
          //                         // MainStyle.textColorBlue,
          //                         Color.fromARGB(255, 178, 216, 220),

          //               ],
          //               )
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          !isBlur
              ? const SizedBox()
              : SizedBox(
                  width: width,
                  height: height,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),

          isBlur
              ? const SizedBox()
              : Center(
                  child: Transform.translate(
                      offset: Offset(0, -200),
                      child: Transform.scale(
                          scale: 0.8,
                          child: Hero(
                              tag: "logo",
                              child: SvgPicture.asset(
                                "assets/logo_antam.svg",
                                width: 350,
                                color: Colors.white,
                              )))),
                ),
          Center(
            child: Transform.scale(scale: 1.2, child: loadingAnimation),
          ),

          isBlur
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: width,
                      height: 150,
                      child: Transform.translate(
                          offset: const Offset(0, 10),
                          child: Transform.scale(
                              scale: 1.1,
                              child: SvgPicture.asset(
                                "assets/wave.svg",
                                width: width,
                                fit: BoxFit.fitWidth,
                              ))))),
        ],
      ),
    );
  }
}
