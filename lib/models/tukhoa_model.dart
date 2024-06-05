// ignore_for_file: non_constant_identifier_names

class TuKhoaModel{
  int? ID;
  String CumTu;
  String ThayThe;
  int SoDanhHang;

  TuKhoaModel({this.ID, this.CumTu = '', this.ThayThe = '', this.SoDanhHang = 0});

  Map<String, dynamic> toMap()=>{
    'ID':ID,
    'CumTu':CumTu,
    'ThayThe':ThayThe,
    'SoDanhHang':SoDanhHang
  };

  factory TuKhoaModel.fromMap(Map<String, dynamic> map)=>TuKhoaModel(
    ID: map['ID'],
    CumTu: map['CumTu']??'',
    ThayThe: map['ThayThe']??'',
    SoDanhHang: map['SoDanhHang']
  );
}