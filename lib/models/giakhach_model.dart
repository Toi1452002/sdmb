// ignore_for_file: non_constant_identifier_names

class GiaKhachModel{
  int? ID;
  int? KhachID;
  String MaKieu;
  String MoTa;
  double Diem;
  double Thuong;

  GiaKhachModel({
    this.ID, this.KhachID, this.MaKieu = '', this.Diem = 0, this.Thuong = 0, this.MoTa = ''
  });

  Map<String, dynamic> toMap()=>{
    'ID': ID,
    'KhachID':KhachID,
    'MaKieu':MaKieu,
    'Diem':Diem,
    'Thuong':Thuong,
    // 'MoTa':MoTa
  };

  factory GiaKhachModel.fromMap(Map<String, dynamic> map)=>GiaKhachModel(
    ID: map['ID'],
    KhachID: map['KhachID'],
    MaKieu: map['Kieu']?? map['MaKieu'],
    Diem: map['Diem']??0,
    Thuong: map['Thuong']??0,
    MoTa: map['MoTaKieu']??''
  );

  String sqlLoadGia(int? id) => '''SELECT a.*, b.MoTaKieu 
        FROM TDM_GiaKhach a join T01_KieuChoi b 
        on a.KhachID = $id AND a.MaKieu = b.Kieu''';

}

