import 'package:dio_util/dio_util.dart';
import 'package:llfile/models/sbc_api_model.dart';
import 'package:llfile/service/common_service.dart';

class SbcDeviceService extends SbcBaseService{
  SbcDeviceService();

  Future<SbcDeviceRegisterResponse?> register(SbcDeviceRegisterRequest req)async{
      var respJson = await callApi(ApiMethods.post, '/pu/devices/register', dataReq: req);
      if (respJson != null){
          return SbcDeviceRegisterResponse.fromJson(respJson);
      }
      return null;
  }

  Future<SbcDeviceListResponse?> list(SbcDeviceListRequest req)async{
      var respJson = await callApi(ApiMethods.get, '/pu/devices/list', queriesReq: req);
      if (respJson != null){
          return SbcDeviceListResponse.fromJson(respJson);
      }
      return null;
  }

}