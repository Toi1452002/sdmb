import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../config/extension.dart';

class TBL_BCCT_2 extends StatelessWidget {
  TBL_BCCT_2({super.key, this.data});
  var data;
  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columnSpacing: 10,
        // empty: const Column(children: [LinearProgressIndicator()],),
        lmRatio: 0,
        border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid),
        horizontalMargin: 5,
        headingRowHeight: 35,
        dataRowHeight: 35,
        dataRowColor: WidgetStatePropertyAll(Colors.white),
        headingRowColor: const WidgetStatePropertyAll(Colors.white),
        columns: const [
          DataColumn2(label: Text(''),fixedWidth: 50),
          DataColumn2(label: Text('Xác'),numeric: true),
          DataColumn2(label: Text('Vốn'),numeric: true),
          DataColumn2(label: Text('Thưởng'),numeric: true),
        ],
        rows:  [
          DataRow2(cells: [
            DataCell(Text('Lô')),
            DataCell(Text(data['XacLo'].toString().formatDouble)),
            DataCell(Text(data['VonLo'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongLo']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('Đề')),
            DataCell(Text(data['XacDe'].toString().formatDouble)),
            DataCell(Text(data['VonDe'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongDe']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X2')),
            DataCell(Text(data['XacX2'].toString().formatDouble)),
            DataCell(Text(data['VonX2'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongX2']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X3')),
            DataCell(Text(data['XacX3'].toString().formatDouble)),
            DataCell(Text(data['VonX3'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongX3']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X4')),
            DataCell(Text(data['XacX4'].toString().formatDouble)),
            DataCell(Text(data['VonX4'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongX4']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('3C')),
            DataCell(Text(data['Xac3c'].toString().formatDouble)),
            DataCell(Text(data['Von3c'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['Thuong3c']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('4C')),
            DataCell(Text(data['Xac4c'].toString().formatDouble)),
            DataCell(Text(data['Von4c'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['Thuong4c']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('Khac')),
            DataCell(Text(data['XacK'].toString().formatDouble)),
            DataCell(Text(data['VonK'].toString().formatDouble)),
            DataCell(Text(doubleParse(data['ThuongK'].toString()))),
          ]),
        ]);
  }
}
