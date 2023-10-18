
// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class BluetoothSerial{

//   StreamSubscription? scanSub;
//   List<BluetoothDevice> devices= [];
//   BluetoothConnection? connection;
//   StreamSubscription? listenSub;
//   List<int> readData =[];

// write(String data){
//     if(connection != null){
//        connection!.output.add(Uint8List.fromList(utf8.encode(data))  );
//     }
//   }

//   Future<void>  disconnect()async{
//      if(connection != null){
      
      
//       await connection!.close();
//       if(listenSub != null)await listenSub!.cancel();
//       readData.clear();
//      }
//   }

//   Future<bool> connect(String address, {String? data, List<int>? dataList})async{

//     // bool isConnected = await FlutterBluetoothSerial.instance.isConnected;

//     // if(isConnected){
//     //   await disconnect();
//     // }
//         await FlutterBluetoothSerial.instance.cancelDiscovery();
//     connection = await BluetoothConnection.toAddress(address);

//     if (kDebugMode) {
//       print("isConnected : ${connection!.isConnected}");
//     }

//     if(connection!.isConnected){
//        listenSub = connection!.input!.listen((data) {
//         if(readData.contains(0xA0)){
//           if(data.length <28){
//             readData.clear();
//           }
//           else{
//             return;
//           }
//         } 
//         final dataList = data.toList();
//         for (var i = 0; i < dataList.length; i++) {
//           readData.add(dataList[i]);
//         }
//       }); 
//     }

//     if(data != null && connection!.isConnected){
//       connection!.output.add(Uint8List.fromList(utf8.encode(data ?? ""))  );
//       // connection!.output.addStream(stream)
//     }else if(dataList != null && connection!.isConnected){
//       connection!.output.add(Uint8List.fromList(dataList)  );
//     }
    
//     return connection!.isConnected;
    
//   }

//   Future<void> StopScan()async{
//     if(scanSub != null){
//       // assert (scanSub != null);
//       scanSub!.cancel();
//     }

//     await FlutterBluetoothSerial.instance.cancelDiscovery();
//   }

//    StartScan(){
//     devices.clear();

//     scanSub= FlutterBluetoothSerial.instance.startDiscovery().listen((event) {
//       print("${event.device.name ?? "unknown"} rssi: ${event.rssi}");
//       if(devices.where((element) => element.address == event.device.address).isEmpty){
//          devices.add(event.device);
//       }
      
//      });

//     //  Future.delayed(const Duration(milliseconds: 5000), (() => StopScan()));
//   }
// }