// ignore_for_file: non_constant_identifier_names

class TinNhanModel{
  int? ID;
  String Ngay;
  int KhachID;
  String MaKhach;
  String TinXL;


  TinNhanModel({this.ID, this.Ngay = '', this.KhachID = 0, this.MaKhach = '', this.TinXL = ''});

  Map<String, dynamic> toMap()=>{
    'ID':ID,
    'Ngay':Ngay,
    'KhachID':KhachID
  };

  factory TinNhanModel.fromMap(Map<String, dynamic> map)=>TinNhanModel(
    ID: map['ID'],
    Ngay: map['Ngay']??'',
    KhachID: map['KhachID']??0,
    MaKhach: map['MaKhach']??'',
    TinXL: map['TinXL']??''
  );
  String sqlLoadTin(String ngay)=>'''
    SELECT b.TinXL, c.MaKhach, a.ID as ID, a.Ngay as Ngay
    FROM (TXL_TinNhan a JOIN TXL_TinNhanCT b on a.ID = b.TinNhanID AND a.Ngay = '$ngay') 
    JOIN TDM_Khach c on c.ID = a.KhachID
  ''';

}