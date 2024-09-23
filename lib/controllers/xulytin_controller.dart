// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sdmb/config/functions/md_PhanTich.dart';
import 'package:sdmb/config/functions/md_xulytin.dart';
import 'package:sdmb/controllers/kqxs_controller.dart';
import '../config/config.dart';
import '../config/functions/md_KiemLoi.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';


class XuLyTinController extends GetxController with ConnectDB{
  XuLyTinController get to => Get.find();

  final Rx<TextEditingController> _txtTinXL = ErrorController().obs;
  TextEditingController get txtTinXL => _txtTinXL.value;

  final RxString _txtErr = "".obs;
  String get txtErr => _txtErr.value;

  final RxBool _enableTinXL = false.obs;
  bool get enableTinXL => _enableTinXL.value;
  set enableTinXL(bool value)=> _enableTinXL.value = value;

  RxList<String> lstMaKhach = <String>[].obs;

  final RxString _strMaKhach = "".obs;
  String get strMaKhach => _strMaKhach.value;

  final RxBool _enableTinhToan = false.obs;
  bool get enableTinhToan => _enableTinhToan.value;

  int? _newIDTinNhan;
  Rx<int?> get newIDTinNhan => _newIDTinNhan.obs;

  RxString strDiem = '0'.obs;
  RxString strTien = '0'.obs;
  RxString strThuong= '0'.obs;
  RxString strLaiLo = '0'.obs;

  set strMaKhach(String value){
    if(_strMaKhach.value == '' && value!=''){//Insert tin mới
      _strMaKhach.value = value;
      _enableTinXL.value = true;// Sau khi chọn khách mới có thể nhập tin
      onInsertData();// Sau khi chọn khách thì mới thêm tin

    }else if(_strMaKhach.value != '' && value!=''){//update tin
      _strMaKhach.value = value;
      onUpdateCell('KhachID', 'TXL_TinNhan', 'ID = $_newIDTinNhan', value);
    }
  }


  final Rx<DateTime> _ngayLam = DateTime.now().obs;
  DateTime get ngayLam => _ngayLam.value;
  String get strNgayLam => DateFormat('dd/MM/yyyy').format(_ngayLam.value);
  set ngayLam(DateTime value){
    _ngayLam.value = value;
    onUpdateCell('Ngay', 'TXL_TinNhan', 'ID = $_newIDTinNhan', value);
    GetStorage().write('ngayXuLy', DateFormat('yyyy-MM-dd').format(value));
  }


  @override
  void onInit() {
    // TODO: implement onInit
    onLoadData();
    super.onInit();
  }




  onKiemLoi(BuildContext context)async{
    if(infoUser.value.soNgayCon<1) {FlashToast(context).showInfo('App đã hết hạn');return;}
    if(txtTinXL.text.isEmpty){FlashToast(context).showInfo('Chưa có tin');return;}

    try{
      showLoading();
      String tinXL = await xuly(txtTinXL.text);
      txtTinXL.text = tinXL.replaceAll('.', ' ');
      if(await KiemLoiTin(tinXL.replaceAll(' ', '.'))){
        List<String> lstTin = tinXL.split('.');
        int i = 0;
        for(String x in lstTin){
          if(gl_lst_ViTriLoi.contains(i)){
            lstTin[i] = ' $x';
          }
          i+=1;
        }
        tinXL = lstTin.join('.');
        _txtErr.value = gl_sLoiTin;
      }else{
        _txtErr.value = '';
        _enableTinhToan.value = true;
      }
      closeLoading();
      _txtTinXL.value.text = tinXL.replaceAll('.', ' ');
      await  updateData('TXL_TinNhanCT',
          {'TinXL': tinXL},where: "TinNhanID = $_newIDTinNhan");
    }
    catch(e){
      closeLoading();
      FlashToast(context).showError('Error!!!');
      throw e.toString();
    }

  }

  onTinhToan(BuildContext context)async{
    _enableTinhToan.value = false;
    showLoading();
    try{
      final completer = Completer();
      String chuyentin =await  ChuyenTin(_txtTinXL.value.text.replaceAll(' ', '.'));
      int IDTinNhanCT = await getCell('ID', 'TXL_TinNhanCT', "TinNhanID = $_newIDTinNhan");

      List kqxs = await getList(table: 'TXL_KQXS',where: "Ngay = '${DateFormat('yyyy-MM-dd').format(_ngayLam.value)}'");
      if(kqxs.isEmpty){
        Get.lazyPut(() => KqxsController());
        await KqxsController().to.onLoadKqxs(_ngayLam.value);
        kqxs = await getList(table: 'TXL_KQXS',where: "Ngay = '${DateFormat('yyyy-MM-dd').format(_ngayLam.value)}'");
      }
      List<TinPhanTichCTModel> data =  await PhanTichChuoiTin(chuyentin,ID_Tin: _newIDTinNhan!,ID_TinCT: IDTinNhanCT).whenComplete(() {
        strDiem.value = fxac.toString().formatDouble;
        strTien.value = fvon.toString().formatDouble;
        strThuong.value = ftrung.toString().formatDouble;
        strLaiLo.value = NumberFormat('#,##0').format(fvon - ftrung);
        completer.complete();
      });


      /** Xóa TinPTCT cũ **/
      await deleteData( 'TXL_TinPhanTichCT', where: "TinNhanCTID = '$IDTinNhanCT'");

      if(completer.isCompleted){
        await insertList(lstData: data.map((e) => e.toMap()).toList(),fieldToString: 'SoDanh', tbName: 'TXL_TinPhanTichCT').whenComplete(() {
          closeLoading();
        }).catchError((e){
          FlashToast(context).showError('Lỗi tính toán');
        });
      }

      if(kqxs.isEmpty){
        FlashToast(context).showInfo('Chưa có kết quả xổ số');
      }
    }catch(e){
      closeLoading();
      FlashToast(context).showError('Lỗi tính toán');

      throw Exception(e);
    }




  }




  ///Thay đổi textfield
  onUpdateTin(String value) async {
    _txtErr.value = '';
    _enableTinhToan.value = false;
    await  updateData('TXL_TinNhanCT',
        {'TinXL': value},where: "TinNhanID = $_newIDTinNhan");
  }



  onLoadData()  async{
    List data = await getList(sql: 'SELECT MaKhach FROM TDM_Khach');
    if(data.isNotEmpty){
      lstMaKhach.value = data.map((e) => e['MaKhach'].toString()).toList();
    }
    ///Load ngay lam
    if(_newIDTinNhan == null){
      _ngayLam.value = GetStorage().read('ngayXuLy') == null ? DateTime.now() : DateTime.parse(GetStorage().read('ngayXuLy'));
    }
  }

  onEditTin(TinNhanModel tinNhanModel)async{
    _strMaKhach.value = tinNhanModel.MaKhach;
    txtTinXL.text = tinNhanModel.TinXL.replaceAll('.', ' ');

    _ngayLam.value = DateTime.parse(tinNhanModel.Ngay);
    _enableTinXL.value = true;
    _newIDTinNhan = tinNhanModel.ID;

    var data = await getRow(table: 'VBC_TongHop',where: 'ID = ${tinNhanModel.ID}');
    strDiem.value = (data['Xac']??0).toString().formatDouble;
    strTien.value = (data['Von']??0).toString().formatDouble;
    strThuong.value =(data['Thuong']??0).toString().formatDouble;
    strLaiLo.value = (data['LaiLo']??0).toString().formatDouble;

  }

  void onInsertData() async{
    DateTime ngayXuLy = GetStorage().read('ngayXuLy') == null ? DateTime.now() : DateTime.parse(GetStorage().read('ngayXuLy'));
    int idKhach = await getCell('ID', 'TDM_Khach', "MaKhach = '${_strMaKhach.value}'");
    int idTinnhan =  await insertMap({
      'Ngay': DateFormat('yyyy-MM-dd').format(ngayXuLy),
      'KhachID': idKhach
    }, 'TXL_TinNhan');
    if(idTinnhan>0){
      _newIDTinNhan = idTinnhan;
      await insertMap({
        'TinNhanID': idTinnhan
      }, 'TXL_TinNhanCT');
    }
  }



  onUpdateCell(String column, String table, String where, dynamic value) async{
    if(column == 'KhachID') value = await getCell('ID', 'TDM_Khach', "MaKhach = '$value'");
    if(column == 'Ngay')  value = DateFormat('yyyy-MM-dd').format(value);
    await updateData(table, {
      column : value
    },where: where);
  }


  final RxList<XemChiTietModel> _lstXemChiTiet = <XemChiTietModel>[].obs;
  final RxList<String> _lstKieu = <String>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _strKieu = "Tất cả".obs;

  List<XemChiTietModel> lstXemChiTietCopy = [];
  List<XemChiTietModel> get lstXemChiTiet => _lstXemChiTiet.value;
  List<String> get lstKieu => _lstKieu.value;
  bool get isLoading => _isLoading.value;
  String get strKieu => _strKieu.value;

  set strKieu(String value){
    _strKieu.value = value;
    if(value != 'Tất cả'){
      List<XemChiTietModel> filter = lstXemChiTietCopy.where((e) => e.MaKieu == value).toList();
      _lstXemChiTiet.value = filter;
      List data = filter.map((e) =>e.toMap()).toList();
      _lstXemChiTiet.insert(0, tinhTongXemCT(data));
    }else{
      _lstXemChiTiet.value = lstXemChiTietCopy;
    }
  }


  clearXemCT() {
    _lstXemChiTiet.value.clear();
    _lstKieu.value.clear();
    lstXemChiTietCopy.clear();
    _strKieu.value = 'Tất cả';
  }

  onXemChiTiet() async{
    _isLoading.value = true;

    List data = await getList(table: 'VBC_ptChiTiet',where: 'ID = $newIDTinNhan ' );
    Future.delayed(const Duration(seconds: 1),(){
      _lstXemChiTiet.value = data.map((e) {
        return XemChiTietModel.fromMap(e);
      }).toList();
      _lstXemChiTiet.value.insert(0, tinhTongXemCT(data));
      lstXemChiTietCopy = _lstXemChiTiet.value;
      _lstKieu.value = _lstXemChiTiet.map((e) =>  e.MaKieu).toSet().toList();
      _lstKieu.value.removeWhere((e) => e=='');

      _lstKieu.value.insert(0, 'Tất cả');
      _isLoading.value = false;
    });
  }

  final RxInt _soTin = 0.obs; int get soTin => _soTin.value;
  final RxList<Map<String, dynamic>> _lstSMS = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get lstSMS => _lstSMS.value;

  final RxString _typeSMS = 'All'.obs;
  String get typeSMS => _typeSMS.value;
  changeTypeSMS(String value, BuildContext context){
    _typeSMS.value = value;
    getAllMessages(context);
  }
  // set typeSMS(String value)  {
  //
  //
  // }

  Future getAllMessages(BuildContext context) async {
    showLoading();
    // EasyLoading.show(status: 'Loading...',dismissOnTap: false,maskType: EasyLoadingMaskType.black);
    var status = await Permission.sms.status;
    SmsQuery query = SmsQuery();
    try{
      if(status.isGranted){
        _enableTinhToan.value= false;
        _lstSelectSMS.clear();
        String sdt = await getCell('SDT', 'TDM_Khach', "MaKhach = '${_strMaKhach.value}'");
        if(sdt==''){
          // EasyLoading.showInfo('Không có SDT');
          FlashToast(context).showInfo('Không có SDT');
          closeLoading();

          return;
        }
        if(sdt.length>8){
          sdt  = "+84${sdt.lastChars(9)}";
        }else{
          FlashToast(context).showInfo('SDT không hợp lệ');
          closeLoading();

          // EasyLoading.showInfo('SDT không hợp lệ');
          return;
        }
        List<SmsMessage> messages = await query.querySms(
            address: sdt,
            kinds: [SmsQueryKind.inbox,SmsQueryKind.sent]
        );
        if(messages.isEmpty){
          messages = await query.getAllSms;
          messages = messages.where((e) =>e.address!.length>8  && e.address!.lastChars(9) == sdt.lastChars(9)).toList();
        }

        messages = messages.where((e) => DateFormat('dd/MM/yyyy').format(_ngayLam.value) == DateFormat('dd/MM/yyyy').format(e.date!)).toList();
        messages.sort((a,b)=>a.id!.compareTo(b.id!));
        List<SmsMessage> messLast = [];
        switch(_typeSMS.value){
          case 'All':
            messLast = messages;
            break;
          case 'Nhận':
            messLast = messages.where((e) => e.kind == SmsMessageKind.received).toList();
            break;
          case 'Gửi':
            messLast = messages.where((e) => e.kind == SmsMessageKind.sent).toList();
            break;
        }
        // for(var x in messages){
        //   print(x.kind == SmsMessageKind.sent);
        // }
        _soTin.value = messLast.length;
        _lstSMS.value = messLast.map((e) => {
          'ID': e.id,
          'Tin':e.body.toString(),
          'Date': DateFormat('dd/MM/yyyy HH:mm:ss').format(e.date!),
        }).toList();
        closeLoading();
      }else{

        print('=================================');
        await Permission.sms.request();
        closeLoading();
      }



    }catch(e){
      closeLoading();

      FlashToast(context).showInfo('Không lấy được tin sms');

      // EasyLoading.showInfo('Không lấy được tin sms');
    }



  }

  final RxList<Map<String, dynamic>> _lstSelectSMS = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get lstSelectSMS => _lstSelectSMS.value;
  onChonSMS(Map<String, dynamic> map,bool value){
    if(value){
      _lstSelectSMS.add(map);
    }else{
      _lstSelectSMS.remove(map);
    }
    // print(_lstSelectSMS.value);
  }

  onChapNhanSMS(BuildContext context){
    _lstSelectSMS.value.sort((a,b)=>a['ID'].compareTo(b['ID']));
    if(_lstSelectSMS.value.isEmpty){
      // EasyLoading.showInfo('Không có tin');
      FlashToast(context).showInfo('Không có tin');
      return;
    }
    String tin = _lstSelectSMS.value.map((e) => e['Tin']).toList().join('\n');
    _txtTinXL.value.text = tin;
    _txtErr.value = '';
    Get.back();
  }

  XemChiTietModel tinhTongXemCT(List data){
    double tongXac = 0; double tongTien = 0; double tongDiem = 0; double tongThuong = 0;
    for(var x in data){
      tongXac += x['Xac'];
      tongTien += x['Von'];
      tongDiem += x['Diem'];
      tongThuong += x['Thuong'];
    }
    return XemChiTietModel(
        Xac: tongXac,
        Von: tongTien,
        Diem: tongDiem,
        Thuong: tongThuong
    );

  }
}

