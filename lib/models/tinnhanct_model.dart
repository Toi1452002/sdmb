// ignore_for_file: non_constant_identifier_names

class TinNhanChiTietModel{
  int? ID;
  int TinNhanID;
  String TinXl;


  TinNhanChiTietModel({this.ID, this.TinNhanID = 0, this.TinXl = ''});

  Map<String, dynamic> toMap()=>{
    'ID':ID,
    'TinNhanID':TinNhanID,
    'TinXL':TinXl
  };

  factory TinNhanChiTietModel.fromMap(Map<String, dynamic> map)=>TinNhanChiTietModel(
    ID: map['ID'],
    TinNhanID: map['TinNhanID'],
    TinXl: map['TinXL']
  );
}