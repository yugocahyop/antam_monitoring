part of signUp;

class Up extends StatelessWidget {
  Up({super.key});

  final colors = [
    {"color": MainStyle.primaryColor, "index": 0},
    {"color": MainStyle.secondaryColor, "index": 1},
    {"color": MainStyle.primaryColor, "index": 2},
  ];

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    // final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: lWidth,
      height: 160,
      child: Stack(
          children: colors
              .map((e) => Positioned(
                    top: (e["index"] as int) == 2
                        ? 0
                        : 35 - ((e["index"] as int) * 35),
                    child: Container(
                      width: lWidth,
                      height: (e["index"] as int) == 2 ? 65 : 100,
                      decoration: BoxDecoration(
                          borderRadius:  (e["index"] as int) == 2 ? BorderRadius.vertical(bottom: Radius.circular(32))  :BorderRadius.circular(32),
                          color: e["color"] as Color,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: Offset(4, 4))
                          ]),
                    ),
                  ))
              .toList()),
    );
  }
}
