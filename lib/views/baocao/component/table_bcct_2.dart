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
        headingRowHeight: 40,
        dataRowColor: MaterialStatePropertyAll(Colors.white),
        headingRowColor: const MaterialStatePropertyAll(Colors.white),
        columns: const [
          DataColumn2(label: Text(''),fixedWidth: 50),
          DataColumn2(label: Text('Xác'),numeric: true),
          DataColumn2(label: Text('Vốn'),numeric: true),
          DataColumn2(label: Text('Thưởng'),numeric: true),
        ],
        rows:  [
          DataRow2(cells: [
            DataCell(Text('Lô')),
            DataCell(Text(doubleParse(data['XacLo']))),
            DataCell(Text(doubleParse(data['VonLo']))),
            DataCell(Text(doubleParse(data['ThuongLo']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('Đề')),
            DataCell(Text(doubleParse(data['XacDe']))),
            DataCell(Text(doubleParse(data['VonDe']))),
            DataCell(Text(doubleParse(data['ThuongDe']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X2')),
            DataCell(Text(doubleParse(data['XacX2']))),
            DataCell(Text(doubleParse(data['VonX2']))),
            DataCell(Text(doubleParse(data['ThuongX2']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X3')),
            DataCell(Text(doubleParse(data['XacX3']))),
            DataCell(Text(doubleParse(data['VonX3']))),
            DataCell(Text(doubleParse(data['ThuongX3']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('X4')),
            DataCell(Text(doubleParse(data['XacX4']))),
            DataCell(Text(doubleParse(data['VonX4']))),
            DataCell(Text(doubleParse(data['ThuongX4']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('3C')),
            DataCell(Text(doubleParse(data['Xac3c']))),
            DataCell(Text(doubleParse(data['Von3c']))),
            DataCell(Text(doubleParse(data['Thuong3c']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('4C')),
            DataCell(Text(doubleParse(data['Xac4c']))),
            DataCell(Text(doubleParse(data['Von4c']))),
            DataCell(Text(doubleParse(data['Thuong4c']))),
          ]),
          DataRow2(cells: [
            DataCell(Text('Khac')),
            DataCell(Text(doubleParse(data['XacK'].toString()))),
            DataCell(Text(doubleParse(data['VonK'].toString()))),
            DataCell(Text(doubleParse(data['ThuongK'].toString()))),
          ]),
        ]);
  }
}
