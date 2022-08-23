import 'package:capstone_project_hcmut/data/client/authentication_api_services.dart';
import 'package:capstone_project_hcmut/models/authentication/login_request_model.dart';
import 'package:capstone_project_hcmut/models/authentication/login_response_model.dart';
import 'package:capstone_project_hcmut/utils/exception.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:flutter/material.dart';
import 'abstract/base_provider_model.dart';

class LoginStateViewModel extends BaseProvider {
  BaseProviderModel<LoginResponseModel> _loginData = BaseProviderModel.init();
  BaseProviderModel<LoginResponseModel> get data => _loginData;
  LoginResponseModel get instance => _loginData.data!;

  final formKey = GlobalKey<FormState>();
  
  Future getToken(String emailPhone, String password) async {
    final sharedPreferences = SharedPreferencesWrapper.instance;
    try {
      _loginData = BaseProviderModel.loading();
      notifyListeners();
      final response = await AuthenticationAPIService.login(
        LoginRequestModel(emailPhone: emailPhone, password: password),
      );
      if (response is LoginResponseModel) {
        String? accessToken = await sharedPreferences.get('access_token');
        if (accessToken != null) {
          _loginData = BaseProviderModel.success(response);
        }
      } else {
        LoginFailedModel errorResponse = response as LoginFailedModel;
        final error = LoginException(
          statusCode: errorResponse.statusCode,
          message: errorResponse.error,
        );
        _loginData = BaseProviderModel.fail(error);
        _loginData.message = error.message;
        print(_loginData.message);
      }
    } on Exception catch (exception) {
      _loginData = BaseProviderModel.fail(exception);
    } on Error catch (error) {
      print(error);
    } finally {
      notifyListeners();
    }
  }
}
