part of home;

class FilterTgl extends StatefulWidget {
  FilterTgl({super.key, required this.title});

  String title;

  String jamValue = "00:00";

  String hariValue = "Minggu";

  @override
  State<FilterTgl> createState() => _FilterTglState();
}

class _FilterTglState extends State<FilterTgl> {
  final hari = [
    "Minggu",
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu"
  ];

  List<String> jam = ["00:00"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < 25; i++) {
      if (i != 0) {
        jam.add("${i.toString().length > 1 ? "" : "0"}$i:00");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: lWidth < 900 ? 190 : 450,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: lWidth < 900 ? 190 : 450,
            decoration: BoxDecoration(
                color: MainStyle.secondaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(4, 4),
                      color: MainStyle.primaryColor
                          .withAlpha((255 * 0.05).toInt()),
                      blurRadius: 10,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: const Offset(-4, -4),
                      color: Colors.white.withAlpha((255 * 0.5).toInt()),
                      blurRadius: 13,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: const Offset(6, 6),
                      color: MainStyle.primaryColor
                          .withAlpha((255 * 0.10).toInt()),
                      blurRadius: 20,
                      spreadRadius: 0),
                ]),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    width: 100,
                    child: Text(
                      widget.title,
                      style: MyTextStyle.defaultFontCustom(Colors.black,
                          (lWidth / lheight) < wide && lWidth > 900 ? 24 : 14),
                    )),
                SizedBox(
                  width: lWidth < 900 ? 190 : 320,
                  child: Row(
                    children: [
                      MyDropDown(
                          items: hari,
                          value: widget.hariValue,
                          onChange: (value) {
                            setState(() {
                              widget.hariValue = value ?? "";
                            });
                          }),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      MainStyle.sizedBoxW10,
                      MyDropDown(
                          items: jam,
                          value: widget.jamValue,
                          onChange: (value) {
                            setState(() {
                              widget.jamValue = value ?? "";
                            });
                          }),
                    ],
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
