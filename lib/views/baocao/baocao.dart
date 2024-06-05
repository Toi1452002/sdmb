import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/controllers/baocao_controller.dart';
import 'package:sdmb/views/baocao/component/table_baocao.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_drawer.dart';
import 'package:sdmb/widgets/wgt_dropdown.dart';

class VBaoCao extends StatelessWidget {
  VBaoCao({super.key});

  final controller = Get.put(BaoCaoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const WgtDrawer(),
      appBar: AppBar(
        title: const Text('Báo cáo'),
        actions: [],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.teal.shade100),
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => WgtButton(
                  text: controller.strNgay,
                  onPressed: () async {
                    DateTimeRange? date = await showDateRangePicker(
                        context: context,
                        saveText: 'Chấp nhận',
                        fieldEndHintText: 'dd/mm/yyy',
                        fieldStartHintText: 'dd/mm/yyy',
                        fieldEndLabelText: 'Đến ngày',
                        fieldStartLabelText: 'Từ ngày',
                        initialDateRange: controller.ngay,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now());
                    if (date != null) {
                      controller.ngay = date;
                    }
                  },
                )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => WgtDropdown(
                        items: controller.lstMaKhach,
                        width: 150,
                        value: controller.selectMaKhach == '' ? null : controller.selectMaKhach,
                        hint: 'Chọn khách',
                        onChange: (value) {
                          controller.selectMaKhach = value!;
                        })),
                    Obx(() => RichText(
                        text:  TextSpan(children: [
                          const TextSpan(
                              text: 'Tổng cộng: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15)),
                          TextSpan(text: NumberFormat('#,###').format(controller.tongTien.value.LaiLo),style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:controller.tongTien.value.LaiLo<0 ? Colors.red : Colors.blue,
                              backgroundColor: Colors.white,
                              fontSize: 18
                          )),
                        ])))
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Obx((){
            return TableBaoCao(data: controller.lstBaoCaoTong,tong: controller.tongTien.value);
          }))
        ],
      ),
    );
  }
}
