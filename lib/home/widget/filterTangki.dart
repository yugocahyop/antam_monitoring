part of home;

class FilterTangki extends StatefulWidget {
  FilterTangki(
      {super.key,
      required this.tangkiValue,
      required this.items,
      required this.onChange});

  String tangkiValue;

  List<String> items;

  Function(String value) onChange;

  // Function? dispose;

  @override
  State<FilterTangki> createState() => _FilterTangkiState();
}

class _FilterTangkiState extends State<FilterTangki> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // widget.dispose = () => this.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: lWidth < 900 ? 100 : 270,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: lWidth < 900 ? 100 : 270,
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
              // alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    width: 100,
                    child: Text(
                      "Sel",
                      style: MyTextStyle.defaultFontCustom(Colors.black,
                          (lWidth / lheight) < wide && lWidth > 900 ? 24 : 14),
                    )),
                SizedBox(
                  width: 120,
                  child: MyDropDown(
                      items: widget.items,
                      value: widget.tangkiValue,
                      onChange: (value) {
                        setState(() {
                          widget.tangkiValue = value ?? "";
                        });

                        widget.onChange(value ?? "");
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
