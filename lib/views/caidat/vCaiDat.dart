import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_dropdown.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

import '../../controllers/caidat_controller.dart';

class VCaiDat extends StatelessWidget {
  VCaiDat({super.key});

  final controller = Get.put(CaiDatController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cài đặt'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Kieu số bộ'),
              subtitle: const Text('bo11.22=bo11.bo22'),
              trailing: Obx(() => Checkbox(
                    value: controller.kieSoBo.value,
                    onChanged: (value) {
                      controller.kieSoBo.value = value!;
                      controller.onUpdateData(
                          value: value ? 1 : 0, where: "Ma = 'bo'");
                    },
                  )),
            ),
            ListTile(
              title: const Text('Xiên quay'),
              subtitle: const Text('chỉ tính quay tren xien 2'),
              trailing: Obx(() => Checkbox(
                    value: controller.xienQuay.value,
                    onChanged: (value) {
                      controller.xienQuay.value = value!;
                      controller.onUpdateData(
                          value: value ? 1 : 0, where: "Ma = 'xq'");
                    },
                  )),
            ),
            ListTile(
              title: const Text('Tách xiên quay'),
              trailing: Obx(() => Checkbox(
                    value: controller.tachXienQuay.value,
                    onChanged: (value) {
                      controller.tachXienQuay.value = value!;
                      controller.onUpdateData(
                          value: value ? 1 : 0, where: "Ma = 'txq'");
                    },
                  )),
            ),
            ListTile(
              title: const Text('Tách thông cửa'),
              subtitle: const Text('tách Thông cửa = de+giai nhat'),
              trailing: Obx(() => Checkbox(
                    value: controller.tachThongCua.value,
                    onChanged: (value) {
                      controller.tachThongCua.value = value!;
                      controller.onUpdateData(
                          value: value ? 1 : 0, where: "Ma = 'ttc'");
                    },
                  )),
            ),
            ListTile(
              title: const Text('Hệ số xiên'),
              subtitle: const Text('nhân hệ số tiền xác xien'),
              trailing: SizedBox(
                width: 60,
                child: WgtTextfield(
                  keyboardType: TextInputType.number,
                  onlyNumber: true,
                  maxLength: 2,
                  controller: controller.txtHeSoXien,
                  textAlign: TextAlign.end,
                  onChanged: (value) {
                    controller.onUpdateData(
                        value: value, where: "Ma = 'xxien'");
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('Hệ số xiên quay'),
              subtitle: const Text('nhân hệ số tiền xác xienquay'),
              trailing: SizedBox(
                width: 60,
                child: WgtTextfield(
                  maxLength: 2,
                  onlyNumber: true,
                  keyboardType: TextInputType.number,
                  controller: controller.txtHeSoXienQuay,
                  textAlign: TextAlign.end,
                  onChanged: (value) {
                    controller.onUpdateData(value: value, where: "Ma = 'xxq'");
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('Xiên nháy'),
              subtitle: const Text('Cho phép trúng xiên nháy'),
              trailing: Obx(() => WgtDropdown(
                    width: 60,
                    items: const ['0', '2', '3', '4'],
                    value: controller.xienNhay.value,
                    onChange: (String? value) {
                      controller.xienNhay.value = value!;
                      controller.onUpdateData(value: value, where: "Ma = 'xn'");
                    },
                  )),
            ),
            ColoredBox(
              color: Colors.white.withOpacity(.8),
              child: ListTile(
                leading: Icon(Icons.delete,color: Colors.red,),
                title: Text('Xóa tất cả tin nhắn'),
                onTap: (){
                  FlashToast(context).showAlert('Xóa tin nhắn', 'Xóa toàn bộ tin đã tính từ trước tới giờ?', () {
                    controller.onDeleteAllTin(context);
                  });
                },
              ),
            ),
            ColoredBox(
              color: Colors.white.withOpacity(.8),
              child: ListTile(

                leading: Icon(Icons.person),
                title: const Text('Tài khoản'),
                onTap: () {
                  controller.onClearText();
                  controller.onLoadTaiKhoan();
                  Get.dialog(Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Đổi tài khoản',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Obx(() => WgtTextfield(
                                label: 'Tài khoản',
                                controller: controller.txtTaiKhoan,
                                errorText: controller.errTaiKhoan.value,
                                onChanged: (value) {
                                  controller.errTaiKhoan.value = '';
                                },
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => WgtTextfield(
                            label: 'Mật khẩu mới',
                            obscureText: true,
                            errorText: controller.errMatKhau.value,
                            onChanged: (value) {
                              controller.errMatKhau.value = '';
                            },
                            controller: controller.txtMatKhau,
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => WgtTextfield(
                              label: 'Xác nhận mật khẩu',
                              errorText: controller.errXacNhanMatKhau.value,
                              onChanged: (value) {
                                controller.errXacNhanMatKhau.value = '';
                              },
                              obscureText: true,
                              controller: controller.txtXacNhanMatKhau)),
                          const SizedBox(
                            height: 20,
                          ),
                          WgtButton(
                            text: 'Chấp nhận',
                            onPressed: () {
                              controller.onChangeTaikhoan(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ));
                },
              ),
            ),
            if(Platform.isAndroid) ColoredBox(
              color: Colors.white.withOpacity(.8),
              child: ListTile(
                leading: Icon(Icons.update,),
                title: Text('Cập nhật ứng dụng'),
                onTap: (){
                  controller.onCapNhat(context);
                  // FlashToast(context).showAlert('Xóa tin nhắn', 'Xóa toàn bộ tin đã tính từ trước tới giờ?', () {
                  //   controller.onDeleteAllTin(context);
                  // });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
