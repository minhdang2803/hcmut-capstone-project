import 'package:capstone_project_hcmut/data/client/authentication_api_services.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/utils/exception.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_provider_model.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends BaseProvider {
  BaseProviderModel<RegisterResponseModel> _registerData =
      BaseProviderModel.init();
  BaseProviderModel<RegisterResponseModel> get getRegisterData => _registerData;
  RegisterResponseModel get registerInstance => _registerData.data!;
  TextEditingController phone = TextEditingController()..text = '0906005531';
  TextEditingController email = TextEditingController()
    ..text = 'minhdangle2803@gmail.com';
  TextEditingController fullName = TextEditingController()
    ..text = 'Le Minh Dang';
  TextEditingController password = TextEditingController()
    ..text = 'minhdang2803';
  TextEditingController confirmPassword = TextEditingController()
    ..text = 'minhdang2803';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPop = false;
  bool isCancel = false;
  final CancelToken cancelToken = CancelToken();

  Future<void> register({
    required String phone,
    required String email,
    required String password,
    required String fullName,
  }) async {
    AuthenticationAPIService service = AuthenticationAPIService();
    try {
      isCancel = false;
      isPop = false;
      setStatus(ViewState.loading, notify: true);
      late dynamic response;
      await Future.delayed(const Duration(seconds: 1), () async {
        response = await service.register(
          RegisterRequestModel(
              phone: phone,
              email: email,
              fullName: fullName,
              password: password),
          cancelToken: isCancel ? cancelToken : null,
        );
      });
      _registerData = BaseProviderModel.success(response);
      setStatus(ViewState.done, notify: true);
    } on RemoteException catch (exception) {
      setStatus(ViewState.fail, notify: true);
      setErrorMessage(exception.errorMessage, notify: true);
      _registerData = BaseProviderModel.fail(exception);
    } on Exception catch (exception) {
      _registerData = BaseProviderModel.fail(exception);
    } finally {}
  }
}
