part of home;

class Account_alarm extends StatelessWidget {
  Account_alarm({super.key, required this.alarm});

  List<Map> alarm;

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: lWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 500,
            child: Row(
              children: alarm
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.circle,
                            color: (e["isActive"] as bool)
                                ? Colors.red
                                : Colors.grey,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            e["title"] as String,
                            style:
                                MyTextStyle.defaultFontCustom(Colors.grey, 14),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            width: 270,
            child: Row(
              children: [
                Text(
                  "10:30 AM",
                  style: MyTextStyle.defaultFontCustom(Colors.black, 14,
                      weight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "10/07/1991",
                  style: MyTextStyle.defaultFontCustom(
                    Colors.black,
                    14,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SvgPicture.asset(
                  "assets/user.svg",
                  width: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "admin",
                    style: MyTextStyle.defaultFontCustom(
                      MainStyle.primaryColor,
                      14,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
