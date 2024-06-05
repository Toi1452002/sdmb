import 'package:sdmb/config/database/connectDB.dart';
import 'package:sdmb/config/extension.dart';

import 'md_HamDB.dart';
import 'md_HamChung.dart';

String gl_sLoiTin = '';
List gl_lst_ViTriLoi = [];
bool gl_bMaDai = false;
//x123,00,5k, xet 123,00,5k
KiemTraLoiTien(String sTien) {
  // print(sTien);
  if (sTien.substring(0, 1) == '0' &&
      sTien.length > 1 &&
      sTien.substring(1, 2) != ',') return true;
  if (sTien.length == 1 && !sTien.isNumeric) return false;
  // if (isNumeric(sTien)) return null;
  bool result = false;
  int SoLanDauPhay = 0;
  if (['d', 'n', 'k'].contains(sTien.substring(sTien.length - 1))) {
    for (int i = 0; i < sTien.length - 1; i++) {
      if (!isNumeric(sTien[i])) {
        if (sTien[i] != ',')
          result = true;
        else {
          SoLanDauPhay += 1;
          if (SoLanDauPhay > 1)
            result = true;
          else
            result = false;
        }
      } else {
        result = false;
      }
    }
  }
  // if (isNumeric(sTien.substring(0,sTien.length-1))) return null;
  // else

  else
  // if (! isNumeric(sTien.substring(sTien.length-1))) return true;
  {
    if (!isNumeric(sTien))
      result = true;
    else
      for (int i = 0; i < sTien.length; i++)
        if (!isNumeric(sTien[i])) {
          if (sTien[i] == ',')
            result = true;
          else {
            SoLanDauPhay += 1;
            if (SoLanDauPhay > 1)
              result = true;
            else
              result = false;
          }
        } else
          result = false;
  }

  return result;
}

KiemLoiTin(String sTin) async {
  int i = 0;
  gl_lst_ViTriLoi.clear();
  gl_bMaDai = false;
  gl_sLoiTin = '';
  try {
    String sLoiTin = '';
    bool bLoiTin = false;
    List lst_vtLoi = [];
    sTin = strip(sTin);
    sTin = sTin.toLowerCase();
    lst_vtLoi.clear();
    List<String> lst_Tin = sTin.split('.');
    String st = sTin;
    //1. Tách vào lst so sánh kieuDanh, so danh trong cum tu dien Cac so danh dacbiet, kiem tra sotien x150d,k,n
    //dau tien phai la kieu danh
    if (!tup_KieuDanh.contains(lst_Tin[0])) {
      sLoiTin = lst_Tin[0] + ' không phải kiểu đánh';
      luu_vitri_Loi(0, sLoiTin);
      return true;
    }
    //cuoi cung phai la so tien
    if (lst_Tin[lst_Tin.length - 1].substring(0, 1) != 'x') {
      sLoiTin = lst_Tin[lst_Tin.length - 1] + ' không phải số tiền';
      luu_vitri_Loi(lst_Tin.length - 1, sLoiTin);
      return true;
    }

    List<Map> lstSoHang = await ConnectDB()
        .getList(sql: "SELECT CumTu FROM T01_TuKhoa WHERE SoDanhHang=1");
    List lstSo = [];
    for (var x in lstSoHang) lstSo.add(x);
    List tup_SoDanhHang = lstSo.map((e) => e['CumTu']).toList();
    //kiem tra it nhat 1 cặp, và sau nó phải la sotien
    String sKieu = '';
    int iCoXq = 0, iCapXien = 0;
    for (var x in lst_Tin) {
      if (tup_KieuDanh.contains(x)) {
        if (x == 'xien') iCapXien = 0;
        if (x == 'xq') iCoXq = 1;
        sKieu = x;
      } else if (tup_SoDanhHang.contains(x)) {
        if (iCoXq > 1) {
          lst_vtLoi.add(i);
          if (!bLoiTin) {
            bLoiTin = true;
            sLoiTin = 'Cặp số xiên quay phải đi liền với số tiền : ' + x;
          }
        } else
          iCoXq = 0;
        i++;
        continue;
      } else if (isNumeric(x)) {
        if (x.length == 1) {
          //xet xem phia truoc co sodanh dacbiet k.
          int j = i - 1;
          bool bLoi2so = false;
          while (j >= 0) {
            if (['lo', 'de', 'xien', 'xq', 'dau'].contains(lst_Tin[j])) {
              bLoi2so = true;
              break;
            }
            if (isNumeric(lst_Tin[j]) && lst_Tin[j].length == 2) {
              //de.75.x50.85.3.5.20.x15
              bLoi2so = true;
              break;
            }
            if (!isNumeric(lst_Tin[j])) {
              if (lst_Tin[j].substring(0, 1) == 'x') bLoi2so = true;
              break;
            }
            j--;
          }
          if (bLoi2so) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = x + ' : không chấp nhận số đánh là 1 con';
            }
          }
          i++;
          continue;
        }
        if (iCoXq >= 1) iCoXq += 1;
        if (['de', 'lo', 'g21', 'g22', 'tc', 'nt', 'gn', 'nhat']
            .contains(sKieu)) {
          if (x.length > 3) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = x + ' : không chấp nhận > 3 con';
            }
            i++;
            continue;
          }
          if (x.length == 3) {
            if (x.substring(0, 1) != x.substring(x.length - 1)) {
              lst_vtLoi.add(i);
              if (!bLoiTin) {
                bLoiTin = true;
                sLoiTin = x + ' : không chấp nhận 3 con';
              }
            }
          }
        }
        if (['3cang', 'nt3c'].contains(sKieu)) {
          if (x.length != 3) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = x + ' : phải là sổ 3 con';
            }
            i++;
            continue;
          }
        }
        if (sKieu == '4cang') {
          if (x.length != 4) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = x + ' : phải là sổ 4 con';
            }

            i++;
            continue;
          }
        }
        if (sKieu == 'xien') {
          iCapXien += 1;
          if (x.length == 3) iCapXien += 1; //434
        }
        i++;
        continue;
      } else {
        //kiem tra dau7,9 , kiem tra ben trong co dau , ma k phai la x0,5
        if (x.indexOf(',') != -1) {
          if (x.substring(0, 1) != 'x' || !isNumeric(x.substring(1, 2))) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'sai dấu phẩy ở vị trí ' + x;
            }
          }
        }
        if (x.substring(0, 1) == 'x') {
          if (sKieu == 'xien' && iCapXien < 2) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'xiên thiếu cặp số trước ' + x;
            }
          }
          if (iCapXien > 4) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'xiên thừa số trước ' + x;
            }
          }
          //xien.12.23.x10.45.x10 (k bao loi nen thu tat sKieu='')
          iCapXien = 0;
          // if (  KiemTraLoiTien(x.substring(x.length-1))){
          if (KiemTraLoiTien(x.substring(1))) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'Sai số tiền : ' + x;
            }
          }
          if (1 < iCoXq && iCoXq < 3) {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'xiên quay ít nhất phải có 1 cặp số : ' + x;
            }
          } else
            iCoXq = 0;
          if (isNumeric(x.substring(x.length - 1))) {
            i++;
            continue;
          } else if (['d', 'n', 'k'].contains(x.substring(x.length - 1))) {
            i++;
            continue;
          } else {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'Số tiền sai quy cách : ' + x;
            }
          }
        } else {
          if (iCoXq > 1) {
            if (!bLoiTin) {
              lst_vtLoi.add(i);
              bLoiTin = true;
              sLoiTin = 'Cặp số xiên quay phải đi liền với số tiền : ' + x;
            }
          } else
            iCoXq = 0;
          bool bCoSoDanhBien = false;
          for (var y in tup_SoDanhBien) {
            if ((x.length > 3 &&
                    x.substring(0, 4) == 'chia' &&
                    x.substring(5, 7) == 'du') ||
                (x.length > 5 && x.substring(0, 6) == 'daudit')) {
              bCoSoDanhBien = true;
              break;
            }
            int vitri = x.indexOf(y);
            if (vitri != -1) {
              if (y == 'tong' && !isNumeric(x.substring(4, 5)) && vitri == 0) {
                //detong9, de.tong.5.7
                bCoSoDanhBien = true;
                break;
              }
              if (y == 'tong' && vitri > 0) {
                //detong9
                if (!bLoiTin && vitri > 0) {
                  lst_vtLoi.add(i);
                  bLoiTin = true;
                  sLoiTin = 'Không hiểu kiểu : ' + x;
                }
                break;
              } else {
                bCoSoDanhBien = true;
                if (x.length > vitri + y.length + 1 &&
                    !isNumeric(
                        x.substring(vitri + y.length, vitri + y.length + 1))) {
                  lst_vtLoi.add(i);
                  if (!bLoiTin) {
                    bLoiTin = true;
                    sLoiTin = 'số phải dính liền với ' + x;
                  }
                } else
                  break;
              }
            }
          }
          if (bCoSoDanhBien) {
            if (KtraLoi_SoDanhBien(x)) {
              lst_vtLoi.add(i);
              if (!bLoiTin) {
                bLoiTin = true;
                sLoiTin = 'Sai số ở gần :' + x;
              }
            }
          } else {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = x + ' không phải số đánh';
            }
          }
          //xet 123x10.123xq,123xien: bao loi dien dau . vao
          int vitri = x.indexOf('x');
          if (vitri > 0) {
            if (isNumeric(x.substring(vitri + 1, vitri + 2)) ||
                ['xq', 'xi'].contains(x.substring(vitri, vitri + 2))) {
              lst_vtLoi.add(i);
              if (!bLoiTin) {
                bLoiTin = true;
                sLoiTin = 'chèn dấu . trước :' + x;
              }
            } else {
              lst_vtLoi.add(i);
              if (!bLoiTin) {
                bLoiTin = true;
                sLoiTin = 'Không hiểu :' + x;
              }
            }
          }
        }
      }
      i++;
    }
    //#3. lỗi cú pháp
    //lst_vtLoi.clear()#khoi tao de tim loi cu phap
    int iKieuDanh = 0; //dem so lan kieu danh cho toi x_sotien
    for (i = 0; i < lst_Tin.length - 1; i++) {
      if (tup_KieuDanh.contains(lst_Tin[i])) sKieu = lst_Tin[i];
      //kieu danh k duoc lien ke
      if (tup_KieuDanh.contains(lst_Tin[i]) &&
          tup_KieuDanh.contains(lst_Tin[i + 1])) {
        lst_vtLoi.add(i);
        if (!bLoiTin) {
          bLoiTin = true;
          sLoiTin = '2 kiểu đánh không được liền kề ' +
              lst_Tin[i] +
              '.' +
              lst_Tin[i + 1];
        }
      }
      //so tien khong duoc lien ke
      if (lst_Tin[i].substring(0, 1) == 'x') {
        if (isNumeric(lst_Tin[i].substring(1, 2))) {
          sKieu = '';
          iKieuDanh = 0;
        }
        if (lst_Tin[i + 1].substring(0, 1) == 'x' &&
            isNumeric(lst_Tin[i + 1].substring(1, 2))) {
          lst_vtLoi.add(i);
          if (!bLoiTin) {
            bLoiTin = true;
            sLoiTin = '2 số tiền không được liền kề ' +
                lst_Tin[i] +
                '.' +
                lst_Tin[i + 1];
          }
        }
      }
      //Duyet cau truc kieu.so.tien
      if (tup_KieuDanh.contains(lst_Tin[i])) {
        iKieuDanh++;
        if (iKieuDanh > 1)
        // if(sKieu=='xien'){
        if (tup_KieuDanh.contains(sKieu)) {
          lst_vtLoi.add(i);
          if (!bLoiTin) {
            bLoiTin = true;
            sLoiTin = 'thiếu số tiền của kiểu đánh ' + lst_Tin[i];
          }
        }
        if (i < lst_Tin.length - 1) if (lst_Tin[i + 1].substring(0, 1) == 'x' &&
            isNumeric(lst_Tin[i + 1].substring(1, 2))) {
          lst_vtLoi.add(i);
          if (!bLoiTin) {
            bLoiTin = true;
            sLoiTin = 'thiếu số đánh giữa ' + lst_Tin[i] + '.' + lst_Tin[i + 1];
            i++;
            continue;
          }
        }
        if (iKieuDanh == 1) if (i < lst_Tin.length - 1) {
          //vi i duyet tới len() -1
          if (lst_Tin[i].substring(0, 1) == 'x' &&
              lst_Tin[i + 1].length > 1 &&
              isNumeric(lst_Tin[i + 1].substring(1, 2))) {
            iKieuDanh = 0;
            i++;
            continue;
          }
        } else {
          if (lst_Tin[i].substring(0, 1) != 'x') {
            lst_vtLoi.add(i);
            if (!bLoiTin) {
              bLoiTin = true;
              sLoiTin = 'thiếu số tiền của kiểu đánh ' + lst_Tin[i];
            }
          }
        }
      }
    }
    if (bLoiTin) {
      gl_sLoiTin = sLoiTin;
      gl_lst_ViTriLoi = lst_vtLoi;
    }
    return bLoiTin;
  } on Exception catch (e) {
    luu_vitri_Loi(i, 'tin có lỗi!');
    print('KiemLoiTin: $e');
    return true;
  }
}

luu_vitri_Loi(int vitri, String sMoTaLoi) {
  if (gl_sLoiTin == '') gl_sLoiTin = sMoTaLoi;
  gl_lst_ViTriLoi.add(vitri);
}

bool kt_soTien(String sKieu, int vt) {
  bool ktra = false;
  String tien = sKieu.substring(vt);
  if (tien[0] == '0' && tien[1] != ',') return true;
  if (sKieu.substring(0, 2) == 'db') {
    if (tien.indexOf('l') > 0) tien = tien.substring(tien.indexOf('l') + 1);
  }
  tien = tien.replaceAll(',', '');
  if (tien[tien.length - 1] == 'n') tien = tien.substring(1);
  if (isNumeric(tien)) ktra = true;
  return ktra;
}

//kiem tra xem so danh biến quy cách số đứng sau có đúng k
bool KtraLoi_SoDanhBien(String stSo) {
  if (stSo.length > 11 && stSo.substring(0, 12) == 'tongchanduoi') {
    if (!isNumeric(stSo.substring(12))) return true; //stSo[-(len(stSo) - 12):]
    if (stSo.substring(12).length > 1) return true;
  } else if (stSo.length > 9 &&
      (stSo.substring(0, 10) == 'tongleduoi' ||
          stSo.substring(0, 10) == 'tongletren')) {
    if (!isNumeric(stSo.substring(10))) return true;
    if (stSo.substring(10).length > 1) return true;
  } else if (stSo.length > 8 && stSo.substring(0, 9) == 'tongkchia') {
    if (!isNumeric(stSo.substring(9))) return true;
    if (stSo.substring(9).length > 1) return true;
  } else if (stSo.length > 7 && ['tongduoi', 'tongtren', 'tongchia', 'dauditbt'].contains(stSo.substring(0, 8))) {
    //#co truong hop tong10
    if (!isNumeric(stSo.substring(8))) return true;
    if(stSo.substring(0, 8) == 'dauditbt') return false;
    if (stSo.substring(8).length > 2) return true;
  } else if (stSo.length > 5 && stSo.substring(0, 6) == 'daudit') {
    if (!isNumeric(stSo.substring(6))) return true;
    if (stSo.substring(6).length > 1) return true;
  } else if (stSo.length > 5 && stSo.substring(0, 6) == 'chambt') {
    if (!isNumeric(stSo.substring(6))) return true;
    if (stSo.substring(6).length < 2) return true; //cham phai 2 con
  } else if (stSo.length > 4 && stSo.substring(0, 5) == 'chamt') {
    if (!isNumeric(stSo.substring(5))) return true;
    if (stSo.substring(5).length > 1) return true;
  } else if (stSo.length > 3 && stSo.substring(0, 4) == 'cham') {
    if (!isNumeric(stSo.substring(4))) return true;
    if (stSo.substring(4).length > 1) return true;
  } else if (stSo.length > 3 &&
      stSo.substring(0, 4) == 'chia' &&
      stSo.substring(5, 7) == 'du') {
    if (!isNumeric(stSo.substring(4, 5)) || !isNumeric(stSo.substring(7, 8)))
      return true;
  } else if (stSo.length > 2 && stSo.substring(0, 3) == 'dan') {
    if (!isNumeric(stSo.substring(3))) return true;
    if (stSo.substring(4).length > 2) return true;
  } else if (stSo.length > 2 &&
      stSo.indexOf('ghdit', 3) != -1 &&
      stSo.substring(0, 3) == 'dau' &&
      stSo.substring(stSo.indexOf('ghdit', 3), stSo.indexOf('ghdit', 3) + 5) ==
          'ghdit') {
    if (!isNumeric(stSo.substring(3, stSo.indexOf('ghdit', 3)))) return true;
    if (!isNumeric(stSo.substring(stSo.indexOf('ghdit', 3) + 5))) return true;
  } else if (stSo.length > 2 &&
      stSo.indexOf('ghdit', 3) != -1 &&
      stSo.substring(0, 3) == 'dau' &&
      stSo.substring(
              stSo.indexOf('ghbkdit', 3), stSo.indexOf('ghbkdit', 3) + 7) ==
          'ghbkdit') {
    if (!isNumeric(stSo.substring(3, stSo.indexOf('ghbkdit', 3)))) return true;
    if (!isNumeric(stSo.substring(stSo.indexOf('ghbkdit', 3) + 7))) return true;
  } else if (['so', 'bo', 'he'].contains(stSo.substring(0, 2)) ||
      stSo.substring(0, 3) == 'day') {
    if (!isNumeric(stSo.substring(2))) return true;
    if (stSo.substring(2).length > 2) return true;
  }
  return false;
}
