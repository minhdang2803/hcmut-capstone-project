import 'package:bke/data/data_source/local/local_sources.dart';
import 'package:bke/data/data_source/remote/chat/chat_local_source.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data/models/authentication/login_model.dart';
import '../../data/models/authentication/register_model.dart';
import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../utils/log_util.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  final _authRepository = AuthRepository.instance();
  String fullName = "Người dùng mới";
  String email = "testuser@gmail.com";

  final chatLocalSource = GetIt.I.get<ChatSourceImpl>();
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
      final logingg = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        final data = GetIt.I.get<AuthLocalSourceImpl>();
        return FirebaseAuth.instance.currentUser!
            .updateDisplayName(data.getCurrentUser()!.fullName);
      });
      emit(LoginSuccess(user));
      LogUtil.debug('Login success: ${response.data?.user.id ?? 'empty user'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Login error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const LoginFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(LoginFailure(e.message));
          break;
        default:
          emit(const LoginFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const LoginFailure('Please try again later!'));
      LogUtil.error('Login error ', error: e, stackTrace: s);
    }
  }

  void doGoogleLogin() async {
    try {
      emit(AuthLoading());
      late GoogleSignInAuthentication? googleAuth;
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      LogUtil.debug('account: ${account}');
      if (account != null) {
        fullName = account.displayName ?? fullName;
        email = account.email;
        googleAuth = await account.authentication;
      } else {
        googleAuth = null;
      }

      if (true) {
        final BaseResponse<LoginModel> response =
            await _authRepository.loginWithGoogle(email);

        final user = response.data!.user;
        final token = response.data!.authorization.accessToken;
        _authRepository.saveCurrentUser(user, token);

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) => null);
        // await FirebaseAuth.instance.signInWithEmailAndPassword(
        //   email: user.email ?? '',
        //   password: user.password ?? '',
        // );
        emit(LoginSuccess(user));
      }
    } on RemoteException catch (e, s) {
      LogUtil.error('Google Login error: ${e.message}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.responseError:
          emit(const WaitingPassword("Hãy tạo một mật khẩu để tiếp tục."));
          break;
        case RemoteException.noInternet:
          emit(const LoginFailure('No internet connection!'));
          break;
        default:
          emit(LoginFailure(e.toString()));
          break;
      }
    } catch (e, s) {
      emit(LoginFailure(e.toString()));
      LogUtil.error('Google Login error', error: e, stackTrace: s);
    }
  }

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
  //         emit(const LoginFailure('No internet connection!'));
  //         break;
  //       case RemoteException.responseError:
  //         emit(LoginFailure(e.message));
  //         break;
  //       default:
  //         emit(const LoginFailure('Please try again later!'));
  //         break;
  //     }
  //   } catch (e, s) {
  //     emit(const LoginFailure('Please try again later!'));
  //     LogUtil.error('FB Login error', error: e, stackTrace: s);
  //   }
  // }

  void doRegister(RegisterModel registerModel, {is3party = false}) async {
    try {
      emit(AuthLoading());
      if (is3party) {
        registerModel.fullName = fullName;
        registerModel.email = email;
      }
      final response = await _authRepository.register(registerModel);
      final user = response.data!.user;
      final token = response.data!.authorization.accessToken;
      _authRepository.saveCurrentUser(user, token);

      // Firebase authentication handler START
      final ggRegister =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerModel.email,
        password: registerModel.password,
      );
      final ggUser = ggRegister.user;
      if (user != null) {
        await chatLocalSource.updateUserData(
          fullName: registerModel.fullName,
          email: registerModel.email,
          userUID: ggUser!.uid,
        );
      }
      // Firebase authentication handler END

      emit(RegisterSuccess(user));
      LogUtil.debug(
          'Register success, login with user: ${response.data?.user.id ?? 'empty user'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Register error: ${e.message}', error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const RegisterFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(RegisterFailure(e.message));
          break;
        default:
          emit(const RegisterFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const RegisterFailure('Please try again later!'));
      LogUtil.error('Register error ', error: e, stackTrace: s);
    }
  }

  void gmailVerify(String email) async {
    try {
      emit(AuthLoading());
      await _authRepository.gmailVerify(email);
      emit(const EmailVerifySuccess('Send mail successful.'));
      LogUtil.debug('send validation success: {email: $email');
    } on RemoteException catch (e, s) {
      LogUtil.error('send validation error: ${e.message}',
          error: e, stackTrace: s);

      switch (e.code) {
        case RemoteException.noInternet:
          emit(const EmailVerifyFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(EmailVerifyFailure(e.message));
          break;
        default:
          emit(const EmailVerifyFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(EmailVerifyFailure(e.toString()));
      LogUtil.error('send validation error', error: e, stackTrace: s);
    }
  }

  void checkGmailVerify(String email, String otpCode) async {
    try {
      emit(AuthLoading());
      final BaseResponse<Authorization> response =
          await _authRepository.checkGmailVerify(email, otpCode);
      emit(CheckEmailVerifySuccess(response.data!.accessToken));
      LogUtil.debug('mail validation success: {email: $email');
    } on RemoteException catch (e, s) {
      LogUtil.error('Reset password error: ${e.message}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const CheckEmailVerifyFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(CheckEmailVerifyFailure(e.message));
          break;
        default:
          emit(const CheckEmailVerifyFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(CheckEmailVerifyFailure(e.toString()));
      LogUtil.error('Reset password error', error: e, stackTrace: s);
    }
  }

  void resetPassword(String token, String email, String password) async {
    try {
      emit(AuthLoading());
      final BaseResponse<LoginModel> response = await _authRepository.resetPass(
        token,
        email,
        password,
      );
      final user = response.data!.user;
      final accessToken = response.data!.authorization.accessToken;
      _authRepository.saveCurrentUser(user, accessToken);
      emit(const ResetPasswordSuccess('Reset password successfully'));
      LogUtil.debug(
          'Reset password success: ${response.data?.user.id ?? 'empty user'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Reset password error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const ResetPasswordFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(ResetPasswordFailure(e.message));
          break;
        default:
          emit(const ResetPasswordFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const ResetPasswordFailure('Please try again later!'));
      LogUtil.error('Reset password error ', error: e, stackTrace: s);
    }
  }

  void signOut() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final clm = FirebaseAuth.instance.currentUser!.providerData;
      for (final providerProfile in clm) {
        // ID of the provider (google.com, apple.cpm, etc.)
        final provider = providerProfile.providerId;
        if (provider == "google.com") {
          googleSignIn.disconnect();
        }
      }
      await FirebaseAuth.instance.signOut();
    }
  }

  AppUser? getCurrentUser() => _authRepository.getCurrentUser();

  Box getUserBox() => _authRepository.getUserBox();
}
