import 'package:antam_monitoring/controller/controller.dart';
import 'package:antam_monitoring/sign-up/sign-up.dart';
import 'package:flutter/material.dart';

import '../../widget/myTextField.dart';

class Login_controller extends Controller {
  signUp_login(BuildContext context, Function done) async {
    final r = await super.pageRoute(context, SignUp());

    // Future.value(r).then((value) => signUpDone(r, done));

    if (r as bool) {
      done();
    }
  }
}
