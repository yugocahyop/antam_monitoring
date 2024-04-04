import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MyExcel {
  final alphabet = [
    'A',
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  Excel create() {
    //   nama = "/" + (nama ?? "excel_file.xlsx");

    //   if (nama != null) {
    //     if (!nama.contains('.xlsx')) {
    //       throw "error name must contain .xlsx";
    //     }
    //   }

    // if ((await path.exists())) {
    //   // TODO:
    //   print("exist");
    // } else {
    //   // TODO:
    //   print("not exist");
    //   await path.create(recursive: true);
    // }

    // File excel_file = File(path.path + (nama));

    // if (await excel_file.exists()) {
    //   await excel_file.delete();
    // }

    // await excel_file.create(recursive: true);

    final excel = Excel.createExcel();

    // final fileBytes = excel.save();

    // File(join(path.path + (nama)))
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(fileBytes ?? []);

    // return Excel.decodeBytes(excel_file.readAsBytesSync());
    return excel;
  }

  read({String? path2, String? name, ByteData? data}) async {
    if (data != null) {
      // print(data.buffer.asUint8List());
      return Excel.decodeBytes(data.buffer.asUint8List());
    }

    // if ((await path.exists())) {
    //   // TODO:
    //   // print("exist");
    // } else {
    //   // TODO:
    //   // print("not exist");
    //   await path.create();
    // }

    final file = path2 ?? "";
    final bytes = File(file).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    return excel;
  }

  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm:ss');

  Future<void> populate(
    Excel excel,
    List<String> header,
    List<String?> sheetNames, {
    required List<dynamic> listAny,
  }) async {
    for (var si = 0; si < sheetNames.length; si++) {
      Sheet sheetObject = excel[sheetNames[si]! ?? 'Sheet1'];

      CellStyle cellStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Calibri),
          horizontalAlign: HorizontalAlign.Left);
      ;

      CellStyle headerStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Calibri),
          horizontalAlign: HorizontalAlign.Left,
          bold: true);

      final list = listAny;

      // if (list == null) {
      //   return;
      // }

      //header
      // int count = -1;
      // String prefix = "";

      for (int i = 0; i < header.length; i++) {
        final val = header[i];
        // final cell = sheetObject.cell(CellIndex.indexByString(
        //     (prefix + alphabet[i % alphabet.length]) + (1).toString()));

        final cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(val);
        cell.cellStyle = headerStyle;

        // if (i == (alphabet.length - 1)) {
        //   prefix = alphabet[0 + ++count];
        // }
      }

      // final listV = list[sheetNames[si]] ?? [];

      //data

      if (list.isNotEmpty) {
        for (var i = 0; i < list.length; i++) {
          final val = list[i] as Map<String, dynamic>;

          // print(val);
          for (int j = 0; j < header.length; j++) {
            // final cell = sheetObject.cell(CellIndex.indexByString(
            //     (j < alphabet.length
            //             ? alphabet[j]
            //             : alphabet[0] + alphabet[j % alphabet.length]) +
            //         (i + 2).toString()));

            final cell = sheetObject.cell(
                CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1));

            if (header[j] == "Tanggal") {
              cell.value = TextCellValue(formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(
                      val['timeStamp_server'] as int)));

              cell.cellStyle = cellStyle;
            } else {
              final headerSplit = header[j].replaceAll("\n", " ").split(" ");
              // if (kDebugMode) {
              //   print("header split: $headerSplit");
              //   print(
              //       "tangkiData: ${val["tangkiData"][(int.tryParse(headerSplit[1]) ?? 0) - 1][(int.tryParse(headerSplit[3]) ?? 0) - 1][headerSplit.last.toLowerCase()]}");

              // }
              if (headerSplit.length == 3) {
                cell.value = DoubleCellValue(
                    (val["tangkiData"][7 - 1][1 - 1][headerSplit.last] ?? 0) /
                        1);
              } else {
                cell.value = DoubleCellValue((val["tangkiData"]
                                    [(int.tryParse(headerSplit[1]) ?? 0) - 1]
                                [(int.tryParse(headerSplit[3]) ?? 0) - 1]
                            [headerSplit.last.toLowerCase()] ??
                        0) /
                    1);
              }

              cell.cellStyle = cellStyle;
            }

            if (kDebugMode) {
              print(cell.value);
            }
          }
          await Future.delayed(const Duration(microseconds: 1));
        }
      }
    }

    // excel.delete('Sheet1');

    // final fileBytes = excel.save();

    // File(join(path.path.toString() + "/"+ (nama ?? "excel_file.xlsx")))
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(fileBytes ?? []);
  }

  Future<void> append(
    Excel excel,
    List<String> header,
    List<String?> sheetNames,
    int offset, {
    required List<dynamic> listAny,
  }) async {
    for (var si = 0; si < sheetNames.length; si++) {
      Sheet sheetObject = excel[sheetNames[si]! ?? 'Sheet1'];

      if (kDebugMode) {
        print("append initial length: ${sheetObject.rows.length}");
      }

      CellStyle cellStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Calibri),
          horizontalAlign: HorizontalAlign.Left);
      ;

      // CellStyle headerStyle = CellStyle(
      //     fontFamily: getFontFamily(FontFamily.Calibri),
      //     horizontalAlign: HorizontalAlign.Left,
      //     bold: true);

      final list = listAny;

      // if (list == null) {
      //   return;
      // }

      if (list.isNotEmpty) {
        for (var i = 0; i < list.length; i++) {
          final val = list[i] as Map<String, dynamic>;

          // print(val);
          for (int j = 0; j < header.length; j++) {
            // final cell = sheetObject.cell(CellIndex.indexByString(
            //     (j < alphabet.length
            //             ? alphabet[j]
            //             : alphabet[0] + alphabet[j % alphabet.length]) +
            //         (i + 2).toString()));

            final cell = sheetObject.cell(CellIndex.indexByColumnRow(
                columnIndex: j, rowIndex: i + 1 + offset));

            if (header[j] == "Tanggal") {
              cell.value = TextCellValue(formatter.format(
                  DateTime.fromMillisecondsSinceEpoch(
                      val['timeStamp_server'] as int)));

              cell.cellStyle = cellStyle;
            } else {
              final headerSplit = header[j].replaceAll("\n", " ").split(" ");
              // if (kDebugMode) {
              //   print("header split: $headerSplit");
              //   print(
              //       "tangkiData: ${val["tangkiData"][(int.tryParse(headerSplit[1]) ?? 0) - 1][(int.tryParse(headerSplit[3]) ?? 0) - 1][headerSplit.last.toLowerCase()]}");

              // }

              if (headerSplit.length == 3) {
                cell.value = DoubleCellValue(
                    (val["tangkiData"][7 - 1][1 - 1][headerSplit.last] ?? 0) /
                        1);
              } else {
                cell.value = DoubleCellValue((val["tangkiData"]
                                    [(int.tryParse(headerSplit[1]) ?? 0) - 1]
                                [(int.tryParse(headerSplit[3]) ?? 0) - 1]
                            [headerSplit.last.toLowerCase()] ??
                        0) /
                    1);
              }

              cell.cellStyle = cellStyle;
            }

            if (kDebugMode) {
              print(cell.value);
            }
          }
          await Future.delayed(const Duration(microseconds: 1));
        }
      }
    }

    // excel.delete('Sheet1');

    // final fileBytes = excel.save();

    // File(join(path.path.toString() + "/"+ (nama ?? "excel_file.xlsx")))
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(fileBytes ?? []);
  }

  Future<void> save(Excel excel, String nama) async {
    excel.delete('Sheet1');
    if (kIsWeb) {
      // await Future.delayed(const Duration(microseconds: 1));
      await excel.save(
          fileName: "$nama-${DateTime.now().millisecondsSinceEpoch}.xlsx");
    } else {
      var fileBytes = await excel.save();
      // var directory = await getApplicationDocumentsDirectory();

      // File(join(
      //     '$directory/$nama-${DateTime.now().millisecondsSinceEpoch}.xlsx'))
      //   ..createSync(recursive: true)
      //   ..writeAsBytesSync(fileBytes!);
      if (!await FlutterFileDialog.isPickDirectorySupported()) {
        if (kDebugMode) {
          print("Picking directory not supported");
        }
        return;
      }

      final pickedDirectory = await FlutterFileDialog.pickDirectory();

      if (pickedDirectory != null) {
        await FlutterFileDialog.saveFileToDirectory(
          directory: pickedDirectory!,
          data: Uint8List.fromList(fileBytes ?? []),
          mimeType: "image/jpeg",
          fileName: "$nama-${DateTime.now().millisecondsSinceEpoch}.xlsx",
          replace: true,
        );
      }
    }
  }

  void createCell(
      Sheet sheetObject, dynamic? value, String range, CellStyle cellStyle) {
    //  final cellOperator = sheetObject
    //           .getRangeByName(range);
    //       cellOperator.value = value ?? "";
    //       cellOperator.cellStyle = cellStyle;

    final cell = sheetObject.cell(CellIndex.indexByString(range));
    cell.value = value ?? "";
    cell.cellStyle = cellStyle;
  }
}
