import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:pln_rtd_mobile_flutter/core/Data/dataSource/defaultDatasource.dart';

class ApiHelper {
  String refreshToken = "";
  static String tokenMain = "";
  static String user_id = "";

  static const String POST = "POST";
  static const String GET = "GET";

  static const needleRegex = r'{#}';
  static const needle = '{#}';

  // static String url = '202.148.1.57';
  // static String url = '172.24.7.110';
  // static String url = "silver.best.antam.com";
  static String url = 'localhost';

  final RegExp exp = RegExp(needleRegex);

  String Stringerpolate(String string, List l) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);

    assert(l.length == matches.length);

    var i = -1;
    return string.replaceAllMapped(exp, (match) {
      // print(match.group(0));
      i = i + 1;
      return '${l[i]}';
    });
  }

  void catchError() {}

  void processApi(Future<String> response, Function(Map json) success,
      Function(String error) fails) {
    // if (showInfo) {
    //   setState(() {
    //     resetInfo = true;
    //     infoVisiblity = false;
    //     showInfo = false;
    //   });
    // }
    response.then((value) {
      // dev.log("$value");

      Map json = jsonDecode(value);
      bool val = json.containsKey("error");

      // dev.log("$value");
      if (!val) {
        success.call(json);
      } else {
        String error = json["error"];

        fails.call(error);

        // dev.log(error);

        // if (verifyShow) return;

        // setState(() {
        //   info(error);
        // });
      }
    });
  }

  Future<String> callAPIRef(
      String api, String method, String data, bool useToken) async {
    final client = http.Client();

    try {
      final response = await client
          .send(http.Request(
              method, Uri.parse("http://${ApiHelper.url}:7003" + api))
            ..headers["authorization"] = "Bearer $tokenMain"
            ..headers["Content-Type"] = "application/json"
            ..body = data)
          .timeout(const Duration(seconds: 15));

      //

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.stream.bytesToString();
      }

      Future<String> r = response.stream.bytesToString();

      return r;
    } catch (e) {
      // print(e);
      return "{\"error\": \"can't contact server\"}";
    }
  }

  Future<Map<String, dynamic>> callAPI(
      String api, String method, String data, bool useToken) async {
    final client = http.Client();

    // print("data  $data");

    try {
      final response = await client
          .send(http.Request(
              method, Uri.parse("http://${ApiHelper.url}:7003" + api))
            ..headers["authorization"] = "Bearer $tokenMain"
            ..headers["Content-Type"] = "application/json"
            ..body = data)
          .timeout(const Duration(seconds: 60));

      //

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(await response.stream.bytesToString());
      }
      //  else if (response.statusCode == 401) {
      //   print("refresh token");

      //   rcount++;
      //   if (rcount > 10) {
      //     rcount = 0;
      //     return "{\"error\": \"can't contact server\"}";
      //   } else {
      //     print("refresh token");
      //     getRefreshToken(ip, api, method, data, useToken);
      //     return "";
      //     // if (getRefreshToken()) {
      //     //   rcount = 0;
      //     //   return callAPI(ip, api, method, data, useToken);
      //     // }
      //   }
      // }

      String r = await response.stream.bytesToString();

      return jsonDecode(r);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return jsonDecode("{\"error\": \"Tidak bisa menghubungi server\"}");
    }
  }
}
