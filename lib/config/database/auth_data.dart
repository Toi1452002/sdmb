import 'dart:async';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/config.dart';

import '../path_server.dart';

class AuthData{
  String get login => 'khach-login';
  String get kichHoat => 'khach-kich-hoat';

  final _db = ConnectDB();
  final _server = ConfigServer();
  Future<String> checkLogin(String userName, String passWord) async{
        Map<String, dynamic> maKichHoat = await _db.getRow(
            table: 'TXL_NgayLamViec',
            where:
                "ID = 1");
        return maKichHoat.isNotEmpty ? maKichHoat['MaKichHoat'] : 'empty';
  }

  Future<String> getNgayHetHan() async{
    return await _db.getCell('NgayHetHan', 'TXL_NgayLamViec', 'ID = 1');
  }

  Future<void> updateNgayHetHan(String date) async{
    await _db.updateData('TXL_NgayLamViec',{'NgayHetHan':date});
  }

  Future<void> updateMaKichHoat(String maKichHoat) async{
    await _db.updateData('TXL_NgayLamViec',{'MaKichHoat':maKichHoat});
  }

  Future<Response> xacThuc(String maKichHoat) async{
     return await _server.getData(path: _server.auth, type: login, data: {
      'MaKichHoat': maKichHoat
    });
  }

  int getSoNgayConLai(String date){
    DateTime now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime thoiHan  = DateTime.parse(date);
    return thoiHan.difference(now).inDays;
  }
}

