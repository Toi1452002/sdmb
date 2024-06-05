
// ignore_for_file: non_constant_identifier_names

import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/extension.dart';
import 'package:sdmb/models/tinphantichct_model.dart';

import 'md_HamChung.dart';
import 'md_HamSoDanh.dart';

List lst_SoDanh=[];
List<TinPhanTichCTModel> lst_Data= <TinPhanTichCTModel>[];
double fxac=0; double fvon=0; double ftrung=0;

Future<List<TinPhanTichCTModel>> PhanTichChuoiTin(String ChuoiTin,{int ID_Tin = 0,int ID_TinCT = 0}) async {
  fxac = 0; fvon = 0; ftrung = 0;
  lst_Data.clear(); double SoTien=0.0; String sTienDanh;
  ChuoiTin = strip(ChuoiTin);
  List lstChuoitach = ChuoiTin.split('.');
  List lsKieuDanh=[];
  for (int i=0;i<lstChuoitach.length;i++){
    if (tup_KieuDanh.contains(lstChuoitach[i])){
      if (tup_KieuDanh.contains(lstChuoitach[i]) && !tup_KieuDanh.contains(lstChuoitach[i+1])) lsKieuDanh.clear();
      lsKieuDanh.add(lstChuoitach[i]);
      lst_SoDanh.clear(); SoTien=0.0;
    }else if (isNumeric(lstChuoitach[i])) lst_SoDanh.add(lstChuoitach[i]);
    else {
      sTienDanh=lstChuoitach[i];

      SoTien=double.parse(LaySoTien(sTienDanh));
    }
    //ghi so lieu vao table TXL_TinPhanTichCT
    if (lsKieuDanh.length>0 && lst_SoDanh.length>0 && SoTien>0){
      for (var x in lsKieuDanh)
      {
        await GhiSoDanh(ID_Tin, ID_TinCT, x, SoTien);
      }

      lst_SoDanh.clear();
      SoTien=0;
    }
  }
  return lst_Data;
}

GhiSoDanh(int? ID_Tin, int? ID_TinCT, String sKieuDanh, double SoTien)async{
  ConnectDB db = ConnectDB();
  String Ngay= await db.getCell("Ngay","TXL_TinNhan","ID=$ID_Tin");
  Ngay=Ngay.replaceAll('/','-');
  int iMaKH= await db.getCell("KhachID", "TXL_TinNhan", "ID=$ID_Tin");
  bool bXien = false, bXien2 = false, bXien3 = false, bXien4 = false;
  for (String SoDanh in lst_SoDanh){
    double TyLeCo = 0, TyLeThuong=0,TienXac = 0, TienVon = 0,TienTrung=0;
    int iSLcon=1,iSLtrung=0;
    String SoTrung='';

    switch (sKieuDanh){
      case 'lo':
        iSLcon = 27;
        TyLeCo = await LayTyLe(iMaKH, 'lo') / 27;
        TyLeThuong = await LayTyLe(iMaKH, 'lo', 2);
        iSLtrung =  await do_KQ(Ngay, SoDanh, []); //[] la do het 27 lo
        if (iSLtrung > 0 && await db.getCell("GiaTri", "T00_TuyChon", "Ma='lo'") > 0)
          if (iSLtrung > await db.getCell("GiaTri", "T00_TuyChon", "Ma='lo'"))
            iSLtrung = await db.getCell("GiaTri", "T00_TuyChon", "Ma='lo'");
        break;
      case 'de':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh,['1']);//1 lay 2 so sau, 0 lay 2 so dau, '1'=DB
        break;
      case '3cang':
        TyLeCo = await LayTyLe(iMaKH, '3c');
        TyLeThuong = await LayTyLe(iMaKH, '3c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['1']);//#1=db
        if (iSLtrung==0 && await db.getCell("au3c", "TDM_Khach", "ID="+ iMaKH.toString() +"")>0) { //neu k trúng dò an ủi
          iSLtrung = await do_KQ(Ngay, SoDanh.substring(SoDanh.length-2), ['1']);
          TyLeThuong = await db.getCell("au3c", "TDM_Khach", "ID=" + iMaKH.toString() + "");
        }
        break;
      case 'l3c':
        iSLcon = 27;
        TyLeCo = await LayTyLe(iMaKH, 'l3c')/27;
        TyLeThuong = await LayTyLe(iMaKH, 'l3c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh,[]);
        break;
      case 'nt3c':
        TyLeCo = await LayTyLe(iMaKH, '3c');
        TyLeThuong = await LayTyLe(iMaKH, '3c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh,['2']);//2=giai nhat
        break;
      case '4cang':
        TyLeCo = await LayTyLe(iMaKH, '4c');
        TyLeThuong = await LayTyLe(iMaKH, '4c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['1']);//1=db
        break;
      case 'dg':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        //iSLtrung = do_KQ(Ngay, SoDanh, ['1'],0);//0: so phia truoc
        iSLtrung = await do_KQ(Ngay, SoDanh, ['1'], soDau: true);
        break;
      case 'dgn':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        //iSLtrung = do_KQ(Ngay, SoDanh, ['2'], 0);//   0: so phia truoc
        iSLtrung = await do_KQ(Ngay, SoDanh, ['2'], soDau: true);
        break;
      case 'nhat' || 'gn' || 'nt':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['2']);//#2=g1
        break;
      case 'nhi':
        iSLcon = 2;
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['3','4']);
        break;
      case 'g21':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['3']);//#giai2-1
        break;
      case 'g22':
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['4']);//#giai 2-2
        break;
      case 'lod':
        iSLcon = 27;
        TyLeCo = await LayTyLe(iMaKH, 'lo')/27;
        TyLeThuong = await LayTyLe(iMaKH, 'lo', 2);
        //iSLtrung = do_KQ(Ngay, SoDanh,[], 0);
        iSLtrung = await do_KQ(Ngay, SoDanh,[],soDau: true);
        break;
      case 'tc' || '2cua':
        iSLcon=2;
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh,['1','2']);
        break;
      case '4cua':
        iSLcon = 4;
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['1','2','3','4']);
        break;
      case 'dd':
        iSLcon = 5;
        TyLeCo = await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['1','24','25','26','27']);
        break;
      case 'dau':
        iSLcon = 4;
        TyLeCo =await LayTyLe(iMaKH, '2c');
        TyLeThuong = await LayTyLe(iMaKH, '2c', 2);
        iSLtrung = await do_KQ(Ngay, SoDanh, ['24','25','26','27']);
        break;
      case 'xien':
        bXien=true;
        switch (lst_SoDanh.length){
          case 2:
            TyLeCo =await LayTyLe(iMaKH, 'x2'); bXien2 = true;
            SoDanh = lst_SoDanh[0] + '.' + lst_SoDanh[1];
            break;
          case 3:
            TyLeCo = await LayTyLe(iMaKH, 'x3'); bXien2 = true; bXien3 = true;
            SoDanh = lst_SoDanh[0] + '.' + lst_SoDanh[1] + '.' + lst_SoDanh[2];
            break;
          case 4:
            TyLeCo = await LayTyLe(iMaKH, 'x4'); bXien2 = true; bXien3 = true; bXien4 =true;
            SoDanh = lst_SoDanh[0] + '.' + lst_SoDanh[1] + '.' + lst_SoDanh[2] + '.' + lst_SoDanh[3];
        }
        int x1 = 0, x2 = 0,  x3 = 0, x4 = 0;  // xet an ui xien 3 va 4
        x1= await do_KQ(Ngay, lst_SoDanh[0],[]);//#co 1 bien list lưu cặp số
        if (x1>0) { // #nếu số thứ nhất trúng, thì dò tiep x2
          x2= await do_KQ(Ngay, lst_SoDanh[1],[]);
          if (x2>0){
            iSLtrung = 1;
            if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xien'") != 1)
              if (x1>1 && x2>1) iSLtrung=((x1+x2)/2).toInt();
            TyLeThuong =await LayTyLe(iMaKH, 'x2', 2);
            if (bXien3){
              iSLtrung = 0;// #SoTrung = ''
              x3 = await do_KQ(Ngay, lst_SoDanh[2],[]);
              if (x3>0){
                iSLtrung = 1;
                if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xien'") != 1)
                  if (x1 > 1 && x2 > 1 && x3>1) iSLtrung = ((x1 + x2 + x3) / 3).toInt();
                TyLeThuong = await LayTyLe(iMaKH, 'x3', 2);
                if (bXien4){
                  iSLtrung = 0;
                  x4 = await do_KQ(Ngay, lst_SoDanh[3],[]);
                  if (x4>0){
                    iSLtrung = 1;
                    if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xien'") != 1)
                      if (x1 > 1 && x2 > 1 && x3 > 1 && x4 > 1) iSLtrung = ((x1 + x2 + x3 + x4) / 4).toInt();
                    TyLeThuong = await LayTyLe(iMaKH, 'x4', 2);
                  }
                }
              }
            }
          }
        }
        //xet xiên nháy (vd 01.02->01.01 or 02.02)
        if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xn'") > 0) {
          if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xn'") >= 2) {
            x2 = await do_KQ(Ngay, lst_SoDanh[1], []);
            if (x1 > 1 || x2 > 1) {
              iSLtrung = ((x1 + x2) / 2).toInt();
              TyLeThuong =await LayTyLe(iMaKH, 'x2', 2);
            }
          }
          if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xn'") >= 3){
            x3 = await do_KQ(Ngay, lst_SoDanh[2], []);
            if (x1>2 || x2>2 || x3>2) {
              iSLtrung = ((x1 + x2 + x3) / 3).toInt();
              TyLeThuong =await LayTyLe(iMaKH, 'x3', 2);
            }
          }
          if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xn'") == 4){
            x4 =await do_KQ(Ngay, lst_SoDanh[3], []);
            if (x1 > 3 || x2 > 3 || x3 > 3 || x4 > 3){
              iSLtrung = ((x1 + x2 + x3 + x4) / 4).toInt();
              TyLeThuong = await LayTyLe(iMaKH, 'x4', 2);
            }
          }
        }
        //xet an ui
        if ((x1==0 || x2 == 0 || x3 == 0) && await db.getCell("aux3", "TDM_Khach", "ID="+ iMaKH.toString() +"")>0 && lst_SoDanh.length==3>0){
          x2 =await do_KQ(Ngay, lst_SoDanh[1], []);
          x3 =await do_KQ(Ngay, lst_SoDanh[2], []);
          List lstTrung = [x1, x2,x3];
          int dem = 0;
          for (var x in lstTrung){
            if (x > 0) dem ++;
            if (dem == 3) break;
          }
          if (dem == 2) {
            TienTrung = await db.getCell("aux3", "TDM_Khach", "ID="+ iMaKH.toString() +"") * SoTien;
          }
        }
        if ((x1==0 || x2 == 0 || x3 == 0 || x4==0) && await db.getCell("aux3", "TDM_Khach", "ID=$iMaKH")>0 && lst_SoDanh.length==4>0){
          x2 = await do_KQ(Ngay, lst_SoDanh[1], []);
          x3 = await do_KQ(Ngay, lst_SoDanh[2], []);
          x4 = await do_KQ(Ngay, lst_SoDanh[3], []);
          List lstTrung=[x1,x2,x3,x4];
          int dem=0;
          for (var x in lstTrung){
            if (x>0) dem++;
            if (dem==3) break;
          }
          if (dem==3) TienTrung= await db.getCell("aux3", "TDM_Khach", "ID=$iMaKH")*SoTien*3;
        }
    }
    TienXac = SoTien;
    TienVon = double.parse((iSLcon * TienXac * TyLeCo).toStringAsFixed(2));
    if (iSLtrung>0)  TienTrung = TyLeThuong * SoTien * iSLtrung;
    if (sKieuDanh.isNotEmpty){
      Luu_DL(ID_Tin, ID_TinCT, sKieuDanh, SoDanh, TienXac, TienVon, iSLtrung, TienTrung);
    }
    if (bXien) break;
  }
}
Luu_DL(ID_Tin, ID_TinCT, sKieuDanh, SoDanh, TienXac, TienVon, iSLtrung, TienTrung){
  fxac+=TienXac; fvon+=TienVon; ftrung+=TienTrung;
  lst_Data.add(TinPhanTichCTModel(
    MaKieu: sKieuDanh,
    SoDanh: SoDanh,
    TienXac: TienXac,
    TienVon: TienVon,
    TienTrung: TienTrung,
    SoLanTrung: iSLtrung,
    TinNhanCT: ID_TinCT,
    MaTin: ID_Tin,
  ));
  //tuong tu mien nams
  //  print("ID: $ID_Tin || SoDanh: $SoDanh || KieuDanh: $sKieuDanh || TienXac: $TienXac || Von: $TienVon || Trung: $TienTrung");
}
ChuyenTin(String sTin) async {
  ConnectDB db = ConnectDB();
  sTin = sTin.toLowerCase();
  sTin=strip(sTin);
  List<String> lst_Tin = sTin.split('.');
  String st = '',  sGhep = '',  sKieu = '',  sSoXien = '', tien='';
  //chen so tien cho xien.01.02.xien.03.04.x10
  List<String> lstTmp=lst_Tin;
  int vt=0, i=0;
  for (String x in lst_Tin){
    //tach thong cua
    vt++;
    if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='ttc'") == 1)
      if (x=='tc') lstTmp[i]='de.gn';
    if (x=='xien') sKieu=x;
    if (sKieu=='xien'){
      int j=i;
      while (tien==''){
        String y=lst_Tin[j];
        if (y.substring(0,1)=='x' && isNumeric(y.substring(1,2))) tien=y;
        j++;
      }
    }
    if (x.substring(0,1) == 'x' && i>1)
      if (isNumeric(x.substring(1,2))){
        tien='';sKieu='';
      }else if(isNumeric(lst_Tin[i-1]) && lst_Tin[i]=='xien'){
        lstTmp.insert(vt-1,tien);
        vt++;
      }
  }
  lstTmp=LoaiBoPhanTuRong(lstTmp);
  lst_Tin=lstTmp;
  //xet SoDanh Bộ
  if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='bo'") == 1){
    bool bCo_Sodanh_bo = false;
    int i = 0;
    for (String x in lst_Tin){
      if (x.length>1 &&  (x.substring(0,2) == 'bo' || x.substring(0,2) == 'he' || (x.length>2 && x.substring(0,3) == 'day')) && isNumeric(x.substring(x.length-2))){
        bCo_Sodanh_bo = true;
        i++; continue;
      }
      if (isNumeric(x) && x.length==2 && bCo_Sodanh_bo) lst_Tin[i] = 'bo' + x;
      if (! isNumeric(x) || x.length!=2) bCo_Sodanh_bo = false;
      i++;
    }
  }

  i-=1; String x='';
  while (i<lst_Tin.length){
    i++;
    if (i==lst_Tin.length) break;
    x=lst_Tin[i];
    st+='.';
    if (tup_KieuDanh.contains(x)){
      sKieu = x;
      if (sKieu != 'xq') st = st + sKieu;
      continue;
    }
    if(x.length>2 && x[0] != 'x'){
      for(String sdb in tup_SoDanhBien){
        if(x.contains(sdb)){
          if(x.lastChars(2).isNumeric){
            sGhep = x.substring(0, x.length-2);
          }else if(x.lastChars(1).isNumeric){
            sGhep =  x.substring(0, x.length-1) ;
          }
          break;
        }

      }
    }



    if (isNumeric(x)) {
      if (x.length == 3 && !['3cang', 'l3c', 'nt3c', 'xq'].contains(sKieu)) {
        if (['lo', 'de', 'xien', 'dg', 'gn', 'lod', 'nt', 'tc', 'de.gn', 'dgn']
            .contains(sKieu)) st = st + Tach3con(x); // tach 131=13.31
      } else if (x.length == 1) {
        x = sGhep + x;
      } // dau2.3.5 ghep dau vao dau3, dau5
      else {
        if (sKieu == 'xq') {
          if (x.length == 3) {
            sSoXien = '.${Tach3con(x)}';
          }
          else {
            sSoXien += '.$x';
          }
        } else st += x;
      }
      // continue; T đóng
    }
    if(x.substring(0,1)=='x'){
      if (sKieu=='xq') {
        if (await db.getCell("GiaTri", "T00_TuyChon", "Ma='xq'") == 1)
          {
            st = st + DaVong(strip(sSoXien), LaySoTien(x));
          }

        else { //neu gap x10k thi khong duoc x he so
          if (x.substring(x.length - 1) == 'k')
            st = st + XienQuay(strip(sSoXien), LaySoTien(x));
          else {
            String sotien = LaySoTien(x);
            int giatri = await db.getCell("GiaTri", "T00_TuyChon", "Ma='xxq'");
            st = st + XienQuay(strip(sSoXien), (sotien * giatri).toString());

          }
        }
      }else{
        if (sKieu=='xien') {
          String sotien = LaySoTien(x);
          int giatri = await db.getCell("GiaTri", "T00_TuyChon", "Ma='xxien'");
          st = st + x.substring(0, 1) + (sotien * giatri).toString();
        }else st = st + x;
      }
      sSoXien='';
      continue;
    }
    //ham so hằng
    // if (await dCount("T01_TuKhoa",Condition: "CumTu='"+ x +"'")>0) st = st + await dLookup("ThayThe","T01_TuKhoa","CumTu='"+ x +"'");
    if(await db.dCount("T01_TuKhoa",Condition: "CumTu='$x'") >0  ){
      // st = st + await dLookup("ThayThe","T01_TuKhoa","CumTu='"+ x +"'");
      st = st + await db.getCell("ThayThe","T01_TuKhoa","CumTu='$x'");
    }
    String N='';
    while (true){
      if (x.substring(0,1)=='x' && isNumeric(x.substring(1,2))) break;
      if (x.length>11 && x.substring(0,12) == 'tongchanduoi' && isNumeric(x.substring(x.length-1))){
        if (lst_Tin[i].length > 1){
          if (isNumeric(lst_Tin[i].substring(12)))
            N = lst_Tin[i].substring(12);
        }else N = lst_Tin[i];
        st = st +TongChanDuoi(N);
      }else if (x.length>11 && x.substring(0,12) == 'tongchantren' && isNumeric(x.substring(x.length-1))){
        if (lst_Tin[i].length > 1){
          if (isNumeric(lst_Tin[i].substring(12))) N = lst_Tin[i].substring(12);
        } else N = lst_Tin[i];
        st = st + TongChanTren(N);
      }else if(x.length>9 && x.substring(0,10)=='tongleduoi'&& isNumeric(x.substring(x.length-1))){
        if (lst_Tin[i].length > 1){
          if (isNumeric(lst_Tin[i].substring(10))) N = lst_Tin[i].substring(10);
        } else N = lst_Tin[i];
        st = st + TongLeDuoi(N);
      }else if(x.length>9 && x.substring(0,10)=='tongletren'&& isNumeric(x.substring(x.length-1))){
        if (lst_Tin[i].length > 1){
          if (isNumeric(lst_Tin[i].substring(10))) N = lst_Tin[i].substring(10);
        }else N = lst_Tin[i];
        st = st + TongLeTren(N);
      }else if(x.length>7 && x.substring(0,8)=='tongduoi'&& isNumeric(x.substring(x.length-1))){
        if (lst_Tin[i].length > 1){
          if (isNumeric(lst_Tin[i].substring(8))) N = lst_Tin[i].substring(8);
        }else N = lst_Tin[i];
        st = st + TongDuoi(N);
      }else if(x.length>7 && x.substring(0,8)=='tongtren'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(8))) N = lst_Tin[i].substring(8);
        } else N = lst_Tin[i];
        st = st + TongTren(N);
      }else if(x.length>8 && x.substring(0,9)=='tongkchia'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(9))) N = lst_Tin[i].substring(9);
        } else N = lst_Tin[i];
        st = st + TongkChia(N);
      }else if(x.length>7 && x.substring(0,8)=='tongchia'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(8))) N = lst_Tin[i].substring(8);
        } else N = lst_Tin[i];
        st = st + TongChia(N);
      }else if(x.length>3 && x.substring(0,4)=='tong'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(4))) N = lst_Tin[i].substring(4);
        } else N = lst_Tin[i];
        st = st + Tong(N);
      }else if(x.length>5 && x.substring(0,6)=='daudit'&& isNumeric(x.substring(x.length-1)) && (x.length>7 && x.substring(0,8)!='dauditbt')) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(6))) N = lst_Tin[i].substring(6);
        } else N = lst_Tin[i];
        st = st + DauDit(N);
      }else if(x.length>2 && x.substring(0,3)=='dau'&& isNumeric(x.substring(x.length-1))&& x.length<5) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(3))) N = lst_Tin[i].substring(3);
        } else N = lst_Tin[i];
        st = st + Dau(N);
      }else if(x.length>2 && x.substring(0,3)=='dit'&& isNumeric(x.substring(x.length-1)) && x.length<5) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(3))) N = lst_Tin[i].substring(3);
        } else N = lst_Tin[i];
        st = st + Dit(N);
      }else if(x.length>4 && x.substring(0,5)=='chamt'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(5))) N = lst_Tin[i].substring(5);
        } else N = lst_Tin[i];
        st = st + ChamT(N);
      }else if(x.length>5 && x.substring(0,6)=='chambt'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(6))) N = lst_Tin[i].substring(6);
        } else N = lst_Tin[i];
        st = st + ChamBT(N);
      }else if(x.length>3 && x.substring(0,4)=='cham'&& isNumeric(x.substring(x.length-1))) {
        if (lst_Tin[i].length > 1) {
          if (isNumeric(lst_Tin[i].substring(4))) N = lst_Tin[i].substring(4);
        } else N = lst_Tin[i];
        st = st + Cham(N);
      }
      if (i<lst_Tin.length-1){
        if (lst_Tin[i+1]==1){
          i++;
          st+='.';
        }else break;
      }
    }

    //xy=2so
    // print();
    if (x.length>2 && x.substring(0,3)=='dan' && isNumeric(x.substring(x.length-2))) st = st + Dan(x.substring(x.length-2));
    if (x.substring(0,2)=='so' && isNumeric(x.substring(x.length-2))) st = st + SoXY(x.substring(x.length-2));
    else if((['bo','he'].contains(x.substring(0,2)) || (x.length>2 && x.substring(0,3)=='day'))&& isNumeric(x.substring(x.length-2))) st+=Bo(x.substring(x.length-2));
    // elif x[:8] == 'dauditbt' and x[-(len(lst_Tin[i]) - 8):].isdigit(): st = st + Module.md_HamSoDanh.DauDitBT(str(x[-(len(lst_Tin[i]) - 8):]))
    else if(x.length>5 && x.substring(0,6)=='daudit' && isNumeric(x.substring(6))) st+=DauDit(x.substring(6));
    else if(x.length>7 && x.substring(0,8)=='dauditbt' && isNumeric(x.substring(8))) st+=DauDitBT(x.substring(8));
    else if(x.length>4 && x.substring(0,4)=='chia' && x.substring(5,7)=='du'){
      if ( isNumeric(x.substring(4,5)) && isNumeric(x.substring(7,8))) st += ChiaAduB(x.substring(4,5), x.substring(7,8));
    }else if(x.length>7 && x.substring(0,3)=='dau'&& x.indexOf('ghdit', 3)!=-1 &&  x.substring(x.indexOf('ghdit', 3),x.indexOf('ghdit', 3)+5)=='ghdit'){
      String ab = x.substring(3,x.indexOf('ghdit', 3));
      String xy = x.substring(x.indexOf('ghdit', 3) + 5,x.length);
      st = st + DauGhDit(ab, xy);
    }else if(x.length>7 && x.substring(0,3)=='dau' && x.substring(x.indexOf('ghbkdit', 3),x.indexOf('ghbkdit', 3)+7)=='ghbkdit'){
      String ab = x.substring(3,x.indexOf('ghbkdit', 3));
      String xy = x.substring(x.indexOf('ghbkdit', 3) + 7,x.length);
      st = st + DauGhBKdit(ab, xy);
    }
  }
  st = lstrip(st);
  // print(LoaiBoDauCham(st));
  return LoaiBoDauCham(st);
}

Bang_KQSX(String Ngay, int SoCon, SoDuoi, {required List<String> TTgiai, bool soDau = false}) async{//TT thu tu giai
  final List<Map> data;

  if (TTgiai.isEmpty) {
    data = await ConnectDB().getList(sql: "SELECT KQso FROM TXL_KQXS WHERE Ngay='$Ngay'");
  } else {
    // data = await ConnectDB().getList(sql: "SELECT KQso FROM TXL_KQXS WHERE Ngay='$Ngay' AND TT=$TTgiai");
    data = await ConnectDB().getList(sql: "SELECT KQso FROM TXL_KQXS WHERE Ngay='$Ngay' AND TT in (${TTgiai.join(',')})");
  }
  // print('Giai: $TTgiai || So $SoCon || SoDuoi: $SoDuoi || data: $data');
  List lstKQ=[];String s='';
  for (var x in data){
    s = x['KQso'].toString();
    if(!soDau){
      if (SoDuoi==1) s=s.lastChars(SoCon);
      // else s=s.substring(0,SoCon);
      // else s=s.lastChars(SoCon);
      else if(s.length>=SoCon)s=s.lastChars(SoCon);
    }else{
      s = s.substring(0,SoCon);
    }

    // else print("$s---$SoCon");
    if (isNumeric(s)) lstKQ.add(s);
  }
  return lstKQ;
}

 Future<int> do_KQ (String Ngay, String So, List<String> MaGiai, {bool soDau = false}) async{
  List lstSo = []; int SoDuoi;
  if(MaGiai.isEmpty){
    MaGiai = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27'];
  }

  if(MaGiai.isNotEmpty){
    if (MaGiai.length==1) SoDuoi=1;
    else SoDuoi=MaGiai[1].toInt;


    if (MaGiai[0].toString().isEmpty) {
      lstSo+=Bang_KQSX(Ngay, So.length, SoDuoi,TTgiai: [], soDau: soDau);
    } else {
      // for (int x in MaGiai) {
        lstSo += await Bang_KQSX(Ngay,So.length,SoDuoi,TTgiai: MaGiai, soDau: soDau);
    }
      // }
  }
  return demPhanTu_list(lstSo,So);//lstSo.count(So)
}

Future<double> LayTyLe(int MaKH,String sKieu,[Diem=1]) async{
  double TL;
  if (Diem==1) TL=  await ConnectDB().getCell("Diem", "TDM_GiaKhach", "KhachID="+ MaKH.toString() +" AND MaKieu='"+ sKieu +"'");
  else TL= await ConnectDB().getCell("Thuong", "TDM_GiaKhach", "KhachID="+ MaKH.toString() +" AND MaKieu='"+ sKieu +"'");
  return TL;
}