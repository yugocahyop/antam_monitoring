import 'package:antam_monitoring/home/widget/myDropDown.dart';
import 'package:antam_monitoring/style/mainStyle.dart';
import 'package:antam_monitoring/style/textStyle.dart';
import 'package:antam_monitoring/widget/myButton.dart';
import 'package:antam_monitoring/widget/myTextField.dart';
import 'package:antam_monitoring/widget/myTextField_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupInterval extends StatefulWidget {
   PopupInterval({super.key, required this.time, required this.timeUnit});

   String timeUnit;
   String time;

  @override
  State<PopupInterval> createState() => _PopupIntervalState();
}

class _PopupIntervalState extends State<PopupInterval> {
  Mytextfield_label time = Mytextfield_label(isBorder: true, width: 100, hintText: "", obscure: false, inputType: TextInputType.number,);
  List<String> timeUnits = [
    "detik",
    "menit",
    "jam"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    time.con.text = widget.time;
    
  }

  
  @override
  Widget build(BuildContext context) {
    // final lWidth = MediaQuery.of(context).size.width;
    // final lheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 400,
          height: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: MainStyle.secondaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Set interval", style: MyTextStyle.defaultFontCustom(MainStyle.primaryColor, 12),),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.close, size:  25, color: Colors.black38,))
                ],
                
              ),

              MainStyle.sizedBoxH10,

              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  time,
                  MyDropDown(items: timeUnits, value: widget.timeUnit, onChange: (value) {
                    widget.timeUnit = value ?? "";
                    setState(() {
                      
                    });
                  }),
                  MainStyle.sizedBoxW10,
                  MyButton(color: MainStyle.primaryColor, text: "Ok", onPressed: (){
                    if(int.tryParse(time.con.text) != null){
                      Navigator.pop(context, [time.con.text,widget.timeUnit ]);
                    }else{
                      time.startShake();
                    }
                    
                  }, textColor: Colors.white)
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}