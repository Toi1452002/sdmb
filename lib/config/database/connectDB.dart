// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sdmb/config/extension.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

 mixin class ConnectDB {
  Future<Database?> init() async {
    if(Platform.isWindows){
      String pathDB = 'D:/Flutter/sdmb/assets/datawd.db';
      try {
        if (await File(pathDB).exists()) {
          Database? db = await databaseFactory.openDatabase(pathDB);
          return db;
        } else {
          print("Database không tồn tại");
        }
      } catch (e) {
        print("Lỗi kết nối: $e");
      }
    }else{
      String nameDB = "DataLDB_1.db";
      var dbPath = await getDatabasesPath();
      var path = join(dbPath, nameDB);
      var exist = await databaseExists(path);
      if (exist) {
        // print('Đã có data');
        return await openDatabase(path);
      } else {
        // print('Chưa có data');
        // if (Info_App.API_DEVICE >= 30) {
        // print("Creating new copy from asset API >= 30");
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}
        ByteData data =
        await rootBundle.load(join("assets", nameDB));
        List<int> bytes =data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        return await openDatabase(path);
        // }
      }
    }

  }
  Future<Map<String, dynamic>> getRow({String? sql, String table = '', String? where})async{
    List<Map<String, dynamic>> data;
    Database? db = await init();
    data = sql !=  null ? await  db!.rawQuery(sql) : await db!.query(table,where: where);
    return data.isEmpty ? {} : data.first;
  }

  Future<List<Map<String, dynamic>>> getList({String? sql,String table = '', String? where, String? orderBy})async{
    List<Map<String, dynamic>> data = [];
    Database? db = await init();
    data = sql !=  null ? await  db!.rawQuery(sql) : await db!.query(table,where: where,orderBy: orderBy);
    return data;
  }

  Future<int> insertMap(Map<String, dynamic> map, String table)async{
    int idInsert = 0; Database? db = await init();
    idInsert = await db!.insert(table, map);
    return idInsert;
  }

  Future<void> insertList(
      {required List<Map<String, dynamic>> lstData,
        required String tbName,
        String fieldToString = ''}) async {
    Database? cnn = await init();
    var lstField = lstData[0].keys.join(",");
    int i = 0;
    var lstValue = lstData.map((e) {
      e.forEach((key, value) {
        if (fieldToString != '' && key == fieldToString) {
          lstData[i][key] = "'$value'";
        }
        if (!value.toString().isNumeric && value.toString() != 'null') {
          lstData[i][key] = "'$value'";
        }
      });
      i += 1;
      return e.values.toList();
    }).toList();
    String str_value = lstValue.join(",").replaceAll("[", "(").replaceAll(']', ')');
    String sql = '''
      INSERT INTO $tbName($lstField) VALUES $str_value
    ''';
    await cnn!.rawInsert(sql);
    // cnn.close();
  }

  Future<void> deleteData(String table, {String? where})async{
    Database? cnn = await init();
    await cnn!.delete(table,where: where);
  }

  Future<void> updateData(String table,Map<String, dynamic> map, {String? where})async{
    Database? cnn = await init();
    await cnn!.update(table, map,where: where);
  }

  Future<bool> checkExists(String table, String column, String value, {int? nextID}) async{
    Database? cnn = await init();
    String ID = nextID == null ? '' : " AND ID != $nextID";//Nếu bỏ qua ID đó thì k cần tìm
    List data = await cnn!.query(table,where: "$column = '$value' $ID");
    return data.isEmpty ? false : true;  //false: không tồn tại || true: có tồn tại
  }

  Future<dynamic> getCell(String column, String table, String where) async{
    Database? cnn = await init();
    var data = await cnn!.query(table,where: where,columns: [column]);
    return data.isNotEmpty ? data.first[column] : null;
  }

  Future<int> dCount(String TableName,{String Condition=''}) async{
    Database? cnn = await init();
    final x;
    if (Condition=='') {
      x = await cnn!.rawQuery('SELECT COUNT(*) FROM $TableName');
    } else {
      x = await cnn!.rawQuery('SELECT COUNT(*) FROM $TableName WHERE $Condition');
    }
    // db.close();
    return x[0]['COUNT(*)'];
  }
}
