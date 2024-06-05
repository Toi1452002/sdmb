// import 'dart:io';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// class ConnectDb {
//   static String path = "E:/PMN_SD/Data/DataSDN.db";
//   Future<Database?> init() async {
//     try{
//       if(await File(path).exists()){
//         var db = await databaseFactory.openDatabase(path);
//         return db;
//       }else{
//         print("Database không tồn tại");
//       }
//     }catch(e){
//       print("Lỗi kết nối: $e");
//     }
//
//   }
//
//
// }
