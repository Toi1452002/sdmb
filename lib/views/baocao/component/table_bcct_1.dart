import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:sdmb/config/extension.dart';

class TBL_BCCT_1 extends StatelessWidget {
  TBL_BCCT_1({super.key, required this.data});
  var data;
  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columnSpacing: 10,
        empty: const Column(children: [LinearProgressIndicator()],),
        lmRatio: 0,
        border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid),
        horizontalMargin: 5,
        headingRowHeight: 35,
        dataRowHeight: 35,
        dataRowColor: const WidgetStatePropertyAll(Colors.white),
        headingRowColor: const WidgetStatePropertyAll(Colors.white),
        columns:const [
          DataColumn2(label: Text(''),fixedWidth: 50),
          DataColumn2(label: Text('Số Trúng')),
          DataColumn2(label: Text('Điểm trúng '),numeric: true),
          DataColumn2(label: Text('Tiền trúng'),numeric: true),
        ],
        rows: [
          DataRow2(onTap: (){
            showChiTiet(context, 'Lô', data['SoLo']??'', data['DiemLo'], data['TienLo']);
          },cells: [
            const DataCell(Text('Lô')),
            DataCell(Text(data['SoLo']??'')),
            DataCell(Text(data['DiemLo'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['TienLo']))),
          ]),
          DataRow2(onTap: ()=>showChiTiet(context, 'Đề', data['SoDe'], data['DiemDe'], data['TienDe']),cells: [
            const DataCell(Text('Đề')),
            DataCell(Text(data['SoDe']??'')),
            DataCell(Text(data['DiemDe'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['TienDe']))),
          ]),
          DataRow2(onTap: ()=>showChiTiet(context, 'Xiên', data['SoXien'], data['DiemXien'], data['TienXien']),cells: [
            const DataCell(Text('Xiên')),
            DataCell(Text(data['SoXien']??'')),
            DataCell(Text(data['DiemXien'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['TienXien']))),
          ]),
          DataRow2(onTap: ()=>showChiTiet(context, '3-4c', data['So34Con'], data['Diem34Con'], data['Tien34Con']),cells: [
            const DataCell(Text('3-4c')),
            DataCell(Text(data['So34Con']??'')),
            DataCell(Text(data['Diem34Con'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['Tien34Con']))),
          ]),
          DataRow2(onTap: ()=>showChiTiet(context, 'Khác', data['SoKhac'], data['DiemKhac'], data['TienKhac']),cells: [
            const DataCell(Text('Khác')),
            DataCell(Text(data['SoKhac']??'')),
            DataCell(Text(data['DiemKhac'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['TienKhac']))),
          ]),
        ]);


  }
  showChiTiet(BuildContext context, String title, var so, var diem, var tien){
    showDialog(context: context, builder: (context){
      return Dialog(

        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: const TextStyle(fontWeight: FontWeight.bold),),
              const Divider(),
              Text('Số trúng: ${so??''}'),
              const Divider(),
              Text('Điểm trúng: ${doubleParse(diem)}'),
              const Divider(),
              Text('Tiền trúng: ${doubleParse(tien)}'),
            ],
          ),
        ),
      );
    });
  }

}


