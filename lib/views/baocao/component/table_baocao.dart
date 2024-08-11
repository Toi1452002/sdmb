import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sdmb/config/config.dart';
import 'package:sdmb/config/router.dart';
import 'package:sdmb/controllers/baocao_controller.dart';

import '../../../models/baocaotong_model.dart';

class TableBaoCao extends StatelessWidget {
  TableBaoCao({super.key, required this.data, required this.tong});

  List<BaoCaoTongModel> data;
  BaoCaoTongModel tong;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.grey),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  headerItem('Khách'),
                  headerItem('Xác'),
                  headerItem('Vốn'),
                  headerItem('Thưởng'),
                  headerItem('Lai/Lo'),
                ]),
            TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  const Text(''),
                  item(tong.Xac),
                  item(tong.Von),
                  item(tong.Thuong,showThuong: true, baocao:tong ),
                  item(tong.LaiLo,
                      color: tong.LaiLo < 0 ? Colors.red : Colors.blue),
                ]),
          ],
        ),
        Expanded(
            child: ListView(
          children: row(data),
        ))
      ],
    );
  }

  List<Widget> row(List<BaoCaoTongModel> data) {
    List<Widget> result = [];
    for (var x in data) {
      if (x.ID == -1) {
        result.add(Container(
            height: 25,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            color: Colors.blueGrey.shade400,
            width: Get.width,
            child: Text(
              DateFormat('dd/MM/yyyy').format(DateTime.parse(x.Ngay)),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )));
      } else {
        result.add(Table(
          border: TableBorder.all(color: Colors.grey, width: .3),
          children: [
            TableRow(children: [
              item(x.MaKhach, alignment: Alignment.centerLeft, isNumber: false,onLongPress: (){
                BaoCaoController().to.onLoadBCCT(x.Ngay,x.MaKhach);
                Get.toNamed(vBaoCaoChiTiet)!.then((value) {
                  BaoCaoController().to.dta.value = [];
                  BaoCaoController().to.dta1.value = [];
                  BaoCaoController().to.dta2.value = [];

                });
              }),
              item(x.Xac),
              item(x.Von),
              item(x.Thuong,showThuong:x.Thuong>0 ? true : false,baocao: x),
              item(x.LaiLo, color: x.LaiLo < 0 ? Colors.red : Colors.blue),
            ], decoration: BoxDecoration(color: Colors.white.withOpacity(.8)))
          ],
        ));
      }
    }
    return result;
  }

  Container headerItem(String text) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget item(var text,
      {Alignment alignment = Alignment.centerRight,
      bool isNumber = true,
      Color? color,
      bool showThuong = false,
      BaoCaoTongModel? baocao,
      void Function()? onLongPress
      }) {
    if (showThuong) {
      List<PopupMenuItem> popItem  = [];
      if(baocao!.Lo>0) popItem.add(PopupMenuItem(child: Text('Lô: ${NumberFormat('#,###').format(baocao.Lo)}'),));
      if(baocao.De>0) popItem.add(PopupMenuItem(child: Text('Đề: ${NumberFormat('#,###').format(baocao.De)}'),));
      if(baocao.Xien>0) popItem.add(PopupMenuItem(child: Text('Xiên: ${NumberFormat('#,###').format(baocao.Xien)}'),));
      if(baocao.bCang>0) popItem.add(PopupMenuItem(child: Text('3-4cang: ${NumberFormat('#,###').format(baocao.bCang)}'),));
      if(baocao.Khac>0) popItem.add(PopupMenuItem(child: Text('Khác: ${NumberFormat('#,###').format(baocao.Khac)}'),));
      return PopupMenuButton(
        color: Colors.white,
        elevation: 10,
        offset: const Offset(-100,0),
        itemBuilder: (context) => popItem,
        child: Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 35,
          child: Text(
            isNumber ? text.toString().formatDouble : text,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: color),
          ),
        ),
      );
    } else {
      return InkWell(
        onLongPress: onLongPress,
        child: Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 35,
          child: Text(
            isNumber ? text.toString().formatDouble : text,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: color),
          ),
        ),
      );
    }
  }
}
