import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/info_app.dart';
import 'package:sdmb/config/router.dart';


class WgtDrawer extends StatelessWidget {
  const WgtDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.teal.shade200,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(8),
            child: Obx((){
              final iUser = infoUser.value;
              return RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: 'Mã HD: ${iUser.maHD}\n'),
                      TextSpan(text: 'Ngày hết hạn: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(iUser.ngayHetHan))} (Còn ${iUser.soNgayCon})' ),
                      // TextSpan(text: '\nPhiên bản: $APP_VERSION'),
                    ]
                ),
              );
            }),
          ),
          ListTile(
            onTap: ()=>Get.toNamed(vKhach),
            title: Text('Danh sách khách'),
            leading: Icon(Icons.list),
          ),
          ListTile(
            onTap: ()=>Get.toNamed(vKQXS),
            title: Text('Kết quả xổ số'),
            leading: Icon(Icons.table_chart_outlined),
          ),
          ListTile(
            onTap: ()=>Get.toNamed(vTuKhoa),
            title: Text('Thay thế từ khóa'),
            leading: Icon(Icons.change_circle_outlined),
          ),
          ListTile(
            onTap: ()=>Get.toNamed(vCaiDat),
            title: Text('Cài đặt'),
            leading: Icon(Icons.settings),
          ),
          Align(alignment: Alignment.centerLeft,child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Phiên bản: $APP_VERSION',style: TextStyle(color: Colors.grey),),
          )),
          Spacer(),

          ListTile(
            onTap: ()=>exit(0),
            title: Text('Thoát',style: TextStyle(color: Colors.red),),
            leading: Icon(Icons.exit_to_app,color: Colors.red,),
          ),

        ],
      ),
    );
  }
}
