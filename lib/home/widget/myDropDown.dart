part of home;

class MyDropDown extends StatelessWidget {
  MyDropDown(
      {super.key,
      required this.items,
      required this.value,
      required this.onChange});

  String value;
  List<String> items;
  Function(String? value) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 30,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          color: MainStyle.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            value: value,
            dropdownColor: MainStyle.primaryColor,
            onChanged: (value) => onChange(value),
            items: items
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: MyTextStyle.defaultFontCustom(Colors.white, 14),
                    )))
                .toList()),
      ),
    );
  }
}
