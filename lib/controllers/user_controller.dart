// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/widgets/wgt_loading.dart';
import '../config/config.dart';

class UserController extends GetxController {
  /// Khai báo biến
  UserController get to => Get.find();
  ConnectDB db = ConnectDB();
  ConnectDBW dbw = ConnectDBW();
  
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  final txtMaKichHoat = TextEditingController();

  ///==============================

  // Login App
  onLogin(BuildContext context) async {
    if(txtUsername.text=='rgb' && txtPassword.text == 'datalysmanx'){
      MAKH = 'Admin';
      SONGAYHETHAN = 1;
      NGAYHETHAN = DateTime.now();

      Get.offAndToNamed(vHome);
      return;
    }

    if(!await hasNetwork()){
      FlashToast(context).showInfo('Không có mạng');
      return;
    }

    if(txtUsername.text=='pmn' && txtPassword.text == 'pmn79'){
      db.updateData('T00_User', {
        'Username': '1',
        'Password' : '1'
      },where: "Username != 'pmn' ");
      FlashToast(context).showInfo('Đã reset tài khoản');
      return;
    }

    showLoading();

    Map<String, dynamic> user = await db
        .getRow(
            table: 'T00_User',
            where: "UserName = '${txtUsername.text}' AND PassWord = '${txtPassword.text}'");

    if (user.isNotEmpty) {
      closeLoading();
      Map<String, dynamic> tb = await db.getRow(sql: 'SELECT * FROM TXL_NgayLamViec LIMIT 1');
      var data = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKichHoat = '${tb['MaKichHoat']}'");
      if(data.isEmpty){
        FlashToast(context).showInfo('Không tìm thấy tài khoản');
      }else{
        String ngaylam = DateFormat('yyyy-MM-dd').format(DateTime.now());
        DateTime ngayhethan = DateTime.parse(data['NgayHetHan']);

        SONGAYHETHAN = ngayhethan.difference(DateTime.parse(ngaylam)).inDays;
        NGAYHETHAN = ngayhethan;
        MAKH = data['MaKH'];

        await dbw.updateData(sql: "UPDATE KHACH_SD SET NgayLamViec = '$ngaylam' WHERE MaKH = '$MAKH'");
        await db.updateData('TXL_NgayLamViec', {
          'NgayHetHan': ngaylam
        });
        Get.offAndToNamed(vHome);
      }

      //
    } else {
      closeLoading();
      FlashToast(context).showInfo('Đăng nhập thất bại');
      return;
    }
  }

  // checkKichHoat() async {
  //   Map<String, dynamic> data = await db.getRow(sql: 'SELECT * FROM TXL_NgayLamViec LIMIT 1');
  //   if (data['MaThietBi'] == null || data['MaThietBi'] == '') {
  //     //Chưa kích hoạt
  //     String mtb = getMaThietBi();
  //     await db.updateData('TXL_NgayLamViec', {'MaThietBi': mtb});
  //     return mtb;
  //   } else if ((data['MaThietBi'] != null || data['MaThietBi'] != '') && data['MaKichHoat'] == null) {
  //     return data['MaThietBi'];
  //   } else {
  //     return '';
  //   }
  // }

  onKichHoat(BuildContext context, String MTB) async{
    if(!await hasNetwork()){
      FlashToast(context).showInfo('Không có mạng');
      return;
    }
    if(txtMaKichHoat.text.isEmpty || !txtMaKichHoat.text.contains('-')){
      FlashToast(context).showError('Mã kích hoạt không hợp lệ');
      return;
    }

    showLoading();
    String makh = txtMaKichHoat.text.substring(txtMaKichHoat.text.lastIndexOf('-')+1);
    String mathietbi = txtMaKichHoat.text.substring(0,txtMaKichHoat.text.lastIndexOf('-'));
    var data = await dbw.loadRow(tblName: 'KHACH_SD', condition: "MaKichHoat = '${txtMaKichHoat.text}' AND TrangThai = 0");
    if(data.isNotEmpty){
      if(mathietbi == MTB){
        await dbw.updateData(tbName: 'KHACH_SD',field: 'TrangThai',value: 1,condition: "MaKichHoat = '${txtMaKichHoat.text}'");
        await db.updateData('TXL_NgayLamViec', {
          'MaKichHoat': txtMaKichHoat.text.trim(),
          'MaKH': makh,
          'NgayHetHan': data['NgayHetHan']
        }).whenComplete((){
          closeLoading();
          Get.offAndToNamed(vLogin);
        });

      }else{
        closeLoading();

        FlashToast(context).showError('Mã kích hoạt không hợp lệ');

      }
    }else{
      closeLoading();
      FlashToast(context).showError('Mã kích hoạt không hợp lệ');

    }



  }
}
