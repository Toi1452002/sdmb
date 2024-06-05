import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/models/tinnhan_model.dart';

class TinNhanContoller extends GetxController with ConnectDB{
  TinNhanContoller get to => Get.find();

  final RxList<TinNhanModel> _lstTinNhan = <TinNhanModel>[].obs;
  List<TinNhanModel> get lstTinNhan => _lstTinNhan.value;

  List<TinNhanModel> lstTinNhanCopy = [];

  final Rx<DateTime> _ngayLam = DateTime.now().obs;
  DateTime get ngayLam => _ngayLam.value;
  String get strNgayLam => DateFormat('dd/MM/yyyy').format(_ngayLam.value);

  set ngayLam(DateTime date){
    _ngayLam.value = date;
    onLoadData();
  }

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _strFilter = ''.obs;
  String get strFilter => _strFilter.value;
  set strFilter(String value){
    _strFilter.value = value;
    if(value!='Tất cả'){
      _lstTinNhan.value = lstTinNhanCopy.where((e) => e.MaKhach == value).toList();
    }else{
      _lstTinNhan.value = lstTinNhanCopy;
    }

  }

  RxList<String> lstMaKhach = <String>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    onLoadData();
    super.onInit();
  }


  void onLoadData() async{
    _isLoading.value = true;// Loading....
    _strFilter.value = '';// load lại thì cho combobox về rỗng

    String fmNgay = DateFormat('yyyy-MM-dd').format(_ngayLam.value); // Định dạng ngày để tìm trong data
    List data = await getList(sql: TinNhanModel().sqlLoadTin(fmNgay));
    if(data.isNotEmpty){
      _lstTinNhan.value = data.map((e) => TinNhanModel.fromMap(e)).toList();
       lstMaKhach.value = _lstTinNhan.map((e) => e.MaKhach).toSet().toList();
       lstTinNhanCopy = _lstTinNhan.value;// Giữ lại 1 copy của tin nhắn để lọc
       lstMaKhach.value.insert(0, 'Tất cả'); // Thêm 'Tất cả' vào combobox
      _isLoading.value = false;
    }else{
      _lstTinNhan.clear();
      lstMaKhach.clear();
      _isLoading.value = false;
    }
  }
  
   
  onDeleteData(BuildContext context, TinNhanModel tinNhan) async{
    await deleteData('TXL_TinNhan',where: 'ID = ${tinNhan.ID}').whenComplete(() {
      Get.back();
      _lstTinNhan.remove(tinNhan);
      FlashToast(context).showSuccess('Xóa thành công');
    });
    await deleteData('TXL_TinNhanCT',where: 'TinNhanID = ${tinNhan.ID}');
    await deleteData('TXL_TinPhanTichCT',where: 'MaTin = ${tinNhan.ID}');



  }





}