part of home;

class Content_home extends StatefulWidget {
  const Content_home({super.key});

  @override
  State<Content_home> createState() => _Content_homeState();
}

class _Content_homeState extends State<Content_home> {
  final alarm = [
    {
      "title": "Status",
      "isActive": true,
    },
    {
      "title": "Alarm Arus",
      "isActive": true,
    },
    {
      "title": "Alarm Tegangan",
      "isActive": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.all(20),
        width: lWidth * 0.83,
        height: lheight,
        child: Column(
          children: [
            Account_alarm(alarm: alarm),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: lWidth * 0.9,
              child: Wrap(
                children: [
                  FilterTgl(
                    title: "Dari",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FilterTgl(
                    title: "Hingga",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FilterTangki()
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                width: lWidth * 0.9,
                child: Wrap(
                  children: [
                    Container(
                      width: lWidth * 0.35,
                      height: lWidth < 1500 ? lheight * 0.7 : lheight * 0.8,
                      decoration: BoxDecoration(
                          color: MainStyle.secondaryColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(4, 4),
                                color: MainStyle.primaryColor
                                    .withAlpha((255 * 0.05).toInt()),
                                blurRadius: 10,
                                spreadRadius: 0),
                            BoxShadow(
                                offset: Offset(-4, -4),
                                color:
                                    Colors.white.withAlpha((255 * 0.5).toInt()),
                                blurRadius: 13,
                                spreadRadius: 0),
                            BoxShadow(
                                offset: Offset(6, 6),
                                color: MainStyle.primaryColor
                                    .withAlpha((255 * 0.10).toInt()),
                                blurRadius: 20,
                                spreadRadius: 0),
                          ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
