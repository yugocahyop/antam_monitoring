import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/myDropDownGreen.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/myDropDownWhite.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/widget/form.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CallSetting extends StatefulWidget {
  const CallSetting({super.key});

  @override
  State<CallSetting> createState() => _CallSettingState();
}

class _CallSettingState extends State<CallSetting> {
  String dataNum = "5";
  List<Map<String, dynamic>> titleData = [
    {
      "title": "Role",
      "width": 169,
    },
    {
      "title": "Name",
      "width": 169,
    },
    {
      "title": "Action",
      "width": 84,
    }
  ];

  List<dynamic> userData = [
    // {"email": "test@test.com", "isAdmin": true, "id": "1"},
    // {"email": "test@test.com", "isAdmin": true, "id": "2"},
    // {"email": "test@test.com", "isAdmin": false, "id": "3"},
    // {"email": "test@test.com", "isAdmin": false, "id": "3"},
    // {"email": "test@test.com", "isAdmin": false, "id": "3"},
  ];
  int page = 1;
  int maxPage = 1;

  int offset = 0;

  nextData() {
    if (page == maxPage) return;
    userData.clear();
    setState(() {});
    page++;
    offset += int.tryParse(dataNum) ?? 0;

    getUserData(offset);
  }

  prevData() {
    if (page == 1) return;
    userData.clear();
    setState(() {});
    page--;
    offset -= int.tryParse(dataNum) ?? 0;

    getUserData(offset);
  }

  firstData() {
    userData.clear();
    setState(() {});
    page = 1;
    offset = 0;
    getUserData(offset);
  }

  lastData() {
    final num = int.tryParse(dataNum) ?? 0;
    userData.clear();

    setState(() {});

    page = maxPage;

    offset = (num * maxPage) - 5;
    getUserData(offset);
  }

  changeDataNum() {
    page = 1;
    offset = 0;
    getUserData(offset);
  }

  bool isLoading = true;

  getUserData(int offset) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final api = ApiHelper();

    final r = await api.callAPI(
        qString.isEmpty
            ? "/call/find?limit=$dataNum&offset=$offset"
            : "/call/find?limit=$dataNum&offset=$offset&q=$qString",
        "POST",
        "{}",
        true);

    if (r["error"] == null) {
      if (kDebugMode) {
        print("user data: ${r['data']}");
      }
      userData.clear();
      userData = r["data"];

      final int count = r["count"];

      maxPage = (count / (int.tryParse(dataNum) ?? 0)).ceil();

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String qString = "";

  bool validasi(
      Mytextfield_label name, Mytextfield_label role, Mytextfield_label phone) {
    RegExp exp_phone =
        RegExp(r'^(\+62|62)?[\s-]?0?8[1-9]{1}\d{1}[\s-]?\d{4}[\s-]?\d{2,5}$');

    final isMatchPhonre = exp_phone.hasMatch(phone.con.text);

    if (name.con.text.isEmpty) {
      name.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        name.focusNode.requestFocus();
      });

      return false;
    } else if (role.con.text.isEmpty) {
      role.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        role.focusNode.requestFocus();
      });

      return false;
    } else if (phone.con.text.isEmpty || !isMatchPhonre) {
      phone.startShake();

      if (!isMatchPhonre) {
        final c = Controller();

        c.showSnackBar(context, 'Bentuk telephone salah');
      }

      Future.delayed(Duration(milliseconds: 200), () {
        phone.focusNode.requestFocus();
      });

      return false;
    }

    return true;
  }

  updateUser(String id, String name, String role, String phone) async {
    final api = ApiHelper();

    final r = await api.callAPI("/call/$id", "PUT",
        jsonEncode({"role": role, "name": name, "phone": phone}), true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Update $name berhasil");

      final user = userData.firstWhere((element) => element["_id"] == id);

      user["name"] = name;
      user["role"] = role;
      user["phone"] = phone;

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Update $name gagal - ${r["error"]}");
    }
  }

  deleteUser(String id, String name) async {
    final api = ApiHelper();

    final r = await api.callAPI("/call/$id", "DELETE", "", true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Delete $name berhasil");

      final user = userData.firstWhere((element) => element["_id"] == id);

      userData.remove(user);

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Delete $name gagal - ${r["error"]}");
    }
  }

  createUser(String name, String role, String phone) async {
    final api = ApiHelper();

    final r = await api.callAPI("/call/", "POST",
        jsonEncode({"role": role, "name": name, "phone": phone}), true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Tambah berhasil");

      firstData();

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Tambah gagal - ${r["error"]}");
    }
  }

  late Mytextfield_label serchText;

  seachTap(String val) {
    qString = val;
    page = 1;
    offset = 0;
    getUserData(0);
  }

  addData() {
    final c = Controller();
    c.heroPageRoute(
        context,
        MyForm(
            title: "Tambah Kontak",
            height: 420,
            onSubmit: (mapTextField) {
              bool r = validasi(mapTextField["Nama"]!, mapTextField["Role"]!,
                  mapTextField["Nomor WA"]!);

              // print("object ${mapTextField["Nama"]}");

              if (!r) {
                return;
              } else {
                createUser(
                    mapTextField["Nama"]!.con.text,
                    mapTextField["Role"]!.con.text,
                    mapTextField["Nomor WA"]!.con.text);
              }
              Navigator.pop(context);
            },
            listTextParam: [
              {"label": "Nama", "hint": "Nama lengkap"},
              {"label": "Role", "hint": "Contoh: teknisi, manager, developer "},
              {"label": "Nomor WA", "hint": "+62 81212341234 "}
            ]));
  }

  editData(String id, String nama, String role, String phone) {
    final c = Controller();
    c.heroPageRoute(
        context,
        MyForm(
            title: "Edit Kontak",
            height: 420,
            onSubmit: (mapTextField) {
              bool r = validasi(mapTextField["Nama"]!, mapTextField["Role"]!,
                  mapTextField["Nomor WA"]!);

              // print("object ${mapTextField["Nama"]}");

              if (!r) {
                return;
              } else {
                updateUser(
                    id,
                    mapTextField["Nama"]!.con.text,
                    mapTextField["Role"]!.con.text,
                    mapTextField["Nomor WA"]!.con.text);
              }
              Navigator.pop(context);
            },
            listTextParam: [
              {"label": "Nama", "hint": "Nama lengkap", "value": nama},
              {
                "label": "Role",
                "hint": "Contoh: teknisi, manager, developer ",
                "value": role
              },
              {"label": "Nomor WA", "hint": "+62 81212341234 ", "value": phone}
            ]));
  }

  deleteData(String id, String name) {
    final c = Controller();
    c.goToDialog(
        context,
        AlertDialog(
          title: Text("Hapus $name ?"),
          actions: [
            SizedBox(
              width: 80,
              child: MyButton(
                  color: MainStyle.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "No"),
            ),
            MainStyle.sizedBoxW10,
            SizedBox(
              width: 80,
              child: MyButton(
                  color: MainStyle.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    deleteUser(id, name);
                  },
                  text: ("Yes")),
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData.clear;
    setState(() {});
    getUserData(0);

    serchText = Mytextfield_label(
        onTap: (val) => seachTap(val),
        isBorder: true,
        width: 120,
        hintText: "search",
        obscure: false);
  }

  @override
  Widget build(BuildContext context) {
    final lwidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 500,
      height: 540,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Emergency Call Setting",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      Text(
                        "Merupakan menu untuk mensetting emergency call. (max 5) ",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      ),
                    ],
                  )
                ],
              ),
              const Icon(
                Icons.phone,
                color: MainStyle.primaryColor,
                size: 60,
              )
            ],
          ),
          MainStyle.sizedBoxH10,
          const SizedBox(
            width: 500,
            child: Divider(
              color: Color(0xff9ACAC8),
            ),
          ),
          MainStyle.sizedBoxH10,
          Container(
            width: 500,
            decoration: BoxDecoration(
                color: const Color(0xffC4DBD9),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(0xff9ACAC8),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      child: Text(
                        "Table Call",
                        style: MyTextStyle.defaultFontCustom(Colors.white, 12),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Color(0xff9ACAC8)),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 170,
                        child: TextButton(
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                              Text(
                                " Tambah Kontak",
                                style: MyTextStyle.defaultFontCustom(
                                    Colors.white, 16),
                              ),
                            ],
                          ),
                          onPressed: () => addData(),
                        ),
                      ),
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color(0xffC4DBD9),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Tampilkan "),
                                  MyDropDownWhite(
                                      width: 50,
                                      items: const [
                                        "5",
                                        "10",
                                        "25",
                                        "50",
                                        "100",
                                      ],
                                      value: dataNum,
                                      onChange: (val) {
                                        setState(() {
                                          dataNum = val ?? "";

                                          changeDataNum();
                                        });
                                      }),
                                  const Text(" data "),
                                ],
                              ),
                              serchText
                            ],
                          ),
                          Container(
                            width: lwidth <= 500 ? 300 : 425,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: titleData
                                  .map((e) => Container(
                                        width: lwidth <= 500
                                            ? ((e["title"] == "Role")
                                                ? (90)
                                                : (e["title"] == "Name")
                                                    ? (120)
                                                    : e["width"])
                                            : e["width"],
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Color(0xff6CABA7)),
                                        child: Center(
                                          child: Text(
                                            e["title"],
                                            style:
                                                MyTextStyle.defaultFontCustom(
                                                    Colors.white, 15),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Container(
                            width: lwidth <= 500 ? 300 : 425,
                            height: 150,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10))),
                            child: isLoading
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                      MainStyle.sizedBoxW10,
                                      Text("Loading Data")
                                    ],
                                  )
                                : userData.isEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info_rounded,
                                            color: MainStyle.primaryColor,
                                          ),
                                          MainStyle.sizedBoxW10,
                                          Text("No data")
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount: userData.length,
                                        itemBuilder: ((context, index) {
                                          final Color color = (index % 2) == 0
                                              ? const Color(0xfff2f2f2)
                                              : const Color(0xffd9d9d9);
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: lwidth <= 500
                                                    ? 90
                                                    : titleData.firstWhere(
                                                        (element) =>
                                                            element["title"] ==
                                                            "Role")["width"],
                                                height: 50,
                                                color: color,
                                                child: Center(
                                                  child: Text(
                                                      userData[index]["role"],
                                                      style: MyTextStyle
                                                          .defaultFontCustom(
                                                              Colors.black,
                                                              lwidth <= 500
                                                                  ? 10
                                                                  : 12)),
                                                ),
                                              ),
                                              Container(
                                                width: lwidth <= 500
                                                    ? 120
                                                    : titleData.firstWhere(
                                                        (element) =>
                                                            element["title"] ==
                                                            "Name")["width"],
                                                height: 50,
                                                color: color,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          userData[index]
                                                              ["name"],
                                                          style: MyTextStyle
                                                              .defaultFontCustom(
                                                                  Colors.black,
                                                                  lwidth <= 500
                                                                      ? 10
                                                                      : 12)),
                                                      Text(
                                                          userData[index]
                                                              ["phone"],
                                                          style: MyTextStyle
                                                              .defaultFontCustom(
                                                                  Colors.black,
                                                                  lwidth <= 500
                                                                      ? 10
                                                                      : 12)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: titleData.firstWhere(
                                                    (element) =>
                                                        element["title"] ==
                                                        "Action")["width"],
                                                height: 50,
                                                color: color,
                                                child: Center(
                                                  child: MyDropDownGreen(
                                                      width: 60,
                                                      items: [
                                                        "Pilih",
                                                        "Edit",
                                                        "Hapus"
                                                      ],
                                                      value: "Pilih",
                                                      onChange: (val) {
                                                        if (val!
                                                            .contains("Edit")) {
                                                          editData(
                                                              userData[index]
                                                                  ["_id"],
                                                              userData[index]
                                                                  ["name"],
                                                              userData[index]
                                                                  ["role"],
                                                              userData[index]
                                                                  ["phone"]);
                                                        } else if (val!
                                                            .contains(
                                                                "Hapus")) {
                                                          deleteData(
                                                            userData[index]
                                                                ["_id"],
                                                            userData[index]
                                                                ["name"],
                                                          );
                                                        }
                                                      }),
                                                ),
                                              ),
                                            ],
                                          );
                                        })),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainStyle.sizedBoxH10,
                                Text(
                                  "Halaman $page dari $maxPage",
                                  style: MyTextStyle.defaultFontCustom(
                                      Colors.black, 14),
                                ),
                                MainStyle.sizedBoxH10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Opacity(
                                      opacity: page == 1 ? 0.6 : 1,
                                      child: MyButton(
                                          color: const Color(0xfff2f2f2),
                                          text: "<<",
                                          onPressed: () => firstData(),
                                          textColor: Colors.black),
                                    ),
                                    Opacity(
                                      opacity: page == 1 ? 0.6 : 1,
                                      child: MyButton(
                                          color: const Color(0xfff2f2f2),
                                          text: "< Prev",
                                          onPressed: () => prevData(),
                                          textColor: Colors.black),
                                    ),
                                    Opacity(
                                      opacity: page == maxPage ? 0.6 : 1,
                                      child: MyButton(
                                          color: const Color(0xfff2f2f2),
                                          text: "Next >",
                                          onPressed: () => nextData(),
                                          textColor: Colors.black),
                                    ),
                                    Opacity(
                                      opacity: page == maxPage ? 0.6 : 1,
                                      child: MyButton(
                                          color: const Color(0xfff2f2f2),
                                          text: ">>",
                                          onPressed: () => lastData(),
                                          textColor: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
