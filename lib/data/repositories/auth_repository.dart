import 'package:hive_flutter/hive_flutter.dart';

import '../data_source/local/auth_local_source.dart';
import '../data_source/remote/authentication/auth_remote_source.dart';
import '../models/authentication/login_model.dart';
import '../models/authentication/register_model.dart';
import '../models/authentication/user.dart';
import '../models/network/base_response.dart';

class AuthRepository {
  late final AuthRemoteSource _authRemoteSource;
  late final AuthLocalSource _authLocalSource;

  AuthRepository._internal() {
    _authRemoteSource = AuthRemoteSourceImpl();
    _authLocalSource = AuthLocalSourceImpl();
  }

  static final _instance = AuthRepository._internal();

  factory AuthRepository.instance() => _instance;

  // Future<BaseResponse<User>> loginWithGoogle() {
  //   return _authRemoteSource.loginWithGoogle();
  // }

  // Future<BaseResponse<User>> loginWithFacebook() {
  //   return _authRemoteSource.loginWithFacebook();
  // }

  // Future<BaseResponse<User>> loginWithApple() {
  //   return _authRemoteSource.loginWithApple();
  // }

  Future<BaseResponse<LoginModel>> login(String email, String password) async {
    return _authRemoteSource.login(email, password);
  }

  Future<BaseResponse<LoginModel>> register(RegisterModel registerModel) {
    return _authRemoteSource.register(registerModel);
  }

  Future<BaseResponse> checkPhoneNumber(String phone) {
    return _authRemoteSource.checkPhoneNumber(phone);
  }

  Future<BaseResponse> resetPassword(String phone, String newPassword) {
    return _authRemoteSource.resetPassword(phone, newPassword);
  }

  void saveCurrentUser(User user, String token) async {
    _authLocalSource.saveCurrentUser(user, token);
  }

  User? getCurrentUser() {
    return _authLocalSource.getCurrentUser();
  }

  Box getUserBox() => _authLocalSource.getUserBox();
}
