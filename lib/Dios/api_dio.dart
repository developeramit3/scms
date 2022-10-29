import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:scms/services/session_repo.dart';

import '../globle/m/post_file_response.dart';


BaseOptions options = BaseOptions(
  baseUrl: 'http://54.175.201.240/api/',
  connectTimeout: 1000 * 60,
  receiveTimeout: 1000 * 60,
  sendTimeout: 1000*60,
  maxRedirects: 1,
  validateStatus: (status) => true,
);

var _apiDio = Dio(options);

bool isLoading=false;

Dio httpClient()  {
  _apiDio.interceptors.add(PrettyDioLogger(
    requestHeader: !kReleaseMode,
    requestBody: !kReleaseMode,
    responseBody: !kReleaseMode,
  ));

  _apiDio.interceptors.add(HeaderInterceptor());
  return _apiDio;
}

Dio httpClientWithHeaderToken(String token)  {
  isLoading=true;
  _apiDio.options.headers["authorization"] = "Bearer ${token}";
  _apiDio.interceptors.add(PrettyDioLogger(
    requestHeader: !kReleaseMode,
    requestBody: !kReleaseMode,
    responseBody: !kReleaseMode,
  ));
  _apiDio.interceptors.add(HeaderInterceptor());
  return _apiDio;
}

class HeaderInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler) async {
    return super.onRequest(options,handler);

  }



  @override
  void onResponse(Response response,ResponseInterceptorHandler handler) {
    _apiDio.interceptors.clear();
    return super.onResponse(response,handler);
  }

  @override
  void onError(DioError err,ErrorInterceptorHandler handler) {
    _apiDio.interceptors.clear();
    return super.onError(err,handler);

  }

}

Future<PostFileResponse>PostImage({required path,required fileName,required folder_path}) async {
  String token=await getToken();
  print("path==> $path");
  print("fileName==> $fileName");
  print("folder_path==> $folder_path");
  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(path, filename:fileName),
    "folder_path":folder_path
  });
  var response =
  await httpClientWithHeaderToken(token).post("upload-file",data: formData);
  print(response.data);
  return PostFileResponse.fromJson(response.data);
}
