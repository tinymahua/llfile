import 'package:get/get.dart';
import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/utils/db.dart';
import 'dart:async';
import 'package:dio/dio.dart' as dio_lib;
import 'package:dio/dio.dart';
import 'package:dio_util/dio_util.dart';

const String SBC_PROD_API_HOST = '';
const String SBC_TEST_API_HOST = '';
const String SBC_API_HOST = '';


Dio getDio(){
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler){
        print("dioInterceptors: \n\t${error}");
        return handler.resolve(error.response!);
      }
  ));
  return dio;
}

final dio_lib.Dio dio = getDio();

Map<String, dynamic> makeHeader({String? accessToken}){
  Map<String, dynamic> header = {};
  if (accessToken != null){
    header['Authorization'] = 'JWT $accessToken';
  }

  return header;
}


Future<Map<String, dynamic>> getSbcAuthedHeader()async{
  final AppConfigDb _appConfigDb = Get.find<AppConfigDb>();

  AppConfig appConfig = await _appConfigDb.read<AppConfig>();
  SandbarAuthInfo? sandbarAuthInfo = appConfig.accountSettings.sandbarAuthInfo;

  String? accessToken = sandbarAuthInfo?.accessToken;

  return makeHeader(accessToken: accessToken);
}


Future<String> getSbcApiHost()async{
  if (SBC_API_HOST.isNotEmpty){
    return SBC_API_HOST;
  }else{
    final AppConfigDb _appConfigDb = Get.find<AppConfigDb>();
    AppConfig appConfig = await _appConfigDb.read<AppConfig>();
    return appConfig.sbcApiHost;
  }
}



// Like a json annotation class
class SbcErrorResponse {
  SbcErrorResponse({required this.eid, required this.eval, this.extraInfo});

  String eid;
  String eval;
  dynamic extraInfo;

  // declare some custom fields

  factory SbcErrorResponse.fromJson(Map<String, dynamic> json) {
    return SbcErrorResponse(eid: json['eid'], eval: json['eval'], extraInfo: json['extra_info']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'eid': eid,
      'eval': eval,
      'extra_info': extraInfo,
    };
    return data;
  }
}

class SbcBaseService extends DioUtil {
  SbcBaseService(): super();

  @override
  void handleException(Map<String, dynamic> exceptionRespData) {
    var resp = SbcErrorResponse.fromJson(exceptionRespData['error']);
    print('Got error resp： ${resp.toJson()}');

  }

  @override
  Future<Map<String, dynamic>?> makeHeaders()async {
    return await getSbcAuthedHeader();
  }

  @override
  Future<String> getApiHost() async{
    return await getSbcApiHost();
  }
}


// class BaseSbcService{
//
//   BaseSbcService();
//
//   Future<Map<String, dynamic>?> callApi<REQ extends BaseEmptyModel>(
//       ApiMethods method, String path,
//       { REQ? dataReq, REQ? queriesReq,
//         dio_lib.Options? options,
//         dio_lib.CancelToken? cancelToken,
//         void Function(int, int)? onReceiveProgress,
//         void Function(int, int)? onSendProgress}) async {
//
//     options ??= dio_lib.Options(headers: await getSbcAuthedHeader());
//
//     var apiHost = await getSbcApiHost();
//
//     String url = "$apiHost$path";
//     print("Call Api: \n\t$method $url");
//     print("Data Json: \n\t${prettyJson(dataReq?.toJson())}");
//     print("Queries Json: \n\t${queriesReq?.toJson()}");
//     print('Options: \n\t${options.headers}');
//
//     dio_lib.Response resp;
//
//     switch (method) {
//       case ApiMethods.get:
//         resp = await dio.get(url,
//             data: dataReq?.toJson(),
//             queryParameters: queriesReq?.toJson(),
//             options: options,
//             cancelToken: cancelToken,
//             onReceiveProgress: onReceiveProgress);
//         break;
//       case ApiMethods.post:
//         resp = await dio.post(url,
//             data: dataReq?.toJson(),
//             queryParameters: queriesReq?.toJson(),
//             options: options,
//             cancelToken: cancelToken,
//             onSendProgress: onSendProgress,
//             onReceiveProgress: onReceiveProgress);
//         break;
//       case ApiMethods.put:
//         resp = await dio.put(url,
//             data: dataReq?.toJson(),
//             queryParameters: queriesReq?.toJson(),
//             options: options,
//             cancelToken: cancelToken,
//             onSendProgress: onSendProgress,
//             onReceiveProgress: onReceiveProgress);
//         break;
//       case ApiMethods.delete:
//         resp = await dio.delete(
//           url,
//           data: dataReq?.toJson(),
//           queryParameters: queriesReq?.toJson(),
//           options: options,
//           cancelToken: cancelToken,
//         );
//         break;
//     }
//     print("Resp: \n\t${resp}");
//     print("Status Code: \n\t${resp.statusCode}");
//     if (resp.statusCode == 401){
//     }
//
//     return checkApiResponse(resp);
//   }
//
//   Map<String, dynamic>? checkApiResponse(dio_lib.Response resp){
//
//     if (resp.statusCode! >= 400){
//       ErrorResponse errResp = ErrorResponse.fromJson(resp.data);
//       print("checkApiResponse Error: ${errResp.toJson()}");
//       return null;
//     }
//     return resp.data;
//   }
// }