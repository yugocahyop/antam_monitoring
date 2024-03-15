import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/widget/form.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key, required this.email, required this.isAdmin});

  final String email;
  final bool isAdmin;
  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  bool validasi(Mytextfield_label password, Mytextfield_label nPassword,
      Mytextfield_label nPassword2) {
    if (password.con.text.isEmpty) {
      password.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        password.focusNode.requestFocus();
      });

      return false;
    } else if (nPassword.con.text.isEmpty) {
      nPassword.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        nPassword.focusNode.requestFocus();
      });

      return false;
    } else if (nPassword2.con.text.isEmpty) {
      nPassword2.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        nPassword2.focusNode.requestFocus();
      });

      return false;
    } else if (nPassword2.con.text != nPassword.con.text) {
      nPassword2.startShake();

      final c = Controller();

      c.showSnackBar(context, 'Password tidak sama');

      Future.delayed(Duration(milliseconds: 200), () {
        nPassword2.focusNode.requestFocus();
      });

      return false;
    }

    return true;
  }

  Future<bool> updatePasword(
      String password, String nPassword, String nPassword2) async {
    final api = ApiHelper();

    final r = await api.callAPI(
        "/account/changepassword",
        "POST",
        jsonEncode({
          "pass": base64.encode(utf8.encode(password)),
          "nPassword": base64.encode(utf8.encode(nPassword)),
          "nPasswordCon": base64.encode(utf8.encode(nPassword2))
        }),
        true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Update password berhasil");

      if (mounted) setState(() {});

      return true;
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Update password gagal - ${r["error"]}");

      return false;
    }
  }

  gantiPassword() {
    final c = Controller();
    c.heroPageRoute(
        context,
        MyForm(
            title: "Ganti Password",
            height: 420,
            onSubmit: (mapTextField) async {
              bool r = validasi(
                  mapTextField["Password"]!,
                  mapTextField["Password baru"]!,
                  mapTextField["Konfirmasi password"]!);

              // print("object ${mapTextField["Nama"]}");

              if (!r) {
                return;
              } else {
                final rr = await updatePasword(
                    mapTextField["Password"]!.con.text,
                    mapTextField["Password baru"]!.con.text,
                    mapTextField["Konfirmasi password"]!.con.text);

                if (rr) {
                  Navigator.pop(context);
                }
              }
            },
            listTextParam: [
              {
                "label": "Password",
                "hint": "Password lama anda",
                "obscure": true
              },
              {
                "label": "Password baru",
                "hint": "Password baru anda",
                "obscure": true
              },
              {
                "label": "Konfirmasi password",
                "hint": "Konfirmasi password baru anda",
                "obscure": true
              }
            ]));
  }

  @override
  Widget build(BuildContext context) {
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
                  Text("Account",
                      style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                          weight: FontWeight.w700)),
                  MainStyle.sizedBoxH10,
                  Row(
                    children: [
                      Text(
                        "Masuk Sebagai ",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      ),
                      Text(
                        widget.isAdmin ? "Administrator" : "User",
                        style: MyTextStyle.defaultFontCustom(
                            MainStyle.primaryColor, 14),
                      ),
                    ],
                  )
                ],
              ),
              Icon(
                Icons.person,
                color: MainStyle.primaryColor,
                size: 60,
              )
            ],
          ),
          MainStyle.sizedBoxH10,
          SizedBox(
            width: 500,
            child: Divider(
              color: Color(0xff9ACAC8),
            ),
          ),
          MainStyle.sizedBoxH10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Akun Anda",
                  style: MyTextStyle.defaultFontCustom(Colors.black, 22,
                      weight: FontWeight.w700)),
              TextButton(
                  onPressed: () => gantiPassword(),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: pi * 0.7,
                        child: const Icon(
                          Icons.key,
                          color: const Color(0xff919798),
                          size: 20,
                        ),
                      ),
                      Text(
                        "Edit Password",
                        style: MyTextStyle.defaultFontCustom(
                            const Color(0xff919798), 14),
                      )
                    ],
                  )),
            ],
          ),
          MainStyle.sizedBoxH10,
          Row(
            children: [
              Image.asset(
                "assets/circleAvatarBig.png",
                width: 120,
              ),
              MainStyle.sizedBoxW10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.email,
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor, 14,
                        weight: FontWeight.w600),
                  ),
                  MainStyle.sizedBoxH10,
                  Text(
                    widget.isAdmin ? "Administrator" : "User",
                    style: MyTextStyle.defaultFontCustom(
                        MainStyle.primaryColor, 14,
                        weight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
