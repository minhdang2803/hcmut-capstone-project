import 'dart:convert';
import 'package:capstone_project_hcmut/models/authentication/login_request_model.dart';
import 'package:capstone_project_hcmut/models/authentication/login_response_model.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:dio/dio.dart';

class AuthenticationAPIService {
  // static var client = http.Client();
  static Future<dynamic> login(LoginRequestModel loginModel) async {
    Map<String, String> requestHeader = {'Content-Type': 'application/json'};

    final response = await Dio().post(
      'https://bke200701.herokuapp.com/api/v1/users/loginWithEmailorPhone',
      data: jsonEncode(loginModel.toJson()),
      options: Options(headers: requestHeader),
    );
    if (response.statusCode == 200) {
      // SharedPreferences
      final sharedPreferences = SharedPreferencesWrapper.instance;
      final responseData = LoginResponseModel.fromJson(response.data);
      final accessToken = responseData.data.authorization.accessToken;
      final accessTokenExpired =
          responseData.data.authorization.accessTokenExpiresAt;
      final refreshToken = responseData.data.authorization.refreshToken;
      final refreshTokenExpired =
          responseData.data.authorization.refreshTokenExpiresAt;
      final sessionID = responseData.data.authorization.sessionId;
      sharedPreferences.set('access_token', accessToken);
      sharedPreferences.set('access_token_expried', accessTokenExpired);
      sharedPreferences.set('refresh_token', refreshToken);
      sharedPreferences.set('refresh_token_expried', refreshTokenExpired);
      sharedPreferences.set('session_id', sessionID);
      return LoginResponseModel.fromJson(response.data);
    } else {
      return LoginFailedModel.fromJson(response.data);
    }
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
