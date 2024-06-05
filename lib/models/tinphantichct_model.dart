// ignore_for_file: non_constant_identifier_names


class TinPhanTichCTModel{
  int? ID;
  int TinNhanCT;
  int MaTin;
  String MaKieu;
  String SoDanh;
  double TienXac;
  double TienVon;
  int SoLanTrung;
  double TienTrung;

  TinPhanTichCTModel({this.ID, this.TinNhanCT = 0, this.MaTin = 0, this.MaKieu = '',
    this.SoDanh = '', this.TienXac = 0, this.TienVon = 0 , this.SoLanTrung = 0, this.TienTrung = 0});

  Map<String, dynamic> toMap()=>{
    'ID':ID,
    'TinNhanCTID': TinNhanCT,
    'MaTin':MaTin,
    'MaKieu':MaKieu,
    'SoDanh':SoDanh,
    'TienXac':TienXac,
    'TienVon':TienVon,
    'SoLanTrung':SoLanTrung,
    'TienTrung':TienTrung
  };

  factory TinPhanTichCTModel.fromMap(Map<String, dynamic> map)=>TinPhanTichCTModel(
      ID: map['ID'],
      MaTin: map['MaTin'],
      TinNhanCT: map['TinNhanCT'],
      MaKieu: map['MaKieu'],
      SoDanh: map['SoDanh'],
      SoLanTrung: map['SoLanTrung'],
      TienTrung: map['TienTrung'],
      TienVon: map['TienVon'],
      TienXac: map['TienXac']
  );
}