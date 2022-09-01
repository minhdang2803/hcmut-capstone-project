import 'dart:convert';
import 'package:capstone_project_hcmut/data/client/api_client.dart';
import 'package:capstone_project_hcmut/data/client/api_services.dart';
import 'package:capstone_project_hcmut/data/network/api_request.dart';
import 'package:capstone_project_hcmut/data/network/authentication/authentication_config.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:dio/dio.dart';

class AuthenticationAPIService {
  dynamic _loginResponse(Response<dynamic> response) {
    final decodedResponse = LoginResponseModel.fromJson(response.data);
    switch (response.statusCode) {
      case 200:
        final sharePreferecnes = SharedPreferencesWrapper.instance;
        sharePreferecnes.set(
            'refresh_token', decodedResponse.data.authorization.refreshToken);
        sharePreferecnes.setBool('isLoggedIn', true);
    }
  }

  Future<dynamic> login(LoginRequestModel loginModel,
      {CancelToken? cancelToken}) async {
    const String path = EndPoint.loginWithPhoneOrEmail;
    final Map<String, dynamic> body = (loginModel.toJson());
    Map<String, String> requestHeader = {'Content-Type': 'application/json'};
    final response = APIService.instance().post(
      APIServiceRequest<LoginResponseModel>(
        path,
        header: requestHeader,
        dataBody: body,
        cancelToken: cancelToken,
        (response) => LoginResponseModel.fromJson(response),
      ),
      extraFunction: _loginResponse,
    );
    return response;
  }

  Future<dynamic> loginWithGoogle(GoogleLoginRequestModel loginModel,
      {CancelToken? cancelToken}) async {
    const String path = EndPoint.loginWithGoogle;
    final Map<String, dynamic> body = (loginModel.toJson());
    Map<String, String> requestHeader = {'Content-Type': 'application/json'};
    final response = APIService.instance().post(
      APIServiceRequest<LoginResponseModel>(
        path,
        header: requestHeader,
        dataBody: body,
        cancelToken: cancelToken,
        (response) => LoginResponseModel.fromJson(response),
      ),
      extraFunction: _loginResponse,
    );
    return response;
  }

  Future<dynamic> loginWithFacebook(FacebookLoginRequestModel loginModel,
      {CancelToken? cancelToken}) async {
    const String path = EndPoint.loginWithFacebook;
    final Map<String, dynamic> body = (loginModel.toJson());
    Map<String, String> requestHeader = {'Content-Type': 'application/json'};
    final response = APIService.instance().post(
      APIServiceRequest<LoginResponseModel>(
        path,
        header: requestHeader,
        dataBody: body,
        cancelToken: cancelToken,
        (response) => LoginResponseModel.fromJson(response),
      ),
      extraFunction: _loginResponse,
    );
    return response;
  }
  Future<dynamic> register(RegisterRequestModel registerModel,
      {CancelToken? cancelToken}) {
    const String path = EndPoint.registerWithPhoneOrEmail;
    final Map<String, dynamic> body = registerModel.toJson();
    final Map<String, String> requestHeader = {
      'Content_Type': 'application/json'
    };
    final response = APIService.instance().post(
      APIServiceRequest<RegisterResponseModel>(
        path,
        header: requestHeader,
        dataBody: body,
        (response) => RegisterResponseModel.fromJson(response),
      ),
    );
    return response;
  }

  // static Future<RegisterResponseModel> register(
  //     RegisterRequestModel registerModel) async {
  //   Map<String, String> requestHeader = {'Content-Type': 'application/json'};
  //   final Response<RegisterResponseModel> response = await Dio().post(
  //     '${Config.apiURL}${Config.loginApi}',
  //     options: Options(headers: requestHeader),
  //     data: jsonEncode(registerModel.toJson()),
  //   );
  //   return registerResponseModel(jsonDecode(source));
  // }
}
