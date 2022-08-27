import 'dart:io';

import 'package:capstone_project_hcmut/data/client/authentication_api_services.dart';
import 'package:capstone_project_hcmut/models/authentication/login_request_model.dart';
import 'package:capstone_project_hcmut/models/authentication/login_response_model.dart';
import 'package:capstone_project_hcmut/utils/exception.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'abstract/base_provider_model.dart';

class LoginStateViewModel extends BaseProvider {
  BaseProviderModel<LoginResponseModel> _loginData = BaseProviderModel.init();
  BaseProviderModel<LoginResponseModel> get data => _loginData;
  LoginResponseModel get instance => _loginData.data!;

  final formKey = GlobalKey<FormState>();
  bool isPop = false;
  bool isCancel = false;
  final CancelToken cancelToken = CancelToken();
  Future<void> getToken(
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
}
