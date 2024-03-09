import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/myDropDownGreen.dart';
import 'package:antam_monitoring/home/widget/content_setting/widget/myDropDownWhite.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserRole extends StatefulWidget {
  const UserRole({super.key});

  @override
  State<UserRole> createState() => _UserRoleState();
}

class _UserRoleState extends State<UserRole> {
  String dataNum = "5";
  List<Map<String, dynamic>> titleData = [
    {
      "title": "Role",
      "width": 84,
    },
    {
      "title": "Email",
      "width": 258,
    },
    {
      "title": "Action",
      "width": 84,
    }
  ];

  List<Map<String, dynamic>> titleDataUserLog = [
    {
      "title": "Date",
      "width": 169,
    },
    {
      "title": "Log",
      "width": 253,
    },
    {
      "title": "",
      // "width": 84,
      "width": 0
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
  bool isUserLog = false;

  getUserData(int offset) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final api = ApiHelper();

    final r = await api.callAPI(
        qString.isEmpty
            ? "/${isUserLog ? "logs" : "user"}/find?limit=$dataNum&offset=$offset"
            : "/${isUserLog ? "logs" : "user"}/find?limit=$dataNum&offset=$offset&q=$qString",
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
        print("error: ${r["error"]}");
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String qString = "";

  updateUser(String email, String id, bool isAdmin) async {
    final api = ApiHelper();

    final r = await api.callAPI(
        "/user/$id",
        "PUT",
        jsonEncode({"isAdmin": isAdmin, "role": isAdmin ? "Admin" : "User"}),
        true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Update $email berhasil");

      userData.firstWhere((element) => element["email"] == email)["isAdmin"] =
          isAdmin;

      if (mounted) setState(() {});
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Update $email gagal - ${r["error"]}");
    }
  }

  late Mytextfield_label serchText;

  seachTap(String val) {
    qString = val;
    page = 1;
    offset = 0;
    getUserData(0);
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
                  Text("User Role",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      Text(
                        "Merupakan menu untuk mengganti role user ",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      ),
                    ],
                  )
                ],
              ),
              const Icon(
                Icons.manage_accounts,
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
                    InkWell(
                      onTap: () {
                        userData.clear();
                        setState(() {
                          qString = "";
                          page = 1;
                          offset = 0;
                          isUserLog = false;
                        });

                        getUserData(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: isUserLog
                                ? const Color(0xffC4DBD9)
                                : const Color(0xff9ACAC8),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: Text(
                          "Table Role",
                          style:
                              MyTextStyle.defaultFontCustom(Colors.white, 12),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        userData.clear();
                        setState(() {
                          qString = "";
                          page = 1;
                          offset = 0;
                          isUserLog = true;
                        });

                        getUserData(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: isUserLog
                                ? const Color(0xff9ACAC8)
                                : const Color(0xffC4DBD9),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: Text(
                          "Log User",
                          style:
                              MyTextStyle.defaultFontCustom(Colors.white, 12),
                        ),
                      ),
                    ),
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
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: TextButton(child: , onPressed: (),),
                    // )
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
                            width: lwidth <= 500 ? 300 : 500,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: (isUserLog
                                      ? titleDataUserLog
                                      : titleData)
                                  .map((e) => Container(
                                        width: lwidth <= 500
                                            ? ((e["title"] == "Email" ||
                                                    e["title"] == "Log")
                                                ? (isUserLog ? 235 : 165)
                                                : (e["title"] == "Role" ||
                                                        e["title"] == "Date")
                                                    ? (isUserLog ? 65 : 50)
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
                            width: lwidth <= 500 ? 300 : 500,
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
                                          DateFormat df =
                                              DateFormat("dd/MM/yyyy HH:mm:ss");
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: lwidth <= 500
                                                    ? (isUserLog ? 65 : 50)
                                                    : (isUserLog
                                                            ? titleDataUserLog
                                                            : titleData)
                                                        .firstWhere((element) =>
                                                            element["title"] ==
                                                            (isUserLog
                                                                ? "Date"
                                                                : "Role"))["width"],
                                                height: isUserLog ? 100 : 50,
                                                color: color,
                                                child: Center(
                                                  child: Text(
                                                    isUserLog
                                                        ? df.format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                userData[index][
                                                                    "datetime"]))
                                                        : userData[index][
                                                                    "isAdmin"] ??
                                                                false
                                                            ? "Admin"
                                                            : "User",
                                                    style: MyTextStyle
                                                        .defaultFontCustom(
                                                            Colors.black,
                                                            lwidth <= 500
                                                                ? 10
                                                                : 12),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: lwidth <= 500
                                                    ? (isUserLog ? 235 : 165)
                                                    : (isUserLog
                                                            ? titleDataUserLog
                                                            : titleData)
                                                        .firstWhere((element) =>
                                                            element["title"] ==
                                                            (isUserLog
                                                                ? "Log"
                                                                : "Email"))["width"],
                                                height: isUserLog ? 100 : 50,
                                                padding: isUserLog
                                                    ? EdgeInsets.all(8)
                                                    : null,
                                                color: color,
                                                child: Center(
                                                  child: Text(
                                                    isUserLog
                                                        ? userData[index]
                                                            ["data_name"]
                                                        : userData[index]
                                                            ["email"],
                                                    style: MyTextStyle
                                                        .defaultFontCustom(
                                                            Colors.black,
                                                            lwidth <= 500
                                                                ? 10
                                                                : 12),
                                                  ),
                                                ),
                                              ),
                                              isUserLog
                                                  ? Column()
                                                  : Container(
                                                      width: (isUserLog
                                                              ? titleDataUserLog
                                                              : titleData)
                                                          .firstWhere((element) =>
                                                              element[
                                                                  "title"] ==
                                                              "Action")["width"],
                                                      height:
                                                          isUserLog ? 100 : 50,
                                                      color: color,
                                                      child: Center(
                                                        child: MyDropDownGreen(
                                                            width: 60,
                                                            items: [
                                                              "Pilih",
                                                              "Atur sebagai ${userData[index]["isAdmin"] ?? false ? "User" : "Admin"}"
                                                            ],
                                                            value: "Pilih",
                                                            onChange: (val) {
                                                              if (val!.contains(
                                                                  "Admin")) {
                                                                updateUser(
                                                                    userData[
                                                                            index]
                                                                        [
                                                                        "email"],
                                                                    userData[
                                                                            index]
                                                                        ["_id"],
                                                                    true);
                                                              } else if (val!
                                                                  .contains(
                                                                      "User")) {
                                                                updateUser(
                                                                    userData[
                                                                            index]
                                                                        [
                                                                        "email"],
                                                                    userData[
                                                                            index]
                                                                        ["_id"],
                                                                    false);
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
