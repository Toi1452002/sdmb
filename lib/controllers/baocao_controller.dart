import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/models/baocaotong_model.dart';

class BaoCaoController extends GetxController with ConnectDB{
  BaoCaoController get to => Get.find();

  final Rx<DateTimeRange> _ngay = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;
  DateTimeRange get ngay => _ngay.value;
  String get strNgay => "${DateFormat('dd/MM/yyyy').format(_ngay.value.start)} - ${DateFormat('dd/MM/yyyy').format(_ngay.value.end)}";
  set ngay(DateTimeRange date) {
    _ngay.value = date;
    onLoadBaoCao();
  }

  final RxList<BaoCaoTongModel> _lstBaoCaoTong = <BaoCaoTongModel>[].obs;
  List<BaoCaoTongModel> _lstBaoCaoCopy = [];
  List<BaoCaoTongModel>  get lstBaoCaoTong => _lstBaoCaoTong.value;

  Rx<BaoCaoTongModel> tongTien = BaoCaoTongModel().obs;

  final RxList<String> _lstMaKhach = <String>[].obs;
  List<String> get lstMaKhach => _lstMaKhach.value;

  final RxString _selectMaKhach = "".obs;
  String get selectMaKhach => _selectMaKhach.value;
  set selectMaKhach(String value){
    _selectMaKhach.value = value;
    if(value == "Tất cả"){
      _onFilterData(_lstBaoCaoCopy);
    }else{
      List<BaoCaoTongModel> tmp = _lstBaoCaoCopy.where((e) => e.MaKhach == value).toList();
      _onFilterData(tmp);
    }
  }






  @override
  void onInit() {
    // TODO: implement onInit
    onLoadBaoCao();
    super.onInit();
  }



  onLoadBaoCao() async{
    _lstBaoCaoCopy.clear();
    _selectMaKhach.value = "";


    String tuNgay = DateFormat('yyyy-MM-dd').format(_ngay.value.start);
    String denNgay = DateFormat('yyyy-MM-dd').format(_ngay.value.end);
    List data = await getList(sql: BaoCaoTongModel().loadBaoCao(tuNgay,denNgay));

    _lstBaoCaoCopy = data.map((e) => BaoCaoTongModel.fromMap(e)).toList();
    _lstMaKhach.value = _lstBaoCaoCopy.map((e)=>e.MaKhach).toSet().toList();
    _lstMaKhach.insert(0, 'Tất cả');
    _onFilterData(_lstBaoCaoCopy);
    update();

  }


  _onFilterData(List<BaoCaoTongModel> baoCaoTongModel){
    _lstBaoCaoTong.clear();
    _lstBaoCaoTong.clear();
    tongTien.value = BaoCaoTongModel();
    List<String> lstNgay = baoCaoTongModel.map((e) {
      tongTien.value.Xac += e.Xac;
      tongTien.value.Von += e.Von;
      tongTien.value.Thuong += e.Thuong;
      tongTien.value.LaiLo += e.LaiLo;
      tongTien.value.Lo += e.Lo;
      tongTien.value.De += e.De;
      tongTien.value.Xien += e.Xien;
      tongTien.value.bCang += e.bCang;
      tongTien.value.Khac += e.Khac;

      return e.Ngay;
    }).toSet().toList();

    for(String x in lstNgay){
      _lstBaoCaoTong.add(BaoCaoTongModel(ID: -1,Ngay: x));
      _lstBaoCaoTong.addAll(baoCaoTongModel.where((e) => e.Ngay == x).toList());
    }
    update();
  }



  RxList dta = [].obs;
  RxList dta1 = [].obs;
  RxList dta2 = [].obs;
  RxString nameKH = ''.obs;

  onLoadBCCT(String ngay, String MaKH) async{
    dta.value = await  getList(table: 'VBC_TongHop',where: "Ngay = '$ngay' AND MaKhach = '$MaKH'");
    dta1.value = await  getList(table: 'VBC_CT1',where: "Ngay = '$ngay' AND MaKhach = '$MaKH'");
    dta2.value= await  getList(table: 'VBC_CT2',where: "Ngay = '$ngay' AND MaKhach = '$MaKH'");
    nameKH.value = MaKH;

  }

}