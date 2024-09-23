import 'dart:async';

import 'package:dio/dio.dart';

class ConfigServer{
  String get _path => "http://rgb.com.vn/admin/server/api";
  String get auth => "$_path/hopdong.php";
  String get config => "$_path/config.php";

  final _dio = Dio();

  Future<Response>  postData({required String path, required String type, required Map<String, dynamic> data}) async{
    FormData formData = FormData.fromMap({
      'type': type,
      'data': data
    });
    return _dio.post(path, data: formData);
  }

  Future<Response>  getData({required String path, required String type, required Map<String, dynamic> data}) async{
    return _dio.get(path, queryParameters: {
      'type': type,
      'data': data
    });
  }

}

