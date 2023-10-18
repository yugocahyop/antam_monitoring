 import 'package:flutter/foundation.dart';

class ReadFeeder{
  static Map<String,dynamic> read(List<int> data){
    // bool startRead = false;
    int startIndex = 0;
    int dataLength = 0;
    Map<String, dynamic> value = {};
    for (var i = 0; i < data.length; i++) {
      final dataRead =data[i];
      if(dataRead == 0xFF){
        // startRead = true;
        startIndex = i;
        dataLength= data.length - (i );
        break;
      }
      // else if (dataRead == 0xA0){
      //   break;
      // }
    
    }

    
    if(dataLength == 38 ){
      value.putIfAbsent("hour", () => data[startIndex + 2]);
      value.putIfAbsent("minute", () => data[startIndex + 3]);
      value.putIfAbsent("speed", () => data[startIndex + 4]);
      value.putIfAbsent("weekday", () => data[startIndex + 5]);
      value.putIfAbsent("day", () => data[startIndex + 6]);
      value.putIfAbsent("month", () => data[startIndex + 7]);
      value.putIfAbsent("year", () => data[startIndex +  9] << 8 | data[startIndex +8]);
      value.putIfAbsent("eat index", () => data[startIndex + 10]);
      value.putIfAbsent("intensity time", () => data[startIndex + 11]);
      value.putIfAbsent("intensity multiple", () => data[startIndex + 12]);
      value.putIfAbsent("speed", () => data[startIndex + 13]);   
      value.putIfAbsent("multiple", () => data[startIndex + 14]);
      value.putIfAbsent("minWeight", () =>  (data[startIndex +  15] << 8 | data[startIndex +16])/10);

      int count = 1;
      int item = 1;
      for (var i = startIndex + 17; i < data.indexOf(0xA0) +1; i++) {
        if(count % 2 != 0){
          value.putIfAbsent("hour ${item}", () => data[i]);
          
        }else{
          value.putIfAbsent("minute ${item}", () => data[i]);
          item++;
        }

        count ++;
      }

         if(kDebugMode){
      print(value);
    }
    }

 

    return value;
  }

  static List<int> parse(Map<String, dynamic> val, List<String> jadwal){
    List<int> result = [];

    result.add(0xff);
    result.add(0xfe);
    result.add(val["speed"] as int);
    result.add((val["isMultipleMode"] as int));
    
    result.add(val["intensity"] as int);
    result.add(val["intensity"] as int);
    result.add(val["foodMultiple"] as int);

    for (var i = 0; i < (jadwal.length > 10? 10: jadwal.length); i++) {
      final split = jadwal[i].split(".");
      final hour = int.tryParse(split[0]) ??0 ;
      final miute = int.tryParse(split[1]) ??0 ;


      result.add(hour);
      result.add(miute);
    }

    if(jadwal.length < 10){
      for (var i = jadwal.length; i < 10; i++) {
        result.add(0);
        result.add(0);
      }
    }

    result.add(0xa0);

    return result;
  }

}