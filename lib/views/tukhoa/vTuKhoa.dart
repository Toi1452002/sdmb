import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/tukhoa_controller.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

class VTuKhoa extends StatelessWidget {
  VTuKhoa({super.key});

  final controller = Get.put(TuKhoaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ Khóa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  controller.onClearText();
                  showDialog(context);
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: Obx(() {
        return DataTable2(
            columnSpacing: 10,
            dataRowColor:
            MaterialStatePropertyAll(Colors.white.withOpacity(.5)),
            headingRowColor: const MaterialStatePropertyAll(Colors.white),
            headingRowHeight: 40,
            horizontalMargin: 10,
            empty: const Column(
              children: [
                LinearProgressIndicator(),
              ],
            ),
            border: TableBorder.all(color: Colors.grey),
            columns: const [
              DataColumn2(label: Text('Từ khóa')),
              DataColumn2(label: Text('Thay thế')),
            ],
            rows: controller.lstTuKhoa
                .map((e) =>
                DataRow2(
                    onTap: () {
                      controller.onClearText();
                      controller.onEdit(e);
                      showDialog(context);


                    },
                    onLongPress: () {
                      FlashToast(context).showAlert(
                          'Thông báo',
                          'Có chắc muốn xóa [${e.CumTu}-${e.ThayThe}]?',
                              () {
                                controller.onDeleteTuKhoa(context, e);
                              });
                    },
                    cells: [
                      DataCell(Text(e.CumTu)),
                      DataCell(Text(e.ThayThe)),
                    ]))
                .toList());
      }),
    );
  }

  showDialog(BuildContext context){//Show Dialog Thêm, Sửa từ khóa
    Get.dialog(
        Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Obx(()=>WgtTextfield(hint: 'Từ khóa',
                      errorText: controller.errTuKhoa,
                      controller: controller.txtTuKhoa,
                      onChanged: (value){
                        controller.errTuKhoa = '';
                      },
                      autofocus: true,))),
                    const SizedBox(width: 10,),
                    Expanded(child: WgtTextfield(hint: 'Thay thế',
                      controller: controller.txtThayThe,))
                  ],
                ),
                const SizedBox(height: 30,),
                WgtButton(text: 'Chấp nhận', onPressed: () {
                  controller.onAddTuKhoa(context);
                },)
              ],
            ),
          ),
        ));
  }
}
