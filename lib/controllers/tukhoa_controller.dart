import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/models/tukhoa_model.dart';

class TuKhoaController extends GetxController{
  TuKhoaController get to => Get.find();
  ConnectDB db = ConnectDB();

  final RxList<TuKhoaModel> _lstTuKhoa = <TuKhoaModel>[].obs;
  List<TuKhoaModel> get lstTuKhoa => _lstTuKhoa.value;

  final txtTuKhoa = TextEditingController();
  final txtThayThe = TextEditingController();

  final RxString _errTuKhoa = ''.obs;
  String get errTuKhoa => _errTuKhoa.value;
  set errTuKhoa(String value) => _errTuKhoa.value ='';

  TuKhoaModel? tuKhoaUpdate;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onLoadTuKhoa();
  }


  onLoadTuKhoa() async{
    List data = await db.getList(table: 'T01_TuKhoa',where: "SoDanhHang = 0");
    _lstTuKhoa.value = data.map((e) => TuKhoaModel.fromMap(e)).toList();
  }

  onAddTuKhoa(BuildContext context) async{
    if(txtTuKhoa.text.isEmpty){
      _errTuKhoa.value = 'Trống!';
      return;
    }

    if(await db.checkExists('T01_TuKhoa', 'CumTu', txtTuKhoa.text,nextID: tuKhoaUpdate?.ID)){
      _errTuKhoa.value = 'Đã tồn tại!';
      return;
    }
    TuKhoaModel tuKhoaModel = TuKhoaModel(
        ID: tuKhoaUpdate?.ID,
        SoDanhHang: 0,
        CumTu: txtTuKhoa.text.trim(),
        ThayThe: txtThayThe.text
    );
    if(tuKhoaUpdate==null){// Insert từ khóa
      await db.insertMap(tuKhoaModel.toMap(), 'T01_TuKhoa').whenComplete((){
        Get.back();
        onLoadTuKhoa();
        FlashToast(context).showSuccess('Thêm thành công');
      });
    }else{// Update từ khóa
      await db.updateData('T01_TuKhoa', tuKhoaModel.toMap(),where: "ID = ${tuKhoaModel.ID}").whenComplete(() {
        Get.back();
        onLoadTuKhoa();
        FlashToast(context).showSuccess('Sửa thành công');
      });
    }

  }

  onEdit(TuKhoaModel tuKhoaModel){
    txtTuKhoa.text = tuKhoaModel.CumTu;
    txtThayThe.text = tuKhoaModel.ThayThe;
    tuKhoaUpdate = tuKhoaModel;
  }


  onDeleteTuKhoa(BuildContext context, TuKhoaModel tukhoa)async{
    await db.deleteData('T01_TuKhoa', where: "ID = ${tukhoa.ID}").whenComplete(() {
      Get.back();
      _lstTuKhoa.remove(tukhoa);
      FlashToast(context).showSuccess('Xóa thành công');
    });
  }


  onClearText(){
    tuKhoaUpdate = null;
    txtTuKhoa.clear();
    txtThayThe.clear();
    _errTuKhoa.value = '';
  }


}