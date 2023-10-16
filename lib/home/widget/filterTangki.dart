part of home;

class FilterTangki extends StatefulWidget {
  FilterTangki({
    super.key,
  });

  String tangkiValue = "1";

  @override
  State<FilterTangki> createState() => _FilterTangkiState();
}

class _FilterTangkiState extends State<FilterTangki> {
  final items = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: lWidth < 900 ? 100 : 270,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: lWidth < 900 ? 100 : 270,
            decoration: BoxDecoration(
                color: MainStyle.secondaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: MainStyle.primaryColor
                          .withAlpha((255 * 0.05).toInt()),
                      blurRadius: 10,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: Offset(-4, -4),
                      color: Colors.white.withAlpha((255 * 0.5).toInt()),
                      blurRadius: 13,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: Offset(6, 6),
                      color: MainStyle.primaryColor
                          .withAlpha((255 * 0.10).toInt()),
                      blurRadius: 20,
                      spreadRadius: 0),
                ]),
            child: Wrap(
              children: [
                SizedBox(
                    width: 100,
                    child: Text(
                      "Tangki",
                      style: MyTextStyle.defaultFontCustom(Colors.black,
                          (lWidth / lheight) < wide && lWidth > 900 ? 24 : 14),
                    )),
                SizedBox(
                  width: 100,
                  child: MyDropDown(
                      items: items,
                      value: widget.tangkiValue,
                      onChange: (value) {
                        setState(() {
                          widget.tangkiValue = value ?? "";
                        });
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
