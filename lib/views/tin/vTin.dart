import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/router.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/tinnhan_controller.dart';
import 'package:sdmb/controllers/xulytin_controller.dart';
import 'package:sdmb/models/tinnhan_model.dart';
import 'package:sdmb/views/tin/v_xuly_tin.dart';
import 'package:sdmb/widgets/wgt_button.dart';
import 'package:sdmb/widgets/wgt_drawer.dart';
import 'package:sdmb/widgets/wgt_dropdown.dart';

class VTin extends StatelessWidget {
  VTin({super.key});

  final controller = Get.put(TinNhanContoller());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        drawer: const WgtDrawer(),
        appBar: AppBar(
          title: const Text('Tin Nhắn'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Obx(() => WgtButton(
                    text: controller.strNgayLam,
                    width: 130,
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
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => WgtDropdown(
                    items: controller.lstMaKhach.value,
                    value: controller.strFilter == ''
                        ? null
                        : controller.strFilter,
                    hint: 'Chọn khách',
                    onChange: (value) {
                      controller.strFilter = value!;
                    },
                    width: Get.width,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() {
                List<TinNhanModel> data = controller.lstTinNhan;
                if (!controller.isLoading && data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có tin',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  );
                } else if (data.isNotEmpty && !controller.isLoading) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => Card(
                      child: ListTile(
                        onTap: (){
                          Get.lazyPut(()=>XuLyTinController());
                          XuLyTinController().to.onEditTin(data[i]);
                          Get.toNamed(vXuLyTin)!.then((value) {
                            // Future.delayed(const Duration(seconds: 1),(){
                              controller.onLoadData();
                              Get.delete<XuLyTinController>();
                            // });

                          });

                        },
                        leading: Container(
                          height: 35,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            (i + 1).toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(data[i].MaKhach),
                        contentPadding: const EdgeInsets.only(left: 10),
                        subtitle: Text(
                          data[i].TinXL,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever_rounded),
                          color: Colors.red.shade400,
                          onPressed: () {
                            FlashToast(context).showAlert(// Xóa tin
                                'Thông báo', 'Có chắc muốn xóa', () {
                                  controller.onDeleteData(context, data[i]);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Column(
                    children: [LinearProgressIndicator()],
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
