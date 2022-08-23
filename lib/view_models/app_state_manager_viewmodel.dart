import 'dart:async';
import 'abstract/base_provider_model.dart';
import 'abstract/base_view_model.dart';

class AppStateModel {
  bool isSplashScreen = false;
  set isSplashScreenValue(bool value) => isSplashScreen = value;
}

class AppStateManagerViewModel extends BaseProvider {
  final BaseProviderModel<AppStateModel> _data =
      BaseProviderModel.init(data: AppStateModel());
  BaseProviderModel<AppStateModel> get instance => _data;

  void initializeApp() {
    Timer(const Duration(milliseconds: 3000), () {
      _data.data!.isSplashScreen = true;
      notifyListeners();
    });
  }
}
