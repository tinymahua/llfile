import 'package:llfile/models/sbc_auth_model.dart';
import 'package:llfile/service/common_service.dart';

class SbcAuthService extends BaseSbcService {
  SbcAuthService();

  Future<SbcRegisterResponse?> register(SbcRegisterRequest req)async{
      var respJson = await callApi(ApiMethods.post, '/paluser/auth/register', dataReq: req);
      if (respJson != null){
          return SbcRegisterResponse.fromJson(respJson);
      }
      return null;
  }

  Future<SbcLoginResponse?> login(SbcLoginRequest req)async{
      var respJson = await callApi(ApiMethods.post, '/paluser/auth/login', dataReq: req);
      if (respJson != null){
          return SbcLoginResponse.fromJson(respJson);
      }
      return null;
  }
}