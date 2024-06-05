//từ khoá
//mang tinh duy nhat, nen dung SET={}
List<String> tup_KieuDanh=['lo','de','xien','3cang','4cang','dg','nhat','gn','nt','lod','xq','tc','2cua','de.gn','l3c','nhi','g21','g22','nt3c','4cua','dd','dau','dgn'];//gn:giai nhat = nt:nhat toa

List<String> tup_SoDanhBien=['so','bo','he','day','dan','chambt', 'chamt','cham','dauditbt','daudit','dau','dit',
'tong','tongchia','tongduoi','tongtren','tongchanduoi','tongchantren','tongleduoi','tongletren','tongkchia','tongchia'];
//so42.bo84.76 =bo(84.76)
//ChiaAduB, DDaDENbBK, DDaDENbBDITc, TONGaDENbBK, TONGaDENbBditCD, TONGcDENdBDAUcd, dauABGHditXY, dauABGHBKditXY

bool isNumeric(String s) {//kiem tra xem chuoi co phai la so khong
  if (s == null) return false;
  return double.tryParse(s) != null;
}

bool isalnum(String s){//kiem tra xem chuoi co phai ky tu va so
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(s);
}

bool isalpha(String s){//kiem tra xem chuoi co phai ky tu
  return RegExp(r'^[A-Za-z_.]+$').hasMatch(s);
}

String lstrip(String s)=>(s[0]=='.'?s.substring(1):s);

String rstrip(String s)=>(s[s.length-1]=='.'?s.substring(0,s.length-1):s);

String strip(String s){
  s=lstrip(s);
  s=rstrip(s);
  return s;
}

int demPhanTu_st(String St, String kitu){//st.count(kytu)
  int dem=0;
  for (var i=0;i<St.length;i++){
    if (St[i]==kitu) dem+=1;
  }
  return dem;
}

int demPhanTu_list(List lstSo, String so){//lstSo.count(So)
  int dem=0;
  for (var x in lstSo){
    if (x==so) dem+=1;
  }
  return dem;
}

int Thu(String Ngay){//Ngay='2022-10-15'=6->saturday; sun=0,..sat=6
  var dt = DateTime.parse(Ngay);
  return dt.weekday;
}

String ThayKyTu_TV(String s){//thay ky tu tieng viet
  Map<String,String> TV={'ắ':'a','ằ':'a','ẳ':'a','ẵ':'a','ặ':'a','ă':'a',
    '₫':'d', 'ấ':'a','ầ':'a','ẩ':'a','ẫ':'a','ậ':'a','â':'a',
    'á': 'a', 'à': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a', 'đ': 'd',
    'é':'e','è':'e','ẻ':'e','ẽ':'e','ẹ':'e',
    'ê':'e','ế':'e','ề':'e','ể':'e','ễ':'e','ệ':'e',
    'í':'i','ì':'i','ỉ':'i','ĩ':'i','ị':'i',
    'ô':'o','ố':'o','ồ':'o','ổ':'o','ỗ':'o','ộ':'o',
    'ớ':'o','ờ':'o','ở':'o','ỡ':'o','ợ':'o','ơ':'o',
    'ó': 'o', 'ò': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
    'ư':'u','ứ':'u','ừ':'u','ử':'u','ữ':'u','ự':'u',
    'ú': 'u', 'ù': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
    'ý':'y','ỳ':'y','ỷ':'y','ỹ':'y','ỵ':'y'};
  for (var x in TV.keys)
    if (s.contains(x)) s=s.replaceAll(x,TV[x].toString());
  return s;
}

String ThayKyTu(String s, String KyTu, vitri){//Thay the ky tu vd: .->,
  int n=0;
  if (vitri.runtimeType !=int ) n=int.parse(vitri);
  else n=vitri;
  return s.substring(0,n-1) + KyTu + s.substring(n,s.length);
}

String ChenKyTu(String s, String KyTu, vitri){//chèn 1 ky tu vao chuoi
  int n=0;
  if (vitri.runtimeType !=int ) n=int.parse(vitri);
  else n=vitri;
  return s.substring(0,n) + KyTu + s.substring(n,s.length);
}

String XoaKyTu(String s, vitri){//xoá ky tu o vi tri
  int n=0;
  if (vitri.runtimeType !=int ) n=int.parse(vitri);
  else n=vitri;
  return s.substring(0,n) + s.substring(n + 1,s.length);
}

//bỏ bớt 2 ky tu trắng và chấm gần nhau 12..34.
String XoaBotKyTu(String oldText,String KyTu){
  String st=oldText;
  for (int i=0;i<st.length-1;i++){
    if (st.substring(i,i+1)==KyTu)
      if (st.substring(i+1,i+2)==KyTu){
        st = st.substring(0,i) + st.substring(i+1);
        i--;
      }
  }
  return st;
}

String LoaiBoDauCham(String s){//lo.12...34.x10
  while (s.contains('..')) {
    s=s.replaceAll('..', '.');
  }
  return s;
}

List<String> LoaiBoPhanTuRong(List<String> lst){//['lo','12','','','34','x10']
  while (lst.contains(''))
    lst.remove('');
  return lst;
}

//loai bo cac ky thu dac biet 2 dau: k phai số và chữ
String LoaiBo_KyTu_DB2dau(String oldText){
  String newText=oldText;
  if(oldText.isEmpty) return '';
  while (!isalnum(newText.substring(0,1))) newText=lstrip(newText.substring(0,1)); //newText.lstrip(newText[:1])
  while (!isalnum(newText.substring(0,1))) newText=rstrip(newText.substring(newText.length-1));// newText[-1:])
  return newText;
}

bool ktso_TrungLap(var n){//0000=true, 0001=false
  n=n.toString();//n dua vao la so hoac chuoi deu duoc
  bool bTrungLap = true;
  for (int i=0; i<n.length - 1;i++)
    if (n[i] != n[i + 1]) bTrungLap = false;
  return bTrungLap;
}

//số cặp số. dem xem co bao nhieu cap
num SoCapSo(int n)=>(n * (n - 1) / 2);

//100, 0,5, 10d, 10n,10k
String LaySoTien(String s){
  String SoTien='';
  if(s.isNotEmpty && s[0] == 'x'){
    s = s.substring(1);
  }
  if (s.indexOf(',')>0){
    int i=0;
    while (i<s.length){
      if (isNumeric(s[i])) SoTien+=s[i];
      i+=1;
    }
    SoTien=(int.parse(SoTien)/10).toString();
  }else{
    if (['n','k','d'].contains(s[s.length-1])) {
      SoTien=s.substring(0,s.length-1);
    } else {
      SoTien=s;
    }
  }
  return SoTien;
}

String SoKhongTrungLap(String s){
  var lst=s.split('.');
  final Set<String> set=Set.from(lst);
  lst=set.toList();
  return lst.join('.');
}

String LaySoTrungLap(String s){
  List<String> lst_so=[];
  var lst=s.split('.');
  lst.sort();
  for (var i=0;i< lst.length-1;i++)
    if(lst[i]==lst[i+1]) lst_so.add(lst[i]);
  return lst_so.join('.');
}

//lấy số trùng lắp từ chuỗi
List LayCapSo_from_st(String s){//lay cap so trong 1 day so: 12.13.14=12.13,12.14,13.14 / tg.kg.dl=tg.kg,tg.dl,kg.dl
  List<String> lst_CapSo=[];
  var lst_So=s.split('.');
  for (var i=0;i<lst_So.length-1;i++)
    for (var j=i+1;j<lst_So.length;j++)
      lst_CapSo.add(lst_So[i] + '.'+ lst_So[j]);
  return lst_CapSo;
}

//lấy số trùng lắp từ list
List LayCapSo_from_lst(List lst){//list=['dn','vt','tp']->['dn.vt', 'dn.tp', 'vt.tp']
  List lst_CapSo=[];
  for (var i=0;i<lst.length-1;i++)
    for (var j=i+1;j<lst.length;j++)
      lst_CapSo.add(lst[i] +'.'+ lst[j]);
  return lst_CapSo;
}

List Lay3So_from_st(String s){//01.02.03.04=01.02.03,01.02.04...
  List lst_CapSo=[];
  var lst_So=s.split('.');
  for (var i=0;i<lst_So.length-2;i++)
    for (var j=i+1;j<lst_So.length-1;j++)
      for (var k=j+1;k<lst_So.length;k++)
        lst_CapSo.add(lst_So[i] +'.'+ lst_So[j] + '.' + lst_So[k]);
  return lst_CapSo;
}

List Lay4So_from_st(String s){//01.02.03.04.05=01.02.03.04,01.02.03.05...
  List lst_CapSo=[];
  var lst_So=s.split('.');
  for (var i=0;i<lst_So.length-3;i++)
    for (var j=i+1;j<lst_So.length-2;j++)
      for (var m=j+1;m<lst_So.length-1;m++)
        for (var n=m+1;n<lst_So.length-1;n++)
          lst_CapSo.add(lst_So[i] +'.'+ lst_So[j] + '.' + lst_So[m]+ '.' + lst_So[n]);
  return lst_CapSo;
}

//55 thi them vao 55
String ThemSoCap(String st){
  List lst=st.split('.');
  int n=lst.length;
  for (int i=0;i<n;i++)
    if (['00','11','22','33','44','55','66','77','88','99'].contains(lst[i])) lst.add(lst[i]);
  String s='.';
  lst.sort();
  return lst.join(s);
}