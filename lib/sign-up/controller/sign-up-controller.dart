import 'dart:async';
import 'dart:convert';

import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:flutter/cupertino.dart';

import '../../widget/myTextField.dart';

class SignUpController extends Controller {
  Future<void> signUp(List<Mytextfield> inputs, BuildContext context,
      Function() toggleOverlay) async {
    if (!super.validate(inputs, context)) return;

    RegExp exp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    RegExp exp_phone =
        RegExp(r'^(\+62|62)?[\s-]?0?8[1-9]{1}\d{1}[\s-]?\d{4}[\s-]?\d{2,5}$');

    if (inputs.first.inputType == TextInputType.emailAddress) {
      if (!exp.hasMatch(inputs.first.con.text)) {
        inputs.first.startShake();

        Future.delayed(Duration(milliseconds: 200), () {
          inputs.first.focusNode.requestFocus();
        });

        super.showSnackBar(context, "Bentuk email tidak benar");

        return;
      }
    }

    if (!exp_phone.hasMatch(inputs.last.con.text)) {
      inputs.last.startShake();

      Future.delayed(Duration(milliseconds: 200), () {
        inputs.last.focusNode.requestFocus();
      });

      super.showSnackBar(context, "Bentuk phone tidak benar");

      return;
    }

    inputs.forEach((e) => e.isInvalid = false);

    toggleOverlay();

    final api = ApiHelper();

    final r = api.callAPI(
        "/register",
        ApiHelper.POST,
        jsonEncode({
          "email": inputs[0].con.text,
          "password": inputs[1].con.text,
          "passwordCon": inputs[1].con.text,
          "phone": inputs.last.con.text
        }),
        false);

    await Future.value(r)
        .then((value) => signUpDone(value, context, () => toggleOverlay()));
  }

  void signUpDone(Map<String, dynamic> r, BuildContext context,
      Function() toggleOverlay) async {
    if (r["error"] == null) {
      await Future.delayed(Duration(seconds: 1));

      toggleOverlay();

      Navigator.pop(context, true);
    } else {
      await Future.delayed(Duration(seconds: 1));

      toggleOverlay();

      super.showSnackBar(context, r["error"] as String);
    }
  }
}
