import 'package:sdmb/config/database/connectDB.dart';

import 'md_HamDB.dart';
import 'md_HamChung.dart';

Future<String> XuLyTin(String sTin) async{
  String st=sTin.toLowerCase();
  st=ThayKyTu_TV(st);
  st= await ThayCumTu(st);
  //[15:36, 23/12/2021] +84 36 514 5828: Ag.tn.45b15.
  if (st.indexOf('[')>=0 && st.indexOf(']')>0) st=st.replaceAll(st.substring(st.indexOf('['),st.indexOf(']')+1),'');
  if (st.indexOf('+')>0 && st.indexOf(':')>0)
    if (st.indexOf(':')-st.indexOf('+')<18) {
      st=st.replaceAll(st.substring(st.indexOf(':'),st.indexOf('+')+1), '');
    }
  //Loai bo ky tu dac biet 2 dau, loai bo ky tu lạ
  st=LoaiBo_KyTu_DB2dau(st);
  //Thay thế dấu . vào các vi trí cần thiết 19,171,72
  st=st.replaceAll(',','.');st=st.replaceAll(' ','.');st=st.replaceAll('-','.');
  //bỏ bớt 2 ky tự . va space gần nhau thành 1
  st=XoaBotKyTu(st,'.'); st=XoaBotKyTu(st,' ');
  //1.duyệt Kieu danh lo,de.. neu khong co dau . thi chèn vào
  for (var x in tup_KieuDanh){

      int i=0, vitri=0;
    while (vitri !=-1){
      if(i<=st.length){
        vitri= st.indexOf(x,i);
      }


      if (vitri>=0)

        if ( st.length>x.length+vitri && st.substring(x.length+vitri,x.length+vitri+1)!='.') {
          if (! (x=='lo' && st.substring(x.length+vitri,x.length+vitri+1)=='d')|| (x=='nt' && st.substring(x.length+vitri,x.length+vitri+2)=='3c')) {
            //ditchan có tc
            if (x!='dau' && x!='tc') {
              st=ChenKyTu(st, '.', vitri+x.length);
            }
          }
            }
      i+=vitri+1;
    }
  }
  //2.duyệt so danh hằng chan,le,chanchan... neu khong co dau . thi chèn vào
  // List<Map> lstSoHang=await layTable("SELECT CumTu FROM T01_TuKhoa WHERE SoDanhHang=1");
  List<Map> lstSoHang = await ConnectDB().getList(sql: "SELECT CumTu FROM T01_TuKhoa WHERE SoDanhHang=1");
  List tup_SoDanhHang = [];
  for (var x in lstSoHang) {
    tup_SoDanhHang.add(x['CumTu']);
  }
  for (var x in tup_SoDanhHang){
    int i=0, vitri=0;
    while (vitri!=-1){
      vitri=st.indexOf(x,i);
      if (vitri>=0)
        if (st.substring(x.length+vitri,x.length+vitri+1)!='.'){
          if (st.length>x.length+vitri+3 && st.substring(vitri,x.length+vitri+4)=='chanchan') st=ChenKyTu(st, '.', x.length+vitri+4);
          if (st.length>x.length+vitri+1 && st.substring(vitri,x.length+vitri+2)=='lele') st=ChenKyTu(st, '.', x.length+vitri+2);
        }
      i+=vitri+1;
    }


  }
  //3. duyệt so danh biến sớ, bộ ,tổngN... neu khong co dau . thi chèn vào

  for (var x in tup_SoDanhBien){
    int i=0, vitri=0;
    while (vitri!=-1){
      vitri=st.indexOf(x,i);
      if (vitri>=0)
        if (st.substring(x.length+vitri,x.length+vitri+1)=='.' && !isNumeric(st.substring(x.length+vitri+1,x.length+vitri+3))) {
          st=XoaKyTu(st, x.length+vitri);
        }
      i+=vitri + 1;
    }
  }

  //xoa dau chấm x.10k, x50.k, .x50.ng
  int vitri=0;

  while (vitri!=-1) {
    if(st.isEmpty)break;
    vitri = st.indexOf('x', vitri+1);
    if (st.length>vitri+1 && st.substring(vitri+1,vitri+2)=='.')
      if (vitri+2<st.length) {
        if (isNumeric(st.substring(vitri+2,vitri+3))) st=XoaKyTu(st, vitri+1);
      }
    //chen dấu . trước x
    if (st.length>vitri+1 && vitri!=-1 && st.substring(vitri,vitri+1)=='x')
    {
      if (st.substring(vitri-1,vitri)!='.') {
        st=ChenKyTu(st, '.', vitri);
      }
    }

    int j=vitri+1;
    while (j<=st.length-3){
      if (st.substring(j,j+1)=='.' && !['n','d','k'].contains(st.substring(j-1,j))){//x0.5k
        if (isNumeric(st.substring(j+1,j+2)) && !['2c','3c','4c'].contains(st.substring(j + 1,j + 3))) {
          int ch=j-1;//vt cham
          while (ch>0){
            if (st.substring(ch,ch+1)=='.') break;
            if (st.substring(ch,ch+1)=='x' && isNumeric(st.substring(ch+1,ch+2))) st=ThayKyTu(st, ',', j+1);
            ch--;
          }
        }
        if (['k','n'].contains(st.substring(j+1,j+2)) && st.substring(j+2,j+3)=='.'){
          XoaKyTu(st, j); break;
        }
      }
      if (j+1<st.length)
        if (st.substring(j+1,j+3)=='ng' && isNumeric(st.substring(j,j+1))) {
          st=XoaKyTu(st, j+2);break;
        }
      j++;
    }
  }
  //xet chan.chan=chanchan, le.le=lele



  List lstTin=st.split('.');
  for (int i=0;i<st.length;i++){
    if (i<lstTin.length-1){
      if (lstTin[i]=='chan' && lstTin[i]==lstTin[i+1]){
        lstTin[i]+='chan';
        lstTin.remove(lstTin[i+1]);
      }
      if (lstTin[i]=='le' && lstTin[i]==lstTin[i+1]){
        lstTin[i]+='le';
        lstTin.remove(lstTin[i+1]);
      }
      if (lstTin[i]=='') lstTin.remove(lstTin[i]);
    }
  }
  st=lstTin.join('.');
  print(LoaiBoDauCham(st));
  return LoaiBoDauCham(st);
}