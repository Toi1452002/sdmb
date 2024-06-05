import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/config.dart';
import 'package:sdmb/controllers/xulytin_controller.dart';
import 'package:sdmb/models/xemchitiet_model.dart';
import 'package:sdmb/widgets/wgt_dropdown.dart';

class VXemChiTiet extends StatelessWidget {
  const VXemChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem CT'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => WgtDropdown(
                width: 150,
                value: XuLyTinController().to.strKieu,
                items: XuLyTinController().to.lstKieu,
                onChange: (value) {
                  XuLyTinController().to.strKieu = value!;
                })),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            width: Get.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.grey)),
            child: Text(XuLyTinController().to.txtTinXL.text),
          ),
          Expanded(child: Obx(() {
            List<XemChiTietModel> data = XuLyTinController().to.lstXemChiTiet;
            return DataTable2(
              border: TableBorder.all(color: Colors.grey),
              columnSpacing: 10,
              fixedTopRows: 2,

              headingRowColor: const MaterialStatePropertyAll(Colors.white),
              dataRowColor: MaterialStatePropertyAll(Colors.white.withOpacity(.8)),
              horizontalMargin: 12,
              dataRowHeight: 45,
              headingRowHeight: 40,
              empty: XuLyTinController().to.isLoading
                  ? const Column(
                      children: [LinearProgressIndicator()],
                    )
                  : const Center(
                      child: Text(
                        'Trống!',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
              columns: const [
                DataColumn2(label: Text('Số'),fixedWidth: 70),
                DataColumn2(label: Text('Kiểu'),fixedWidth: 70),
                DataColumn2(label: Text('Điểm')),
                DataColumn2(label: Text('Vốn')),
                DataColumn2(label: Text('Trúng')),
                DataColumn2(label: Text('Thưởng')),
              ],
              rows: data
                  .map((e) => DataRow2(
                          onTap: (){
                            Get.dialog(Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.white,
                                width: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Số: ${e.SoDanh}'),
                                    const Divider(),
                                    Text('Kiểu: ${e.MaKieu}'),
                                    const Divider(),
                                    Text('Xác: ${e.Xac.toString().formatDouble}'),
                                    const Divider(),
                                    Text('Vốn: ${e.Von.toString().formatDouble}'),
                                    const Divider(),
                                    Text('Điểm: ${e.Diem.toString().formatDouble}'),
                                    const Divider(),
                                    Text('Thưởng: ${e.Thuong.toString().formatDouble}'),


                                  ],
                                ),
                              ),
                            ));
                          },

                          color: e.Diem>0 && e.SoDanh != ''
                              ? WidgetStatePropertyAll(Colors.red.shade50)
                              : null,
                          cells: [
                            DataCell(Text(e.SoDanh)),
                            DataCell(Text(e.MaKieu)),
                            DataCell(Text(NumberFormat('#,###').format(e.Xac))),
                            DataCell(Text(NumberFormat('#,###').format(e.Von))),
                            DataCell(Text(NumberFormat('#,###').format(e.Diem))),
                            DataCell(Text(NumberFormat('#,###').format(e.Thuong))),
                          ]))
                  .toList(),
            );
          }))
        ],
      ),
    );
  }
}
