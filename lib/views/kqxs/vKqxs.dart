import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/kqxs_controller.dart';
import 'package:sdmb/widgets/wgt_button.dart';

class VKqxs extends StatelessWidget {
  VKqxs({super.key});

  final controller = Get.put(KqxsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KQXS'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => WgtButton(
                  text: controller.txtNgay,
                  width: 130,
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                        initialDate: controller.ngay,
                        context: context,
                        locale: const Locale('vi', ''),
                        firstDate: DateTime(2000),
                        fieldHintText: "Ngày/Tháng/Năm",
                        lastDate: DateTime.now());
                    if (date != null) {
                      controller.ngay = date;
                    }
                  },
                )),
          ),
          IconButton(
              onPressed: () {
                Get.dialog(Dialog(
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('KQXS Minh Ngọc'),
                          leading: const Icon(Icons.change_circle_outlined),
                          trailing: Obx(()=>Checkbox(
                            onChanged: (value){
                              controller.kqxsMN = value!;
                            },
                            value: controller.kqxsMN,
                          )),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            'Xóa toàn bộ KQXS',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: (){
                            FlashToast(context).showAlert('Thông báo', 'Có chắc muốn xóa?', () {
                              controller.onDeleteKQXS(context);
                            });
                          },
                          leading: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Obx(() => DataTable2(
          columnSpacing: 10,
          horizontalMargin: 12,
          dataRowHeight: 60,
          headingRowHeight: 40,
          empty: controller.isLoading
              ? const Column(
                  children: [LinearProgressIndicator()],
                )
              : const Center(
                  child: Text(
                    'Chưa có KQXS',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
          dataRowColor: MaterialStatePropertyAll(Colors.white.withOpacity(.8)),
          headingRowColor: const MaterialStatePropertyAll(Colors.white),
          border: TableBorder.all(color: Colors.grey),
          columns: const [
            DataColumn2(label: Text('Giải'), fixedWidth: 40),
            DataColumn2(
                label: Center(
              child: Text('Kết quả'),
            )),
          ],
          rows: controller.lstKqxs
              .map((e) => DataRow2(cells: [
                    DataCell(Text(e.MaGiai)),
                    DataCell(
                      Center(
                        child: Text(
                          e.KQso,
                          softWrap: true,
                          textScaler: TextScaler.noScaling,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ]))
              .toList())),
    );
  }
}
