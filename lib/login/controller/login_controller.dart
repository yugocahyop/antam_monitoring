import 'dart:convert';
import 'dart:math';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/homeMobileMaster.dart'
    if (dart.library.html) 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/home/model/homeArgument.dart';
import 'package:antam_monitoring/login/login.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/encrypt.dart';
import 'package:antam_monitoring/widget/form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widget/myTextField.dart';

class Login_controller extends Controller {
  signUp_login(BuildContext context, Function done) async {
    final r = await super.heroPageRoute(context, const SignUp());

    // Future.value(r).then((value) => signUpDone(r, done));

    if (r as bool) {
      done();
    }
  }

  Future<bool> requestOTP(String email, BuildContext context) async {
    final api = ApiHelper();

    final c = Controller();

    final r = await api.callAPI(
        "/account/forgetpassword",
        "POST",
        jsonEncode({
          "email": email,
        }),
        true);

    if (r["error"] == null) {
      c.showSnackBar(context, " Kode OTP telah dikirim ke alamat email anda.");

      return true;
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }

      c.showSnackBar(context, " ${r["error"]}");

      return false;
    }
  }

  forgetPasswordChange(BuildContext context, String email) {
    final c = Controller();
    c.heroPageRoute(
        context,
        MyForm(
            title: "Lupa Password",
            height: 420,
            onSubmit: (mapTextField) async {
              // print("object ${mapTextField["Nama"]}");

              if (mapTextField["Kode OTP"]!.con.text.isEmpty) {
                mapTextField["Kode OTP"]!.startShake();
                return;
              } else if (mapTextField["Password baru"]!.con.text.isEmpty) {
                mapTextField["Password baru"]!.startShake();
                return;
              } else if (mapTextField["Konfirmasi password"]!
                  .con
                  .text
                  .isEmpty) {
                mapTextField["Konfirmasi password"]!.startShake();
                return;
              } else if (mapTextField["Password baru"]!.con.text !=
                  mapTextField["Konfirmasi password"]!.con.text) {
                mapTextField["Konfirmasi password"]!.startShake();
                return;
              } else {
                final rr = await updatePasword(
                    email,
                    mapTextField["Kode OTP"]!.con.text,
                    mapTextField["Password baru"]!.con.text,
                    mapTextField["Konfirmasi password"]!.con.text,
                    context);

                if (rr) {
                  Navigator.pop(context);
                }
              }
            },
            listTextParam: [
              {
                "label": "Kode OTP",
                "hint":
                    "Kode OTP yang di kirim ke alamat email anda (habis 5 menit)",
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

  Future<bool> updatePasword(String email, String otp, String nPassword,
      String nPassword2, BuildContext context) async {
    final api = ApiHelper();

    final r = await api.callAPI(
        "/account/changepassword",
        "POST",
        jsonEncode({
          "email": email,
          "otp": base64.encode(utf8.encode(otp)),
          "nPassword": base64.encode(utf8.encode(nPassword)),
          "nPasswordCon": base64.encode(utf8.encode(nPassword2))
        }),
        true);

    if (r["error"] == null) {
      final c = Controller();
      c.showSnackBar(context, "Password telah di reset");

      return true;
    } else {
      if (kDebugMode) {
        print(r["error"]);
      }
      final c = Controller();
      c.showSnackBar(context, "Password gagal di reset - ${r["error"]}");

      return false;
    }
  }

  forgetPassword(BuildContext context) {
    final c = Controller();
    c.heroPageRoute(
        context,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyForm(
              title: "Lupa Password",
              height: 420,
              onSubmit: (mapTextField) async {
                // print("object ${mapTextField["Nama"]}");
          
                if (mapTextField["Email"]!.con.text.isEmpty) {
                  mapTextField["Email"]!.startShake();
                  return;
                } else {
                  final rr =
                      await requestOTP(mapTextField["Email"]!.con.text, context);
          
                  if (rr) {
                    Navigator.pop(context);
          
                    forgetPasswordChange(
                        context, mapTextField["Email"]!.con.text);
                  }
                }
              },
              listTextParam: [
                {
                  "label": "Email",
                  "hint": "Email anda",
                },
              ]),
        ));
  }

  Future<void> login(List<Mytextfield> inputs, BuildContext context,
      bool isRemember, Function() toggleLoading) async {
    // if (inputs.first.con.text.toLowerCase().trim() == "demo") {
    //   super.pageRoute(context, Home());
    // }

    if (!super.validate(inputs, context)) return;

    inputs.forEach((e) => e.isInvalid = false);
    toggleLoading();
    final api = ApiHelper();

    final data = {
      "email": base64.encode(utf8.encode(inputs.first.con.text)),
      "password": base64.encode(utf8.encode(inputs.last.con.text))
    };

    final r = api.callAPI("/auth", "POST", jsonEncode(data), false);

    await Future.value(r).then(
        (value) => login_done(inputs, value, context, () => toggleLoading()));

    if (isRemember) {
      final encrypt = MyEncrtypt();
      super.saveSharedPref("com.antam.email", inputs.first.con.text);
    } else {
      super.saveSharedPref("com.antam.email", "");
    }
  }

  Future<void> login_done(List<Mytextfield> inputs, Map<String, dynamic> r,
      BuildContext context, Function() toggleLoading) async {
    if (r["error"] == null) {
      await Future.delayed(const Duration(seconds: 1));

      if (kDebugMode) {
        print(r["isAdmin"]);
      }

      ApiHelper.tokenMain = r["activeToken"];

      final encrypt = MyEncrtypt();

      final tokensplit = ApiHelper.tokenMain.split(".");

      saveSharedPref("antam.data", encrypt.encrypt(tokensplit[0]));
      saveSharedPref("antam.log", encrypt.encrypt(tokensplit[1]));
      saveSharedPref("antam.public", encrypt.encrypt(tokensplit[2]));

      // saveSharedPref("antam.data", encrypt.encrypt(r["activeToken"]));

      saveSharedPref("antam.token",
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c");

      // saveSharedPref("antam.email", r["email"]);
      // saveSharedPref("antam.isAdmin", r["isAdmin"]);

      Home.email = r["email"] ?? "";
      Home.isAdmin = (r["isAdmin"] ?? false);

      toggleLoading();

      // await Future.delayed(Duration(milliseconds: 200));

      // super.pageRoute(context, Home());
      Navigator.pushNamed(context, "/home",
          arguments: HomeArgument(
              email: inputs.first.con.text, isAdmin: (r["isAdmin"] ?? false)));
    } else {
      await Future.delayed(const Duration(seconds: 1));

      toggleLoading();

      final error = r["error"] as String;

      if (error.contains("pass")) {
        inputs.last.startShake();

        Future.delayed(const Duration(milliseconds: 200), () {
          inputs.last.focusNode.requestFocus();
        });
      } else {
        inputs.first.startShake();
        Future.delayed(const Duration(milliseconds: 200), () {
          inputs.first.focusNode.requestFocus();
        });
      }

      super.showSnackBar(context, error);
    }
  }
}
