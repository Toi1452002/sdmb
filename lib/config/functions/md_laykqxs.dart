import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:sdmb/config/extension.dart';



Future<Map<String, dynamic>> layKQXS(DateTime ngay, {bool xsmn = false}) async{
  Map<String, dynamic> result = {
    'Ngay': null,
    'KQso':[]
  };

  List<String> listKq = [];
  String NgayKQ = "";
  final dio = Dio();
  String dateFormat = DateFormat("dd-MM-yyyy").format(ngay);
  String pathXSHN = 'https://xosohomnay.com.vn/ket-qua-xo-so-mien-bac-kqxs-mb/ngay-$dateFormat/';
  String pathXSMN = "https://www.minhngoc.net.vn/ket-qua-xo-so/mien-bac/$dateFormat.html";
  if(xsmn){// Lấy KQXS Minh Ngọc
    print('KQXS MN');
    try{
      var response = await dio.get(pathXSMN);
      if(response.statusCode==200){
        var convertHtml = parse(response.data);
        String ngay = convertHtml.getElementsByClassName("title").first.getElementsByTagName("a").last.text;
        List<String> lstNgay = ngay.split("/");
        NgayKQ = "${lstNgay.last}-${lstNgay[1]}-${lstNgay.first}";


        var row = convertHtml.getElementsByClassName('content')[0].getElementsByTagName("tbody")[1].getElementsByTagName("div");
        for(var x in row){
          if(x.text.isNumeric){
            listKq.add(x.text);
          }
        }

      }
    }catch(e){
      print(e);
    }
  }else{// Lấy KQXS Hôm Nay
    try{
      var response = await dio.get(pathXSHN);
      if(response.statusCode == 200){
        var convertHtml = parse(response.data);
        String year = convertHtml.getElementsByClassName("year").first.text;
        String date_month = convertHtml.getElementsByClassName("daymonth").first.text;
        String month = date_month.substring(date_month.indexOf("/") + 1);
        String date = date_month.substring(0, date_month.indexOf("/"));
        NgayKQ = DateFormat("yyyy-MM-dd").format(DateTime.parse("$year-$month-$date"));

        var row = convertHtml.getElementsByClassName("xsmb").first.getElementsByClassName("dayso");
        for (var so in row) {
          listKq.add(so.text);
        }
      }
    }catch(e){
      throw Exception(e);
    }
  }

  result["Ngay"] = NgayKQ;
  result["KQso"] = listKq;
  return result;
}

String giaiMB(int tt) {
  String giai = "";
  if (tt == 1) {
    giai = "DB";
  } else if (tt == 2) {
    giai = "G1";
  } else if (tt >= 3 && tt <= 4) {
    giai = "G2";
  } else if (tt >= 5 && tt <= 10) {
    giai = "G3";
  } else if (tt >= 11 && tt <= 14) {
    giai = "G4";
  } else if (tt >= 15 && tt <= 20) {
    giai = "G5";
  } else if (tt >= 21 && tt <= 23) {
    giai = "G6";
  } else if (tt >= 24) {
    giai = "G7";
  }
  return giai;
}