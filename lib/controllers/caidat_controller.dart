
// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sdmb/config/extension.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/baocao_controller.dart';
import 'package:sdmb/controllers/tinnhan_controller.dart';
import 'package:sdmb/widgets/wgt_loading.dart';

import '../config/database/connectDB.dart';
import '../config/database/connect_dbw.dart';
import '../config/info_app.dart';


class CaiDatController extends GetxController with ConnectDB{

  CaiDatController get to => Get.find();
  ConnectDBW dbw = ConnectDBW();

  RxBool kieSoBo = false.obs;
  RxBool xienQuay = false.obs;
  RxBool tachXienQuay = false.obs;
  RxBool tachThongCua = false.obs;
  RxString xienNhay = '0'.obs;
  final txtHeSoXien = TextEditingController();
  final txtHeSoXienQuay = TextEditingController();

  final txtTaiKhoan = TextEditingController(); RxString errTaiKhoan = "".obs;
  final txtMatKhau = TextEditingController(); RxString errMatKhau = "".obs;
  final txtXacNhanMatKhau = TextEditingController();RxString errXacNhanMatKhau = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    onLoadData();
    super.onInit();
  }

  void onLoadData() async{
    List<Map<String, dynamic>> data = await getList(table: 'T00_TuyChon');
    if(data.isNotEmpty){
      kieSoBo.value = data.where((e) => e['Ma'] == 'bo').first['GiaTri'].toString().toBool;
      xienQuay.value = data.where((e) => e['Ma'] == 'xq').first['GiaTri'].toString().toBool;
      tachXienQuay.value = data.where((e) => e['Ma'] == 'txq').first['GiaTri'].toString().toBool;
      tachThongCua.value = data.where((e) => e['Ma'] == 'ttc').first['GiaTri'].toString().toBool;
      txtHeSoXien.text = data.where((e) => e['Ma'] == 'xxien').first['GiaTri'].toString();
      txtHeSoXienQuay.text = data.where((e) => e['Ma'] == 'xxq').first['GiaTri'].toString();
      xienNhay.value = data.where((e) => e['Ma'] == 'xn').first['GiaTri'].toString();
    }



  }

  onLoadTaiKhoan() async{
    Map<String, dynamic> user = await getRow(
        table: 'T00_User',
        where: "UserName != 'pmn'"
    );
    if(user.isNotEmpty){
      txtTaiKhoan.text = user['UserName'];
    }
  }
  void onUpdateData({String? column,dynamic value,String? where, String? table}) async{
    await updateData(table  ??  'T00_TuyChon', {
         column  ?? 'GiaTri' : value
    },where: where);
  }


  void onChangeTaikhoan(BuildContext context) async{
    if(validateTaiKhoan(txtTaiKhoan.text) != ""){
      errTaiKhoan.value = validateTaiKhoan(txtTaiKhoan.text);
      return;
    }
    if(txtMatKhau.text.isEmpty){
      errMatKhau.value = 'Mật khẩu trống!';
      return;
    }
    if(txtXacNhanMatKhau.text != txtMatKhau.text){
      errXacNhanMatKhau.value = 'Mật khẩu không khớp!';
      return;
    }

    await updateData('T00_User', {
      'UserName': txtTaiKhoan.text,
      'PassWord': txtXacNhanMatKhau.text
    },where: "UserName != 'pmn'").whenComplete((){
      Get.back();
      FlashToast(context).showSuccess('Đổi mật khẩu thành công');
    });

  }

  onDeleteAllTin(BuildContext  context) async{
    try{
      await deleteData('TXL_TinNhan');
      await deleteData('TXL_TinNhanCT');
      await deleteData('TXL_TinPhanTichCT').whenComplete(() {
        Get.back();
        FlashToast(context).showSuccess('Xóa thành công');
      });
      TinNhanContoller().to.onLoadData();
      BaoCaoController().to.onLoadBaoCao();
    }catch(e){
      FlashToast(context).showError('Xóa thất bại');
      throw Exception(e);
    }


  }

  onCapNhat(BuildContext context) async {
    if (!await hasNetwork()) {
      FlashToast(context).showInfo('Không có mạng');
      return;
    }

    var status = await Permission.manageExternalStorage.status;
    if(status.isDenied){
      await Permission.manageExternalStorage.request();
      // return;
    }
    try{
      Map<String, dynamic> data = await dbw.loadRow(tblName: 'PHANMEM', condition: "MaSP = '$MASP'");
      if(data.isNotEmpty &&  data['Version']!=APP_VERSION){
        FlashToast(context).showAlert('Cập nhật', 'Đã có phiên bản ${data['Version']}', () {
          downloadFile("http://rgb.com.vn/flutterApp", data['FileName'], '/storage/emulated/0/Download',context);
        });
        // Wgt_Dialog(title: 'Cập nhật, text: 'Đã có phiên bản ${data['Version']}', onConfirm: (){
        // downloadFile("http://rgb.'com.vn/flutterApp", data['FileName'], '/storage/emulated/0/Download');
        // });
      }else{
        // EasyLoading.showToast('Không có bản cập nhật nào');
        FlashToast(context).showInfo('Không có bản cập nhật nào');
      }
    }catch(e){
      FlashToast(context).showInfo('Lỗi mở file $e');
    }

  }

  Future<void> downloadFile(String url, String fileName, String dir,BuildContext  context) async {
    Get.back();
    // EasyLoading.show(status: 'Đang cập nhật',dismissOnTap: false);
    showLoading();
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    try {
      myUrl = '$url/$fileName';
      // print(myUrl);
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var status = await Permission.storage.isDenied;
      if(status){
        await Permission.storage.request();
      }
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        await OpenFilex.open(filePath);
      }
      else {
        // EasyLoading.showInfo('Không tìm thấy ứng dụng!');
        FlashToast(context).showError('Không tìm thấy ứng dụng!');
      }
    }
    catch(ex){
      // EasyLoading.showInfo('Lỗi tải file $ex!');
      FlashToast(context).showError('Lỗi tải file $ex!');
    }
    // EasyLoading.dismiss();
    closeLoading();
  }


  void onClearText() {
    txtMatKhau.clear();
    txtXacNhanMatKhau.clear();
    errTaiKhoan.value = "";
    errMatKhau.value = "";
    errXacNhanMatKhau.value = "";
  }
}

extension ValidateDoiTaiKhoan on CaiDatController{
  String validateTaiKhoan(String txtTaiKhoan){
    String result = "";
    if(txtTaiKhoan.isEmpty) result = "Tài khoản trống!";
    if(txtTaiKhoan  == "pmn") result = "Không thể là 'pmn'!";
    return result;
  }

}