import 'package:capstone_project_hcmut/data/client/authentication_api_services.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/utils/exception.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'abstract/base_provider_model.dart';

class LoginStateViewModel extends BaseProvider {
  BaseProviderModel<LoginResponseModel> _loginData = BaseProviderModel.init();
  BaseProviderModel<LoginResponseModel> get getLoginData => _loginData;
  LoginResponseModel get instance => _loginData.data!;
  final loginFormKey = GlobalKey<FormState>();
  bool isPop = false;
  bool isCancel = false;
  final CancelToken cancelToken = CancelToken();

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Map<String, dynamic>? _facebookUserData;
  Map<String, dynamic>? get getFacebookUser => _facebookUserData;
  AccessToken? facebookAcccessToken;

  Future loginbyGoogle() async {
    AuthenticationAPIService service = AuthenticationAPIService();
    try {
      isCancel = false;
      isPop = false;
      setStatus(ViewState.loading, notify: true);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setStatus(ViewState.fail, notify: true);
        setErrorMessage('Google account is not exist', notify: true);
        return;
      }
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      late dynamic response;
      if (user != null) {
        await Future.delayed(
          const Duration(seconds: 1),
          () async => response = await service.loginWithGoogle(
            GoogleLoginRequestModel(
                googleId: user!.id,
                displayName: user!.displayName!,
                email: user!.email,
                photoUrl: user!.photoUrl),
            cancelToken: isCancel ? cancelToken : null,
          ),
        );
        _loginData = BaseProviderModel.success(response);
      } else {
        print('NO user');
      }
      setStatus(ViewState.done, notify: true);
    } on PlatformException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.message!, notify: true);
    } on FirebaseAuthException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.code, notify: true);
    } on RemoteException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.errorMessage, notify: true);
    } finally {}
  }

  Future logoutGoogle() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future logoutFacebook() async {
    await FacebookAuth.instance.logOut();
    notifyListeners();
  }

  Future<void> logOut() async {
    final SharedPreferencesWrapper sharedPreferencesWrapper =
        SharedPreferencesWrapper.instance;
    await sharedPreferencesWrapper.remove('isLoggedIn');
    await sharedPreferencesWrapper.remove('refresh_token');
    if (user != null) {
      logoutGoogle();
      _user = null;
    }
    if (getFacebookUser != null) {
      logoutFacebook();
      _facebookUserData = null;
    }
  }

  Future<void> loginByEmail(
      String emailPhone, String password, BuildContext context) async {
    AuthenticationAPIService service = AuthenticationAPIService();

    try {
      isCancel = false;
      isPop = false;
      setStatus(ViewState.loading, notify: true);
      late dynamic response;

      await Future.delayed(
        const Duration(seconds: 2),
        () async => response = await service.login(
            LoginRequestModel(emailPhone: emailPhone, password: password),
            cancelToken: isCancel ? cancelToken : null),
      );

      _loginData = BaseProviderModel.success(response);
      setStatus(ViewState.done, notify: true);
    } on RemoteException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.errorMessage, notify: true);
      _loginData = BaseProviderModel.fail(exception);
    } on Exception catch (exception) {
      _loginData = BaseProviderModel.fail(exception);
    } finally {}
  }

  Future loginByFacebook() async {
    AuthenticationAPIService service = AuthenticationAPIService();
    try {
      isCancel = false;
      isPop = false;
      late dynamic response;
      setStatus(ViewState.loading, notify: true);
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.dialogOnly,
      );
      if (loginResult.status == LoginStatus.success) {
        facebookAcccessToken = loginResult.accessToken!;
        _facebookUserData = await FacebookAuth.i.getUserData();
        if (facebookAcccessToken != null) {
          // If sucessfully logged in
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(facebookAcccessToken!.token);
          await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          if (_facebookUserData != null) {
            await Future.delayed(
              const Duration(seconds: 1),
              () async => response = await service.loginWithFacebook(
                FacebookLoginRequestModel(
                  facebookId: getFacebookUser!['id'],
                  displayName: getFacebookUser!['name'],
                  email: getFacebookUser!['email'],
                  photoUrl: getFacebookUser!['picture']['data']['url'],
                ),
                cancelToken: isCancel ? cancelToken : null,
              ),
            );
            _loginData = BaseProviderModel.success(response);
            setStatus(ViewState.done, notify: true);
          } else {
            setStatus(ViewState.fail, notify: true);
            setErrorMessage('Cannot connect to Facebook', notify: true);
          }
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        setStatus(ViewState.fail, notify: true);
        setErrorMessage("Request cancel", notify: true);
      } else if (loginResult.status == LoginStatus.failed) {
        setStatus(ViewState.fail, notify: true);
        setErrorMessage("Request failed", notify: true);
      }
    } on FirebaseAuthException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.code, notify: true);
    } on RemoteException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.errorMessage, notify: true);
    } on PlatformException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.message!, notify: true);
    } finally {}
  }
}
