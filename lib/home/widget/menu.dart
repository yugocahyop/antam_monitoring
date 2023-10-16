part of home;

class Menu extends StatefulWidget {
  Menu({super.key, required this.menuItem});

  List<Map<String, dynamic>> menuItem;

  @override
  State<Menu> createState() => _MenuState();
}

final grad_colors = [
  MainStyle.primaryColor.withAlpha(((255 * 0.4) * 0.3).toInt()),
  MainStyle.primaryColor.withAlpha(((255 * 0.3) * 0.3).toInt()),
  MainStyle.primaryColor.withAlpha(((255 * 0.1) * 0.3).toInt()),
];

final double wide = 16 / 9;

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
      width: (lWidth / lheight) < wide ? 400 : 250,
      // height: 740,
      height: (lWidth / lheight) < wide ? 1500 : 800,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MainStyle.secondaryColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: MainStyle.primaryColor.withAlpha((255 * 0.05).toInt()),
                offset: Offset(4, 4),
                blurRadius: 10,
                spreadRadius: 0),
            BoxShadow(
                color: MainStyle.primaryColor.withAlpha((255 * 0.1).toInt()),
                offset: Offset(
                  6,
                  6,
                ),
                blurRadius: 40,
                spreadRadius: 0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/logo_antam.svg",
            width: (lWidth / lheight) < wide ? 300 : 150,
          ),
          Expanded(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.menuItem
                .map((e) => GestureDetector(
                      onTap: () {
                        widget.menuItem
                            .where((element) =>
                                (element["isActive"] as bool) == true)
                            .first["isActive"] = false;
                        setState(() {
                          e["isActive"] = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(bottom: 20),
                        width: (lWidth / lheight) < wide ? 400 : 200,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !(e["isActive"] as bool)
                              ? [BoxShadow(color: Colors.transparent)]
                              : [
                                  BoxShadow(
                                      offset: Offset(0, 8),
                                      blurRadius: 60,
                                      spreadRadius: 0,
                                      color: MainStyle.primaryColor.withAlpha(
                                          ((255 * 0.13) * 0.3).toInt())),
                                  BoxShadow(
                                      offset: Offset(0, 5.5),
                                      blurRadius: 41,
                                      spreadRadius: 0,
                                      color: MainStyle.primaryColor.withAlpha(
                                          ((255 * 0.9) * 0.3).toInt())),
                                  BoxShadow(
                                      offset: Offset(0, 2.5),
                                      blurRadius: 30,
                                      spreadRadius: 0,
                                      color: MainStyle.primaryColor.withAlpha(
                                          ((255 * 0.07) * 0.3).toInt())),
                                  BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 22,
                                      spreadRadius: 0,
                                      color: MainStyle.primaryColor.withAlpha(
                                          ((255 * 0.06) * 0.3).toInt())),
                                  BoxShadow(
                                      offset: Offset(0, 0.5),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      color: MainStyle.primaryColor.withAlpha(
                                          ((255 * 0.04) * 0.3).toInt())),
                                ],
                          // color: (e["isActive"] as bool)
                          //     ? MainStyle.primaryColor
                          //     : null,
                          gradient: (e["isActive"] as bool)
                              ? LinearGradient(
                                  colors: [
                                      MainStyle.primaryColor,
                                      MainStyle.primaryColor
                                    ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight)
                              : LinearGradient(
                                  colors: grad_colors,
                                  stops: [0, 0.6, 1],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: (lWidth / lheight) < wide ? 80 : 35,
                              child: Icon(
                                e["icon"],
                                size: (lWidth / lheight) < wide ? 55 : 25,
                                color: (e["isActive"] as bool)
                                    ? Colors.white
                                    : MainStyle.primaryColor,
                              ),
                            ),
                            SizedBox(
                              width: (lWidth / lheight) < wide ? 220 : 120,
                              child: Text(
                                e["title"],
                                style: MyTextStyle.defaultFontCustom(
                                    (e["isActive"] as bool)
                                        ? Colors.white
                                        : MainStyle.primaryColor,
                                    (lWidth / lheight) < wide ? 28 : 15),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 25,
                              color: (e["isActive"] as bool)
                                  ? Colors.white
                                  : MainStyle.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          )),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: MainStyle.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: MainStyle.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
