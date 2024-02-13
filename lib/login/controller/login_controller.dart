import 'dart:convert';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/home/home.dart';
import 'package:antam_monitoring/home/model/homeArgument.dart';
import 'package:antam_monitoring/login/login.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:antam_monitoring/tools/encrypt.dart';
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

  Future<void> login(List<Mytextfield> inputs, BuildContext context,
      bool isRemember, Function() toggleLoading) async {
    if (inputs.first.con.text.toLowerCase().trim() == "demo") {
      super.pageRoute(context, Home());
    }

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
