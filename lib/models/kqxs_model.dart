// ignore_for_file: non_constant_identifier_names

class KqxsModel{
  int? ID;
  int TT;
  String Ngay;
  String MaGiai;
  String KQso;

  KqxsModel({this.ID, this.TT = 0, this.Ngay= '', this.KQso = '',this.MaGiai = ''});

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'TT':TT,
    'Ngay':Ngay,
    'MaGiai':MaGiai,
    'KQso': KQso
  };

  factory KqxsModel.fromMap(Map<String, dynamic> map)=>KqxsModel(
      ID: map['ID']??0,
      MaGiai: map['MaGiai'],
      KQso: map['KQso'],
      Ngay: map['Ngay']??'',
      TT: map['TT']??0
  );

}