import 'dart:ffi';
import 'md_HamChung.dart';

//cac số có tham biến
String SoXY(String xy){
  int ab=int.parse(xy);
  String st='';
  if (ab==42) st= '23.24.25.26.27.28.32.34.35.36.37.38.42.43.45.46.47.48.52.53.54.56.57.58.62.63.64.65.67.68.72.73.74.75.76.78.82.83.84.85.86.87';
  if (ab==44) st= '02.03.07.08.09.13.14.18.19.20.24.25.29.30.31.35.36.40.41.42.46.47.52.53.57.58.59.63.64.68.69.70.74.75.79.80.81.85.86.90.91.92.96.97';
  return st;
}

String Tong(N){
  int n=0;
  if (N.runtimeType !=int ) n=int.parse(N);
  else n=N;
  if (n==10) n=0;
  String st='';String So='';
  for (var i=0;i<10;i++)
    for (var j=0;j<10;j++){
      So=(i+j).toString();
      if (So[So.length-1]==n.toString()){
        So=i.toString()+j.toString();
        st=st+'.'+So;
        So='';
      }
    }
  return lstrip(st);
}

//tong chẵn dưới 10
String TongChanDuoi(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i+j)%2==0 && (i+j)<n)
        st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tong lẻ dưới 10
String TongLeDuoi(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i+j)%2==1 && (i+j)<n)
        st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tổng chẵn trên 10
String TongChanTren(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i+j)%2==0 && (i+j)>n)
        st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tổng lẻ trên 10
String TongLeTren(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i+j)%2==1 && (i+j)>n)
        st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tổng dưới n
String TongDuoi(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if (i+j<n) st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tổng trên n
String TongTren(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if (i+j>n) st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tổng chia N
String TongChia(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i + j) % n == 0) st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

//tong khong chia het N
String TongkChia(String N){
  int n=int.parse(N);
  //if (N.runtimeType !=int ) n=int.parse(N);
  String st='';
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++)
      if ((i + j) % n != 0) st = st + '.' + i.toString() + j.toString();
  return lstrip(st);
}

String Dau(n){
  String st ='';
  for (int i=0;i<10;i++)
    st = st + "." + n.toString() + i.toString();
  return lstrip(st);
}

String Dit(n){
  String st ='';
  for (int i=0;i<10;i++)
    st = st + "."  + i.toString() + n.toString();
  return lstrip(st);
}

//daudit2.7.9=cặp
String DauDit(n){
  String st ='';
  for (int i=0;i<10;i++)
    st = st + "." + n.toString() + i.toString();
  for (int i=0;i<10;i++)
    st = st + "."  + i.toString() + n.toString();
  return lstrip(st);
}

//daubitBT123x10  (Đề đầu đít 1,2,3 bỏ trùng)
String DauDitBT(String ab){
  String st ='';
  for (int i=0;i<ab.length;i++)
    st=st + '.' + DauDit(ab.substring(i,i+1));//[i:i+1]
  st=lstrip(st);
  return SoKhongTrungLap(st);
}

/*chạm
cham0=01,10,02,20,03,30,04,40,05,50,06,60,07,70,08,80,09,90,00
cham1=01,10,12,21,13,31,14,41,15,51,16,61,17,71,18,81,19,91,11
*/
String Cham(n){
  String st=n.toString()+n.toString();
  for (int i=0;i<10;i++)
    if (i!=n) st = st + "." + n.toString() + i.toString() + "." + i.toString() + n.toString();
  return SoKhongTrungLap(st);
}

//chạm lấy trùng
String ChamT(xy){
  String st='';
  String so=xy.toString();
  for (int i=0;i<so.length;i++)
    st+='.'+ Cham(so.substring(i,i+1));
  st=lstrip(st);
  return ThemSoCap(st);
}

//cham xy bỏ trùng=36so
String ChamBT(xy){
  String so=xy.toString();
  String st='';
  for (int i=0;i<so.length;i++)
    st += "." + Cham(so.substring(i,i+1));
  st=lstrip(st);
  return SoKhongTrungLap(st);
}

//dàn 'dan 27=22->27,32->37,..72->77
String Dan(xy){
  String st ='', so=xy.toString();
  int a = int.parse(so.substring(0,1));
  int b = int.parse(so.substring(so.length-1));
  int i=a;
  while (i <= b){
    int j=a;
    while (j<=b){
      st+='.'+i.toString()+j.toString();
      j++;
    }
    i++;
  }
  return lstrip(st);
}

//bộ=hệ
String Bo(String xy){
  String st='';
  int a = int.parse(xy.substring(0,1));
  int b = int.parse(xy.substring(xy.length-1));
  int? c,d;
  if (a < 5) c = a + 5;
  if (a >= 5) c = a - 5;
  if (b < 5) d = b + 5;
  if (b >= 5) d = b - 5;

  st+= '.' + a.toString() + b.toString();
  st+= '.' + b.toString() + a.toString();
  st+= '.' + b.toString() + c.toString();
  st+= '.' + c.toString() + b.toString();
  st+= '.' + c.toString() + d.toString();
  st+= '.' + d.toString() + c.toString();
  st+= '.' + d.toString() + a.toString();
  st+= '.' + a.toString() + d.toString();
  return SoKhongTrungLap(st);
}

//chia A dư B
String ChiaAduB(String x, String y){
  int a=int.parse(x), b=int.parse(y);
  String st='';
  int? so;
  for (int i=0;i<10;i++)
    for (int j=0;j<10;j++) {
      so = int.parse(i.toString() + j.toString());
      if (so % a == b) st += "." + ('0'+so.toString()).substring(('0'+so.toString()).length-2);
    }
  return lstrip(st);
}

//DauABghDitXY :dau AB ghép dit XY:'dau0.1.5.6.7.8.ghepdit0.2.5.6.7.8
String DauGhDit(String dau,String dit){
  String st='';
  for (int i=0;i<dau.length;i++)
    for (int j=0;j<dit.length;j++)
      st +=  "." + dau.substring(i,i+1) + dit.substring(j,j+1);
  return lstrip(st);
}

//dau0.1.5.6.7.8.ghepdit0.2.5.6.7.8 bokep
String DauGhBKdit(String dau, String dit){
  String st='', so='';
  String kepBang=KepBang(), kepLech=KepLech();
  for (int i=0;i<dau.length;i++)
    for (int j=0;j<dit.length;j++)
      {
        so = dau.substring(i,i+1) + dit.substring(j,j+1);
        if (!kepBang.contains(so) && !kepLech.contains(so)) st+='.' + so;
      }
  return lstrip(st);
}

//xien quay : So='01.02.03.04.05'
String XienQuay(String So,String SoTien){
  String x2='',x3='',x4='';
  for (String x in LayCapSo_from_st(So)) {
    x2 += 'xien.$x.x$SoTien.';
  }
  for (String x in Lay3So_from_st(So)) {
    x3 += 'xien.$x.x$SoTien.';
  }
  for (String x in Lay4So_from_st(So)) {
    x4 += '${x4}xien.$x.x$SoTien.';
  }
  String xq = x2 + x3 + x4 ;
  if(So.split('.').length == 4) xq += 'xien.$So.x$SoTien';
  return rstrip(xq);
}

//đá vòng
String DaVong(String So,String SoTien){
  String x2='';
  for (String x in LayCapSo_from_st(So))
    x2 =  x + '.' +'x' + SoTien + '.';
  return 'xien'+'.'+rstrip(x2);
}

String Tach3con(String st)=>st.substring(0,2) + '.' + st.substring(st.length-2);
String KepBang() => "00.11.22.33.44.55.66.77.88.99";
String KepLech()=> "05.50.16.61.27.72.38.83.49.94";
