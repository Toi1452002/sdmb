
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/functions/md_laykqxs.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/models/kqxs_model.dart';

import '../config/database/auth_data.dart';
import '../config/database/connect_dbw.dart';
import '../config/extension.dart';
import '../config/info_app.dart';
import '../models/info_user.dart';


class KqxsController extends GetxController{
  ConnectDB db = ConnectDB();
  ConnectDBW dbw = ConnectDBW();

  KqxsController get to => Get.find();

  final Rx<DateTime> _ngay = DateTime.now().obs;
  String get txtNgay => DateFormat('dd/MM/yyyy').format(_ngay.value);
  DateTime get ngay => _ngay.value;
  set ngay(DateTime date){
    _ngay.value = date;
    onLoadKqxs(date);
  }

  final RxList<KqxsModel> _lstKqxs = <KqxsModel>[].obs;
  List<KqxsModel> get lstKqxs=> _lstKqxs.value;


  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _kqxsMN = false.obs;
  bool get kqxsMN => _kqxsMN.value;
  set kqxsMN(bool value){
    _kqxsMN.value = value;
    GetStorage().write('kqxsMN', value);
  }

  ///=====================================================
  @override
  void onInit() {
    // TODO: implement onInit
    onLoadKqxs(_ngay.value);
    kqxsMN = GetStorage().read('kqxsMN')??false;
    super.onInit();
  }


  Future<void> onLoadKqxs(DateTime ngay) async{
    _isLoading.value = true;
    final iUser = infoUser.value;
    final auth = AuthData();
    if(!await hasNetwork()){
      Get.snackbar('Thông báo', 'Không có mạng',backgroundColor: Colors.black.withOpacity(.7),colorText: Colors.white);
      String ngayHH = await auth.getNgayHetHan();
      infoUser.value.soNgayCon = auth.getSoNgayConLai(ngayHH);
      return;
    }else{
      try{
        final rps = await auth.xacThuc(iUser.maKichHoat);
        if(rps.statusCode == 200){
          final data = jsonDecode(rps.data);
          if(data!=false){
            print(data);
            await auth.updateNgayHetHan(data['NgayHetHan']);

            infoUser.value = InfoUser(
                maHD: int.parse(data['ID']),
                ngayHetHan: data['NgayHetHan'],
                soNgayCon: auth.getSoNgayConLai(data['NgayHetHan']),
                maKichHoat: iUser.maKichHoat,
                userName: iUser.userName
            );
          }
        }
      }catch(e){
        throw Exception(e);
      }
    }
    ///


    //Lấy dữ liệu trong data

    List data = await db.getList(table: 'TXL_KQXS',where: "Ngay = '${DateFormat('yyyy-MM-dd').format(ngay)}'");
    if(data.isNotEmpty){//Có dữ liệu
      List lstGiai = data.map((e) => e['MaGiai']).toSet().toList();
      List<Map<String, dynamic>> kqGiai = [];
      for(String i in lstGiai){
        List a = data.where((e) => e['MaGiai'] == i).toList();
        List b = a.map((e) => e['KQso']).toList();
        String txt_b = "";
        if(b.length==6){
          txt_b = "${b.sublist(0,3).join('-')}\n${b.sublist(3).join('-')}";
        }else{
          txt_b = b.join('-');
        }
        kqGiai.add({
          'MaGiai': i,
          'KQso': txt_b
        });
      }
      _lstKqxs.value = kqGiai.map((e) => KqxsModel.fromMap(e)).toList();
      _isLoading.value = false;

    }else{//Không có dữ liệu thì lấy kqxs trên web
      _lstKqxs.clear();
      Map<String, dynamic> data =  await layKQXS(ngay,xsmn: GetStorage().read('kqxsMN')??false);
      List kqSo = data['KQso'];
      if(data['Ngay'] != DateFormat('yyyy-MM-dd').format(ngay) || kqSo.length!=27){
        _isLoading.value = false;
      }else{
        int tt = 0;
        List<KqxsModel> lstInsert = [];
        for(int i = 0; i<kqSo.length;i++){
          tt++;
          lstInsert.add(KqxsModel(
            TT: tt,
            Ngay: data['Ngay'],
            MaGiai: giaiMB(tt),
            KQso: kqSo[i].toString()
          ));
        }
        if(await db.dCount('TXL_KQXS',Condition: "Ngay = '${data['Ngay']}'") == 0){
          await db.insertList(
              lstData: lstInsert.map((e) => e.toMap()).toList(),
              tbName: 'TXL_KQXS',
              fieldToString: 'KQso').whenComplete(() {
            onLoadKqxs(ngay);
          });
        }


      }
      // throw Exception('No data');
    }
  }
  
  onDeleteKQXS(BuildContext  context)async{
    await db.deleteData('TXL_KQXS').whenComplete((){
      _lstKqxs.clear();
      Get.back();
      Get.back();
      FlashToast(context).showSuccess('Xóa thành công');
    });
  }



}