// ignore_for_file: non_constant_identifier_names

class KhachModel{
  int? ID;
  String MaKhach;
  int kDauTren;
  double Hoi;
  int au3c;
  int aux3;
  String SDT;
  bool copy;
  KhachModel({
    this.ID,
    this.MaKhach = '',
    this.kDauTren = 0,
    this.au3c = 0,
    this.aux3 = 0,
    this.Hoi = 0,
    this.SDT  = '',
    this.copy = false
  });

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'MaKhach':MaKhach,
    'kDauTren':kDauTren,
    'au3c':au3c,
    'aux3':aux3,
    'Hoi':Hoi,
    'SDT':SDT
  };

  factory KhachModel.fromMap(Map<String, dynamic> map)=>KhachModel(
    ID:  map['ID'],
    au3c: map['au3c'],
    aux3: map['aux3'],
    Hoi: map['Hoi'],
    kDauTren: map['kDauTren']??0,
    MaKhach: map['MaKhach'],
    SDT: map['SDT']??''
  );
}