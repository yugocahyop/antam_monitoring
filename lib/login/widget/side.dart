part of login;

class Side extends StatelessWidget {
  Side({super.key});

  final colors = [
    {"color": MainStyle.primaryColor, "index": 0},
    {"color": MainStyle.secondaryColor, "index": 1},
    {"color": MainStyle.primaryColor, "index": 2},
  ];

  @override
  Widget build(BuildContext context) {
    // final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: 160,
      child: Stack(
          children: colors
              .map((e) => Positioned(
                    left: 50 - ((e["index"] as int) * 50),
                    child: Container(
                      width: 100,
                      height: lheight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
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
