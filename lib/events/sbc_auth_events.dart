import 'package:llfile/models/app_config_model.dart';
import 'package:llfile/models/sbc_auth_model.dart';

class SbcRegisterSuccessEvent {
  SbcRegisterSuccessEvent();
}

class SbcLoginSuccessEvent{
  SbcLoginSuccessEvent(this.sandbarAuthInfo);

  SandbarAuthInfo sandbarAuthInfo;
}