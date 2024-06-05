
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/extension.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/models/giakhach_model.dart';
import 'package:sdmb/models/khach_model.dart';

class KhachController extends GetxController{

  ///Khai bao bien
  ConnectDB db = ConnectDB();
  KhachController get to => Get.find();

  final RxList<KhachModel> _lstKhach = <KhachModel>[].obs;//Danh sách khách
  List<KhachModel> get lstKhach => _lstKhach.value;

  final RxBool _isLoading = false.obs; //Loading.....
  bool get isLoading => _isLoading.value;

  final RxList<GiaKhachModel> _lstGiaKhach = <GiaKhachModel>[].obs;// Danh sách giá khách
  List<GiaKhachModel> get lstGiaKhach => _lstGiaKhach.value;

  final RxBool _dautren = false.obs;
  bool get dautren => _dautren.value;
  set dautren(bool value)=> _dautren.value = value;

  final txtTenKhach = TextEditingController();
  final txtGiuLai = TextEditingController();
  final txtAU3 = TextEditingController();
  final txtAU34 = TextEditingController();
  final txtSDT = TextEditingController();

  KhachModel? khachEdit;

  ///
  ///
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onGetKhach();
  }

  ///Lấy danh sách khách hàng
  onGetKhach()async{
    _isLoading.value = true;
    List data = await  db.getList(table: 'TDM_Khach',orderBy: 'MaKhach');

    if(data.isNotEmpty){
      _lstKhach.value = data.map((e) => KhachModel.fromMap(e)).toList();
      _isLoading.value = false;
    }else{
      _isLoading.value = false;
    }
  }

  onLoadGiaKhach({bool add = true, int? id}) async{

     List data = add
         ? await db.getList(table: 'T01_KieuChoi') //Nếu là thêm thì lấy giá có sẵn
         : await db.getList(sql: GiaKhachModel().sqlLoadGia(id));// Nếu là edit

    _lstGiaKhach.value = data.map((e) => GiaKhachModel.fromMap(e)).toList();

  }

  onAddKhach(BuildContext context)async{// thêm, update khách
    if(txtTenKhach.text.isEmpty){
      FlashToast(context).showError('Chưa nhập tên khách');
      return;
    }
    if(await db.checkExists('TDM_Khach', 'MaKhach', txtTenKhach.text,nextID: khachEdit?.ID)){
      FlashToast(context).showError('Tên khách đã tồn tại');
      return;
    }


    KhachModel khach = KhachModel(
      MaKhach: txtTenKhach.text.trim(),
      SDT: txtSDT.text.trim(),
      kDauTren: _dautren.value ? 1 : 0,
      Hoi: txtGiuLai.text.toDouble,
      aux3: txtAU34.text.toInt,
      au3c: txtAU3.text.toInt,
    );
    if(khachEdit == null || (khachEdit!=null && khachEdit!.copy)){// Nếu là thêm
      int idInsert = await db.insertMap(khach.toMap(), 'TDM_Khach').whenComplete(() {
        onGetKhach();
      });
      if(idInsert>0){
        await db.insertList(
            lstData: _lstGiaKhach.map((e) {
              e.ID = null;
              e.KhachID = idInsert;
              return e.toMap();
            }).toList(),
            tbName: 'TDM_GiaKhach').whenComplete(() => Get.back()
        );
      }
    }else{// Update
      khach.ID = khachEdit!.ID;
      await db.updateData('TDM_Khach', khach.toMap(),where: "ID = ${khachEdit!.ID}");
      await db.deleteData('TDM_GiaKhach',where: "KhachID = ${khachEdit!.ID}").whenComplete(() async {
        await db.insertList(
            lstData: _lstGiaKhach.map((e) {
              e.KhachID = khachEdit!.ID;
              return e.toMap();
            }).toList(),
            tbName: 'TDM_GiaKhach').whenComplete(() {
              onGetKhach();
              Get.back();
            }
        );
      });

    }

  }
  onDeleteKhach(KhachModel khach, BuildContext context) async{
    await db.deleteData('TDM_Khach',where: "ID = ${khach.ID}");
    await db.deleteData('TDM_GiaKhach',where:"KhachID = ${khach.ID}");
    _lstKhach.remove(khach);
    Get.back();
    FlashToast(context).showSuccess('Xóa thành công');
  }

  onEdit(KhachModel khach, {bool copy = false}){
    txtTenKhach.text =copy ? '' : khach.MaKhach;
    txtAU3.text = khach.au3c.toString();
    txtGiuLai.text = khach.Hoi.toString();
    txtSDT.text = khach.SDT;
    txtAU34.text = khach.aux3.toString();
    khachEdit = khach;
    khachEdit!.copy = copy;
    onLoadGiaKhach(add: false,id: khach.ID);
  }

  clearText(){
    txtTenKhach.clear();
    txtSDT.clear();
    txtAU34.clear();
    txtAU3.clear();
    txtGiuLai.clear();
    khachEdit = null;
    _dautren.value = false;
  }
}