// import'dart:html';
// import  'dart:io';

import 'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFile.dart' if (dart.library.html)'package:antam_monitoring/home/widget/content_dataLogger/tools/downloadFileWeb.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/tools/apiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPanel extends StatefulWidget {
  SupportPanel(
      {super.key,
      required this.name,
      required this.width});

  String name;

  double width;

  @override
  State<SupportPanel> createState() => _SupportPanelState();
}

class _SupportPanelState extends State<SupportPanel> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (value) {
          setState(() {
            isHover = value;
          });
        },
        onTap: (()async {
          if(kIsWeb){
            final api = ApiHelper();
            final data = await api.callAPIBytes("/support/download?file=${widget.name}", "GET", "",true);
            
            // downloadFile('http://${ApiHelper.url}:7003/static/${r["file"]}', r["file"]);
            downloadFile(data,widget.name);
          }else{
            final Uri url = Uri.parse('http://${ApiHelper.url}:7003/staticsupport/${widget.name}');
            launchUrl(url);
          }
        }),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: widget.width,
          decoration: BoxDecoration(
              color: isHover
                  ? MainStyle.primaryColor.withOpacity(0.9)
                  : MainStyle.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.description_outlined,
                  color: MainStyle.secondaryColor, size: 35),
              MainStyle.sizedBoxW10,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.substring(0, 1).toUpperCase() +
                          widget.name.substring(1, widget.name.length),
                      textAlign: TextAlign.start,
                      style: MyTextStyle.defaultFontCustom(Colors.white, 16),
                    ),
                  
                  ],
                ),
              ),
             
            ],
          ),
        ));
  }
}
