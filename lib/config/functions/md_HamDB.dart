// // import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//
// import 'package:sdmb/config/database/connectDB.dart';
// import 'package:sqflite/sqflite.dart';
//
//
// ketNoi() async{
//   ConnectDB cnn = ConnectDB();
//   Database? db = await cnn.init();
//   if(db!= null && db.isOpen){
//     return db;
//   }
// }
//
// dLookup(String FieldName,String TableName,String Condition) async{
//   var db=await ketNoi();
//   List<Map> x = await db.rawQuery("SELECT $FieldName FROM $TableName WHERE $Condition");
//   db.close();
//   return x[0]['$FieldName'];
// }
//
// dLast(String FieldName,String TableName) async{
//   var db=await ketNoi();
//   List<Map> x = await db.rawQuery("SELECT $FieldName FROM $TableName");
//   db.close();
//   return x[x.length-1]['$FieldName'];
// }
//
// dCount(String TableName,{String Condition=''}) async{
//   var db=await ketNoi();
//   final x;
//   if (Condition=='') {
//     x = await db.rawQuery('SELECT COUNT(*) FROM $TableName');
//   } else {
//     x = await db.rawQuery('SELECT COUNT(*) FROM $TableName WHERE $Condition');
//   }
//   db.close();
//   return x[0]['COUNT(*)'];
// }
//
// layTable(String sql)async{
//   var db=await ketNoi();
//   List<Map> x = await db.rawQuery(sql);
//   db.close();
//   return x;
// }
// /////
//
import '../database/connectDB.dart';

Future<String> ThayCumTu(String sText) async{//thay cụm từ trong table T01_TuKhoa
  // List<Map> ltbTuKhoa=await layTable("SELECT CumTu, ThayThe FROM T01_TuKhoa WHERE SoDanhHang=0");

  List<Map> ltbTuKhoa = await ConnectDB().getList(sql:"SELECT CumTu, ThayThe FROM T01_TuKhoa WHERE SoDanhHang=0" );
  for (int i=0;i<ltbTuKhoa.length;i++){
    if (ltbTuKhoa[i]['ThayThe']=='') sText=sText.replaceAll(ltbTuKhoa[i]['CumTu'].toString(), '');
    else sText=sText.replaceAll(ltbTuKhoa[i]['CumTu'].toString(),ltbTuKhoa[i]['ThayThe']==null?'':ltbTuKhoa[i]['ThayThe'].toString());
  }
  sText = sText.replaceAll(' ', '');
  return sText;
}

String thayTuKhoa(String s) {
  Map<String, String> tukhoa = {
    '.': ' ', '  ': ' ', ' ': ' ',
    '\n': ' ', '\r':' ',

  };

  for (String x in tukhoa.keys) {
    if (s.contains(x)) s = s.replaceAll(x, tukhoa[x].toString());
  }
  return s;
}