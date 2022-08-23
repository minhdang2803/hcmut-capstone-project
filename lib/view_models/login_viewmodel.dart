import 'package:capstone_project_hcmut/data/client/authentication_api_services.dart';
import 'package:capstone_project_hcmut/models/authentication/login_request_model.dart';
import 'package:capstone_project_hcmut/models/authentication/login_response_model.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';

import 'abstract/base_provider_model.dart';

class LoginStateViewModel extends BaseProvider {
  BaseProviderModel<LoginResponseModel> _loginData = BaseProviderModel.init();
  BaseProviderModel<LoginResponseModel> get data => _loginData;
  LoginResponseModel get instance => _loginData.data!;
  Future getToken(String emailPhone, String password) async {
    try {
      _loginData = BaseProviderModel.loading();
      notifyListeners();
      final response = await AuthenticationAPIService.login(
        LoginRequestModel(emailPhone: emailPhone, password: password),
      );
      if(re)
      _loginData = BaseProviderModel.success(response);
    } on Exception catch (exception) {
      _loginData = BaseProviderModel.fail(exception);
    } on Error catch (error) {
      print(error);
    } finally {
      notifyListeners();
    }
  }
}
