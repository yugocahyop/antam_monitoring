import 'package:antam_monitoring/home/widget/listRiwayat.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopupTgl extends StatefulWidget {
   PopupTgl({super.key, required this.isLast, required this.today});

   bool isLast;
   int today;

  @override
  State<PopupTgl> createState() => _PopupTglState();
}

class _PopupTglState extends State<PopupTgl> {
  String pilihWaktuRiwayat = "";
  String pilihWaktuPengambilan = "";

  DateFormat df1 = DateFormat("dd/MM/yyyy HH:mm", 'id_ID');
  
  @override
  Widget build(BuildContext context) {
    final lWidth = MediaQuery.of(context).size.width;
    final lheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: lWidth < 900 ? lWidth *0.9 : lWidth * 0.3,
          height: lheight * 0.4,
          decoration: BoxDecoration(
            color: MainStyle.secondaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text("Waktu ${widget.isLast ? "akhir" : "awal"} pengambilan data",
                  style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 15),
              ),
              MainStyle.sizedBoxH10,
              InkWell(
                onTap: ()async{
                  final r = await showDialog(
                          context: context,
                          builder: ((context) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.93),
                              child: ListRiwayat(
                               
                              ),
                            );
                  }));

                  if(r != null){
                    widget.today = r["time"];
                    pilihWaktuRiwayat = r["title"];
                    pilihWaktuPengambilan = df1.format(DateTime.fromMillisecondsSinceEpoch(widget.today));

                    setState(() {
                      
                    });
                  }

                  
                },
                child: Container(
                  // width: lWidth *0.3,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: MainStyle.thirdColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(pilihWaktuRiwayat.isNotEmpty ? pilihWaktuRiwayat :
                         "Pilih Waktu ${widget.isLast ? "Akhir" : "Awal"} dari Riwayat",
                          style: MyTextStyle.defaultFontCustom(Colors.black, 14),
                        ),
                    ],
                  ),
                ),
              ),
        
              Center(
                child: Text("- atau -", style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 12),),
              ),
        
              InkWell(
                onTap: ()async{
                  final now = DateTime.now();
                        
                        final date = await showDatePicker(
                          context: context,
                          currentDate: DateTime.fromMillisecondsSinceEpoch(0),
                          initialDate:
                              DateTime.fromMillisecondsSinceEpoch(widget.today),
                          firstDate: DateTime.fromMillisecondsSinceEpoch(
                              now.millisecondsSinceEpoch - (2419200000 * 2)),
                          lastDate: now,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              // The below-written code will only affect the pop-up window.
                              data: ThemeData(
                                // I tried to match my picker with your photo.
                                useMaterial3: true,
                                brightness: Brightness.light,
                                colorSchemeSeed: MainStyle.primaryColor,
                                // // Write your own code for customizing the date picker theme.
                                // indicatorColor: MainStyle.primaryColor,
                                // colorScheme: ColorScheme(
                                //     brightness: Brightness.light,
                                //     primary: MainStyle.primaryColor,
                                //     onPrimary: MainStyle.secondaryColor,
                                //     secondary: MainStyle.primaryColor,
                                //     onSecondary: MainStyle.secondaryColor,
                                //     error: Colors.red,
                                //     onError: Colors.red,
                                //     background: MainStyle.primaryColor,
                                //     onBackground: MainStyle.secondaryColor,
                                //     surface: MainStyle.secondaryColor,
                                //     onSurface: MainStyle.primaryColor),
        
                                datePickerTheme: DatePickerThemeData(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    headerForegroundColor: MainStyle.primaryColor,
                                    yearForegroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return MainStyle.primaryColor;
                                      }
                                      return Colors.black;
                                    }),
                                    dayForegroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return MainStyle.primaryColor;
                                      } else if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.black.withAlpha(55);
                                      }
                                      return Colors.black;
                                    }),
                                    yearBackgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return MainStyle.secondaryColor;
                                      }
                                      return Colors.transparent;
                                    }),
                                    dayBackgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return MainStyle.secondaryColor;
                                      }
                                      return Colors.transparent;
                                    })),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: MainStyle
                                        .primaryColor, // button text color
                                  ),
                                ),
                                textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: MainStyle.primaryColor,
                                  selectionColor:
                                      MainStyle.primaryColor.withAlpha(155),
                                  selectionHandleColor: MainStyle.primaryColor,
                                ),
                              ),
                              child: child ?? const SizedBox(),
                            );
                          },
                        );
        
                        final time = await showTimePicker(context: context,
                         initialTime: TimeOfDay(hour: 0, minute: 0),
                              builder: (context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                          );
        
                        if (date != null || time != null) {
                          if(date != null && time != null){
                                  widget.today = (date!.millisecondsSinceEpoch +
                              (time!.hour * 3600000) +
                              (time!.minute * 60000)
                              ) ;
                          }
                          else if(time !=null) {
                                  widget.today += 
                              (time!.hour * 3600000) +
                              (time!.minute * 60000)
                               ;
                          }
                          else if(date !=null) {
                                  widget.today += 
                              date!.millisecondsSinceEpoch
                               ;
                          }
        
                          pilihWaktuPengambilan = df1.format(
                            DateTime.fromMillisecondsSinceEpoch(widget.today));
        
                          // DateFormat df2 = DateFormat("HH:00");
                          // widget.jamValue = df2.format(
                          //     (DateTime.fromMillisecondsSinceEpoch(
                          //         widget.today)));
        
                          // widget.today += (jam.indexOf(widget.jamValue) *
                          //         3600000) -
                          //     ((jam.indexOf(widget.jamValue) == (jam.length - 1)
                          //         ? 60000
                          //         : 0));
                          setState(() {});
        
                          
                        }
                },
                child: Container(
                  // width: lWidth *0.3,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: MainStyle.thirdColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(pilihWaktuPengambilan.isNotEmpty  ? pilihWaktuPengambilan :
                         "Pilih Waktu ${widget.isLast ? "Akhir" : "Awal"} Pengambilan Data",
                          style: MyTextStyle.defaultFontCustom(Colors.black, 14),
                        ),
                    ],
                  ),
                ),
              ),
        
              MainStyle.sizedBoxH20,
        
              MyButton(color: MainStyle.primaryColor, text: "Submit", onPressed: (){
                Navigator.pop(context, widget.today );
              }, textColor: Colors.white),
              MainStyle.sizedBoxH20,
              MyButton(color: Colors.red, text: "Close", onPressed: (){
                Navigator.pop(context);
              }, textColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}