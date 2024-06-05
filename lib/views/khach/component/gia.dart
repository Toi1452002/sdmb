import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdmb/controllers/khach_controller.dart';
import 'package:sdmb/models/giakhach_model.dart';
import 'package:sdmb/widgets/wgt_textfield.dart';

class Gia extends StatelessWidget {
  const Gia({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<GiaKhachModel> giaKhach = KhachController().to.lstGiaKhach;
      return DataTable2(
          columnSpacing: 10,
          empty: const Column(children: [LinearProgressIndicator()],),
          lmRatio: 0,
          border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid),
          horizontalMargin: 5,
          headingRowHeight: 40,
          dataRowColor: MaterialStatePropertyAll(Colors.white.withOpacity(.8)),
          headingRowColor: const MaterialStatePropertyAll(Colors.white),
          columns: const [
            DataColumn2(label: Text('Kiểu'), fixedWidth: 60),
            DataColumn2(label: Text('Mô tả')),
            DataColumn2(label: Text('Tỷ lệ'), fixedWidth: 80),
            DataColumn2(label: Text('Thưởng'), fixedWidth: 80),
          ],
          rows: giaKhach
              .map((e) => DataRow2(cells: [
                    DataCell(Text(e.MaKieu)),
                    DataCell(Text(e.MoTa)),
                    DataCell(SizedBox(
                      height: 35,
                      child: WgtTextfield(
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          e.Diem = value.isNum ? double.parse(value) : 0;
                        },
                        textAlign: TextAlign.center,
                        controller: TextEditingController(text: e.Diem.toString(),),
                      ),
                    )),
                    DataCell(SizedBox(
                      height: 35,
                      child: WgtTextfield(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value){
                          e.Thuong = value.isNum ? double.parse(value) : 0;
                        },
                        controller: TextEditingController(text: e.Thuong.toString(),),
                      ),
                    )),
                  ]))
              .toList());
    });
  }
}
