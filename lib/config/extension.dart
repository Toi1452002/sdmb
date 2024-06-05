
import 'dart:io';

import 'package:intl/intl.dart';

extension Bool on String{
  bool get toBool=> int.parse(this)==0 ? false : true;

  bool get isNumeric => num.tryParse(this) != null ? true : false;

  int get toInt => isNumeric ? int.parse(this) : 0;

  double get toDouble => isNumeric ? double.parse(this) : 0.0;

  String lastChars(int n) => substring(length - n);
}


extension FormatDouble on String {
  String get formatDouble {
    if(isNumeric){
      String tmp = toString().toDouble.toStringAsFixed(1);
      if(tmp.lastChars(1)=='0'){
        return NumberFormat('#,###').format(toString().toDouble);
      }else{
        return tmp.replaceAll('.', ',');
      }
    }else{
      return '';
    }
  }
}


Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}



doubleParse(var i){
  if(i.toString().isNumeric) {
    return NumberFormat('#,###').format(double.parse(i.toString()));
  } else {
    return '';
  }
}
