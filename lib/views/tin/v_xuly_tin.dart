import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/router.dart';
import 'package:sdmb/controllers/xulytin_controller.dart';
import 'package:sdmb/widgets/widgets.dart';

class VXuLyTin extends StatelessWidget {
  VXuLyTin({super.key});

  final controller = Get.put(XuLyTinController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Xử lý tin'),
          actions: [
            if(Platform.isAndroid) Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: TextButton(onPressed: (){

                Get.toNamed(vTinSMS);
                controller.getAllMessages(context);
              }, child: const Text('Tin SMS',style: TextStyle(
                decoration: TextDecoration.underline,
                  color: Colors.black
              ),)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Obx(() => WgtDropdown(
                          items: controller.lstMaKhach.value,
                          value: controller.strMaKhach == ''
                              ? null
                              : controller.strMaKhach,
                          hint: 'Chọn khách',
                          onChange: (value) {
                            controller.strMaKhach = value!;
                          }))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => WgtButton(
                          text: controller.strNgayLam,
                          onPressed: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                initialDate: controller.ngayLam);
                            if (date != null) {
                              controller.ngayLam = date;
                            }
                          },
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: WgtButton(
                    text: 'Kiểm lỗi',
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      controller.onKiemLoi(context);
                    },
                    color: Colors.blue,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Obx(()=>WgtButton(
                        text: 'Tính toán',
                        enable: controller.enableTinhToan,
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.onTinhToan(context);
                        },
                        color: Colors.red,
                      ))),
                ],
              ),
              SizedBox(height: 5,),
              Obx(() => WgtTextfield(
                    hint: 'Nhập tin...',
                    controller: controller.txtTinXL,
                    enabled: controller.enableTinXL,
                    errorText: controller.txtErr,
                    onChanged: (value) {

                      EasyDebounce.debounce(
                          'tin-xuly', const Duration(milliseconds: 300), () {
                        controller.onUpdateCell('TinXL', 'TXL_TinNhanCT',
                            "TinNhanID = ${controller.newIDTinNhan}", value);
                        controller.onUpdateTin(value);
                      });
                    },
                    maxLines: 10,
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.teal.shade100),
                child: Obx(() => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: textKQ(
                                    text: controller.strDiem.value,
                                    title: 'Điểm')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: textKQ(
                                    text: controller.strTien.value,
                                    title: 'Tiền')),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: textKQ(
                                    text: controller.strThuong.value,
                                    title: 'Thưởng')),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: textKQ(
                                    color: controller.strLaiLo.value.contains('-') ? Colors.red : Colors.blue,
                                    text: controller.strLaiLo.value,
                                    title: 'Lãi/Lỗ')),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(() => WgtButton(
                              text: '<<< Xem chi tiết',
                              enable: controller.newIDTinNhan.value == null
                                  ? false
                                  : true,
                              onPressed: () {
                                controller.onXemChiTiet();
                                Get.toNamed(vXemChiTiet)!.then((value) => controller.clearXemCT());
                              },
                            ))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Container textKQ({String text = '', String title = '', Color? color}) {
  return Container(
    height: 30,
    width: 100,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.centerLeft,
    color: Colors.white,
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
            text: title,
            style: const TextStyle(color: Colors.grey, fontSize: 15)),
        const TextSpan(text: '\t'),
        TextSpan(
            text:  text,
            style: TextStyle(color: color ?? Colors.black, fontSize: 16))
      ]),
    ),
  );
}
