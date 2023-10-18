part of home;

class Account_alarm extends StatelessWidget {
  Account_alarm({super.key, required this.alarm});

  List<Map> alarm;

  final double wide = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: (lWidth / lheight) < wide
          ? 1400
          : lWidth < 900
              ? lWidth < 500
                  ? lWidth
                  : lWidth * 0.4
              : 1200,
      child: Row(
        mainAxisAlignment: lWidth < 900
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: lWidth < 900
                ? lWidth < 800
                    ? 300
                    : lWidth * 0.4
                : 500,
            child: Row(
              children: alarm
                  .map((e) => Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.circle,
                            color: (e["isActive"] as bool)
                                ? Colors.red
                                : Colors.grey,
                            size: 15,
                          ),
                          SizedBox(
                            width: (lWidth / lheight) < wide ? 3 : 2,
                          ),
                          Text(
                            e["title"] as String,
                            style: MyTextStyle.defaultFontCustom(
                                Colors.grey,
                                (lWidth / lheight) < wide && lWidth > 900
                                    ? 24
                                    : 16),
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // )
                          MainStyle.sizedBoxW10,
                        ],
                      ))
                  .toList(),
            ),
          ),
          Visibility(
            visible: lWidth >= 900,
            child: SizedBox(
              width: (lWidth / lheight) < wide ? 400 : 270,
              child: Row(
                children: [
                  Text(
                    "10:30 AM",
                    style: MyTextStyle.defaultFontCustom(
                        Colors.black, (lWidth / lheight) < wide ? 26 : 16,
                        weight: FontWeight.bold),
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  MainStyle.sizedBoxW20,
                  Text(
                    "10/07/1991",
                    style: MyTextStyle.defaultFontCustom(
                      Colors.black,
                      (lWidth / lheight) < wide ? 26 : 16,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  MainStyle.sizedBoxW20,
                  SvgPicture.asset(
                    "assets/user.svg",
                    width: 30,
                  ),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  MainStyle.sizedBoxW5,
                  Expanded(
                    child: Text(
                      "admin",
                      style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor,
                        (lWidth / lheight) < wide ? 24 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
