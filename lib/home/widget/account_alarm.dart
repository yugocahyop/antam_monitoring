part of home;

class Account_alarm extends StatefulWidget {
  Account_alarm({super.key, required this.alarm});

  List<Map> alarm;

  @override
  State<Account_alarm> createState() => _Account_alarmState();
}

class _Account_alarmState extends State<Account_alarm> {
  String date = "", time = "";

  DateFormat df = DateFormat("dd/MM/yyyy");

  String addZero(int) {
    String res = int.toString();

    if (int.toString().length == 1) {
      res = "0$res";
    }
    return res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime dateTime = DateTime.now();

    date = df.format(dateTime);

    time =
        "${addZero(dateTime.hour % 12)}:${addZero(dateTime.minute)} ${dateTime.hour >= 12 ? "PM" : "AM"}";

    setState(() {});

    Timer.periodic(Duration(seconds: 30), (timer) {
      DateTime dateTime = DateTime.now();

      date = df.format(dateTime);

      time =
          "${addZero(dateTime.hour % 12)}:${addZero(dateTime.minute)} ${dateTime.hour > 12 ? "PM" : "AM"}";

      if (mounted) setState(() {});
    });
  }

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
              children: widget.alarm
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
                    time,
                    style: MyTextStyle.defaultFontCustom(
                        Colors.black, (lWidth / lheight) < wide ? 26 : 16,
                        weight: FontWeight.bold),
                  ),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  MainStyle.sizedBoxW20,
                  Text(
                    date,
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
