import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/config/router.dart';
import 'package:sdmb/config/toast.dart';
import 'package:sdmb/controllers/khach_controller.dart';
import 'package:sdmb/models/khach_model.dart';

class VKhach extends StatelessWidget {
  VKhach({super.key});

  final controller = Get.put(KhachController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khách'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  controller.clearText();
                  controller.onLoadGiaKhach();
                  Get.toNamed(vThemKhach);
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                )),
          )
        ],
      ),
      body: Obx(() {
        List<KhachModel> data = controller.lstKhach;
        if (controller.isLoading) {
          return const LinearProgressIndicator();
        } else if (data.isEmpty && !controller.isLoading) {
          return const Center(
            child: Text('Chưa có khách!',style: TextStyle(
              color: Colors.grey,
              fontSize: 20
            ),),
          );
        } else {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) => ListTile(
              trailing: PopupMenuButton(
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Text('Sửa'),
                        Spacer(),
                        Icon(Icons.edit)
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Text('Sao chép'),
                        Spacer(),
                        Icon(Icons.copy)
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Text('Xóa', style: TextStyle(color: Colors.red),),
                        Spacer(),
                        Icon(Icons.delete_outline,color: Colors.red,)
                      ],
                    ),),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      controller.onEdit(data[i]);
                      Get.toNamed(vThemKhach);
                      break;
                    case 1:
                      controller.onEdit(data[i],copy: true);
                      Get.toNamed(vThemKhach);
                      break;
                    case 2:
                      FlashToast(context).showAlert(
                          'Thông báo',
                          'Có chắc muốn xóa \'${data[i].MaKhach}\'? \nSau khi xóa toàn bộ dữ liệu của khách này sẽ mất.',
                          () {
                            controller.onDeleteKhach(data[i],context);
                          });
                      break;
                  }
                },
              ),
              subtitle: Text(data[i].SDT),
              leading: Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(50)),
                child: Text((i + 1).toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(
                data[i].MaKhach,
              ),
            ),
          );
        }
      }),
    );
  }
}
