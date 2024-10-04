import 'dart:convert';

import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loadmore/loadmore.dart';

class ListRiwayat extends StatefulWidget {
  const ListRiwayat({super.key});

  @override
  State<ListRiwayat> createState() => _ListRiwayatState();
}

class _ListRiwayatState extends State<ListRiwayat> {

  List<Map<String,dynamic>> listRiwayat = [];
  int maxData = 1, offsetNum = -1, limit =20;

  showSnackBar(String text) {
    var snackbar = SnackBar(
      content: Text(text),
      // duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  getRiwayat(int offset)async{
    final api = ApiHelper();

    // while (ApiHelper.tokenMain == null) {
    //   await Future.delayed(const Duration(seconds: 1));
    // }

    // print("is alarm: $isAlarm");

    final r = await api.callAPI(
        "/monitoring/find/start?offset=$offset&limit=$limit",
        "POST",
        "",
        true);

    if (r["error"] == null) {

      // if (kDebugMode) {
      //   print("riwayat: $r");
      // }

      List<dynamic> data = r['data'] as List<dynamic>;

      maxData = r["count"];

      if (offset == 0) listRiwayat.clear();

      DateFormat df1 = DateFormat("dd/MM/yyyy HH:mm", 'id_ID');

      for (var i = 0; i < data.length; i++) {
        final val = data[i];

        listRiwayat.add({
          "timeStamp_server": val["timeStamp_server"],
          "title":"${df1.format(DateTime.fromMillisecondsSinceEpoch(val["timeStamp_server"]))} ${ (val["isStart"] as bool) ? "(Start)" : "(Stop)" }"
        });
      }
    }

     if (kDebugMode) {
        print("riwayat: $listRiwayat");
      }

    if(listRiwayat.isEmpty){
      showSnackBar("tidak ada riwayat");
      Navigator.pop(context);
    }

    if(mounted){
      setState(() {
        
      });
    }
  }

 
  
  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.height;
    final lheight = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: lWidth < 900 ? lWidth *0.9 : lWidth * 0.3,
          height: lWidth < 900? lheight* 0.5: lheight * 0.2,
          color: MainStyle.secondaryColor,
          child: LoadMore(
            textBuilder: (loadMoreStatus) {
                    return loadMoreStatus == LoadMoreStatus.loading
                        ? "Loading Data"
                        : "";
                  },
            isFinish: listRiwayat.length >= maxData,
            onLoadMore: () async{
              if(offsetNum != -1){
                offsetNum += limit;
              }else{
                offsetNum =0;
              }
              
      
              await getRiwayat(offsetNum);
      
              return Future.value(true);
            },
            child: ListView.builder(
              itemCount: listRiwayat.length,
              itemBuilder: ((context, index) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    hoverColor: Colors.black26,
                    title: Text(listRiwayat[index]["title"], style: MyTextStyle.defaultFontCustom(Colors.black, 15),),
                    onTap: () {
                      Navigator.pop(context, {"title": listRiwayat[index]["title"], "time": listRiwayat[index]["timeStamp_server"]});
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}