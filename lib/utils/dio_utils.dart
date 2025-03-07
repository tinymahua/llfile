import 'package:dio/dio.dart';


getDio(){
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException error, ErrorInterceptorHandler handler){
      print("dioInterceptors: \n\t${error}");
      return handler.resolve(error.response!);
    }
  ));
  return dio;
}

Map<String, dynamic> makeHeader({String? accessToken}){
  Map<String, dynamic> header = {};
  if (accessToken != null){
    header['Authorization'] = 'JWT $accessToken';
  }

  return header;
}