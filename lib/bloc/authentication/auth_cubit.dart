import 'package:bke/utils/enum.dart';
import 'package:bke/utils/widget_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/models/authentication/login_model.dart';
import '../../data/models/authentication/register_model.dart';
import '../../data/models/authentication/user.dart';
import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../utils/log_util.dart';

part 'auth_state.dart';
part 'auth_logic.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial(AuthAction.authentication));

  final _authRepository = AuthRepository.instance();

  void doLogin(String email, String password) async {
    try {
      emit(AuthLoading());
      final BaseResponse<LoginModel> response = await _authRepository.login(
        email,
        password,
      );
      final user = response.data!.user;
      final token = response.data!.authorization.accessToken;
      _authRepository.saveCurrentUser(user, token);
      emit(LoginSuccess(user));
      LogUtil.debug('Login success: ${response.data?.user.id ?? 'empty user'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Login error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const LoginFailure('Không có kết nối internet!'));
          break;
        case RemoteException.responseError:
          emit(LoginFailure(e.message));
          break;
        default:
          emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
          break;
      }
    } catch (e, s) {
      emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
      LogUtil.error('Login error ', error: e, stackTrace: s);
    }
  }

  // void doGoogleLogin() async {
  //   try {
  //     emit(AuthLoading());
  //     final BaseResponse<User> response =
  //         await _authRepository.loginWithGoogle();
  //     final user = response.data!;
  //     final token = response.authorization!.accsessToken!;
  //     _authRepository.saveCurrentUser(user, token);
  //     emit(LoginSuccess(user));
  //     LogUtil.debug(
  //         'Google Login success: ${response.data?.id ?? 'empty user'}');
  //   } on RemoteException catch (e, s) {
  //     LogUtil.error('Google Login error: ${e.message}',
  //         error: e, stackTrace: s);
  //     switch (e.code) {
  //       case RemoteException.noInternet:
  //         emit(const LoginFailure('Không có kết nối internet!'));
  //         break;
  //       case RemoteException.responseError:
  //         emit(LoginFailure(e.message));
  //         break;
  //       default:
  //         emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
  //         break;
  //     }
  //   } catch (e, s) {
  //     emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
  //     LogUtil.error('Google Login error', error: e, stackTrace: s);
  //   }
  // }

  // void doFacebookLogin() async {
  //   try {
  //     emit(AuthLoading());
  //     final BaseResponse<User> response =
  //         await _authRepository.loginWithFacebook();
  //     final user = response.data!;
  //     final token = response.authorization!.accsessToken!;
  //     _authRepository.saveCurrentUser(user, token);
  //     emit(LoginSuccess(user));
  //     LogUtil.debug('FB Login success: ${response.data?.id ?? 'empty user'}');
  //   } on RemoteException catch (e, s) {
  //     LogUtil.error('FB Login error: ${e.message}', error: e, stackTrace: s);
  //     switch (e.code) {
  //       case RemoteException.noInternet:
  //         emit(const LoginFailure('Không có kết nối internet!'));
  //         break;
  //       case RemoteException.responseError:
  //         emit(LoginFailure(e.message));
  //         break;
  //       default:
  //         emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
  //         break;
  //     }
  //   } catch (e, s) {
  //     emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
  //     LogUtil.error('FB Login error', error: e, stackTrace: s);
  //   }
  // }

  void doRegister(RegisterModel registerModel) async {
    try {
      emit(AuthLoading());
      final response = await _authRepository.register(registerModel);
      final user = response.data!.user;
      final token = response.data!.authorization.accessToken;
      _authRepository.saveCurrentUser(user, token);
      emit(RegisterSuccess(user));
      LogUtil.debug(
          'Register success, login with user: ${response.data?.user.id ?? 'empty user'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Register error: ${e.message}', error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const LoginFailure('Không có kết nối internet!'));
          break;
        case RemoteException.responseError:
          emit(LoginFailure(e.message));
          break;
        default:
          emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
          break;
      }
    } catch (e, s) {
      emit(const LoginFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
      LogUtil.error('Register error ', error: e, stackTrace: s);
    }
  }

  void doResetPassword(String phone, String newPassword) async {
    try {
      emit(AuthLoading());
      await _authRepository.resetPassword(phone, newPassword);
      emit(const ResetPasswordSuccess('Đã đổi mật khẩu thành công'));
      LogUtil.debug(
          'Reset new password success: {phone: $phone, newPassword: $newPassword');
    } on RemoteException catch (e, s) {
      if (e.code == RemoteException.noInternet) {
        emit(const ResetPasswordFailure('Không có kết nối internet!'));
        return;
      }
      emit(const ResetPasswordFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
      LogUtil.error('Reset password error: ${e.message}',
          error: e, stackTrace: s);
    } catch (e, s) {
      emit(ResetPasswordFailure(e.toString()));
      LogUtil.error('Reset password error', error: e, stackTrace: s);
    }
  }

  Future<bool> checkPhoneNumber(String phone) async {
    try {
      final response = await _authRepository.checkPhoneNumber(phone);
      if (response.status == 'success') {
        return true;
      }
    } on RemoteException catch (e, s) {
      LogUtil.error('Checking Phone number failure: ${e.errorMessage}',
          error: e, stackTrace: s);
    } catch (e, s) {
      LogUtil.error('Checking Phone number failure: $e');
    }
    return false;
  }

  User? getCurrentUser() => _authRepository.getCurrentUser();

  Box getUserBox() => _authRepository.getUserBox();


}
