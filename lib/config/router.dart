import 'package:get/get.dart';
import 'package:sdmb/views/baocao/baocaochitiet.dart';
import 'package:sdmb/views/caidat/vCaiDat.dart';
import 'package:sdmb/views/home/vHome.dart';
import 'package:sdmb/views/khach/vKhach.dart';
import 'package:sdmb/views/khach/vThemKhach.dart';
import 'package:sdmb/views/kqxs/vKqxs.dart';
import 'package:sdmb/views/tin/v_tinsms.dart';
import 'package:sdmb/views/tin/v_xemchitiet.dart';
import 'package:sdmb/views/tin/v_xuly_tin.dart';
import 'package:sdmb/views/tukhoa/vTuKhoa.dart';
import 'package:sdmb/views/user/vKichHoat.dart';
import 'package:sdmb/views/user/vLogin.dart';

const String vHome = "/";
const String vLogin = '/login';
const String vKichHoat = '/kich-hoat';
const String vKhach = '/khach';
const String vThemKhach = '/them-khach';
const String vKQXS = '/kqxs';
const String vTuKhoa = '/tu-khoa';
const String vCaiDat = '/cai-dat';
const String vXuLyTin = '/xu-ly-tin';
const String vXemChiTiet = '/xem-chi-tiet';
const String vBaoCaoChiTiet = '/bao-cao-chi-tiet';
const String vTinSMS = '/tin-sms';


List<GetPage> getPages()=>[
  GetPage(name: vHome, page: ()=>VHome()),
  GetPage(name: vLogin, page: ()=>VLogin()),
  GetPage(name: vKichHoat, page: ()=>VKichHoat()),
  GetPage(name: vKhach, page: ()=>VKhach()),
  GetPage(name: vThemKhach, page: ()=>const VThemKhach()),
  GetPage(name: vKQXS, page: ()=>VKqxs()),
  GetPage(name: vTuKhoa, page: ()=>VTuKhoa()),
  GetPage(name: vCaiDat, page: ()=>VCaiDat()),
  GetPage(name: vBaoCaoChiTiet, page: ()=>VBaoCaoChiTiet()),
  GetPage(name: vXuLyTin, page: ()=>VXuLyTin()),
  GetPage(name: vXemChiTiet, page: ()=>VXemChiTiet(),transition: Transition.rightToLeft),
  GetPage(name: vTinSMS, page: ()=>V_TinSMS())
];

///Key đã tạo cho GetStorage
/**
 ['ngayXuLy', 'kqxsMN']
 **/