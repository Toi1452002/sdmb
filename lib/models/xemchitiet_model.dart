// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:sdmb/config/extension.dart';

class XemChiTietModel {
  int? ID;
  String Ngay;
  int KhachID;
  String MaKieu;
  String SoDanh;
  double Xac;
  double Von;
  double Diem;
  double Thuong;

  @override
  String toString() {
    return 'XemChiTietModel{ID: $ID, Ngay: $Ngay, KhachID: $KhachID, MaKieu: $MaKieu, SoDanh: $SoDanh, Xac: $Xac, Von: $Von, Diem: $Diem, Thuong: $Thuong}';
  }

  XemChiTietModel(
      {this.ID,
      this.Ngay = '',
      this.KhachID = 0,
      this.MaKieu = '',
      this.SoDanh = '',
      this.Thuong = 0,
      this.Diem = 0,
      this.Von = 0,
      this.Xac = 0});

  Map<String, dynamic> toMap() => {
    'Thuong': Thuong,
    'Diem':  Diem,
    'Von':Von,
    'Xac': Xac
  };

  factory  XemChiTietModel.fromMap(Map<String, dynamic> map)=>XemChiTietModel(
    ID: map['ID'],
    SoDanh: map['SoDanh'],
    MaKieu: map['MaKieu'],
    KhachID: map['KhachID'],
    Ngay: map['Ngay'],
    Thuong: map['Thuong'],
    Diem:map['Diem'] ,
    Von: map['Von'],
    Xac:map['Xac']
  );
}
