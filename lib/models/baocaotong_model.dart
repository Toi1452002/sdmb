// ignore_for_file: non_constant_identifier_names

import 'package:sdmb/config/extension.dart';

class BaoCaoTongModel{
  int? ID;
  String Ngay;
  String MaKhach;
  double Xac;
  double Von;
  double Thuong;
  double LaiLo;
  double Lo;
  double De;
  double Xien;
  double bCang;
  double Khac;

  BaoCaoTongModel({
    this.ID,
    this.Ngay = '',
    this.MaKhach = '',
    this.Xac = 0,
    this.Von = 0,
    this.Thuong = 0,
    this.LaiLo = 0,
    this.Lo = 0,
    this.De = 0,
    this.Xien = 0,
    this.bCang = 0,
    this.Khac = 0 });


  factory BaoCaoTongModel.fromMap(Map<String, dynamic> map)=>BaoCaoTongModel(
    ID: map['ID'],
    Ngay: map['Ngay'],
    MaKhach: map['MaKhach'],
    Xac: map['Xac'],
    Von: map['Von'],
    Thuong: map['Thuong'],
    LaiLo: map['LaiLo'],
    Lo: map['Lo'].toString().toDouble,
    De: map['De'].toString().toDouble,
    bCang: map['bCang'].toString().toDouble,
    Xien: map['Xien'].toString().toDouble,
    Khac: map['Khac'].toString().toDouble
  );

  String loadBaoCao(String tuNgay, String denNgay) => '''
    SELECT ID, Ngay, MaKhach, Sum(Xac) Xac, Sum(Von) Von, Sum(Thuong) Thuong, Sum(LaiLo) LaiLo, Sum(Lo) Lo, Sum(De) De, Sum(Xien) Xien, Sum(bCang) bCang, Sum(Khac) Khac
    FROM VBC_TongHop 
    WHERE Ngay BETWEEN '$tuNgay'  AND '$denNgay'
    Group By MaKhach, Ngay
    ORDER BY Ngay
  ''';
}