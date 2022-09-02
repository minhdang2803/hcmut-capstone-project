import 'dart:async';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'abstract/base_provider_model.dart';
import 'abstract/base_view_model.dart';

class AppStateModel {
  bool isLoggedIn = false;
  List<Widget> listofPage = <Widget>[
    const MainScreen(),
    const QuizzesScreen(),
    const BookScreen(),
    const Center(child: Text('Tests')),
    const SettingScreen(),
    Container(
      color: Colors.red,
    ),
  ];
  int currentIndex = 0;
  bool isSplashScreen = false;
  bool isOnboardingScreen = false;
  set isSplashScreenValue(bool value) => isSplashScreen = value;
}

class AppStateManagerViewModel extends BaseProvider {
  final BaseProviderModel<AppStateModel> _data =
      BaseProviderModel.init(data: AppStateModel());
  BaseProviderModel<AppStateModel> get data => _data;
  AppStateModel get instance => _data.data!;
  final pref = SharedPreferencesWrapper.instance;

  void initializeApp() {
    Timer(const Duration(milliseconds: 3000), () async {
      _data.data!.isSplashScreen = true;
      notifyListeners();
    });
  }

  void isOnboardingScreenDone() async {
    print('check this funciton');
    instance.isOnboardingScreen = true;
    await pref.setBool('isSecondTime', true);
    notifyListeners();
  }

  void goToTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'home'});
        break;
      case 1:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'quizzes'});
        break;
      case 2:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'books'});
        break;
      case 3:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'tests'});
        break;
      case 4:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'settings'});
        break;
      case 5:
        context.goNamed(HomeScreen.routeName, params: {'tab': 'settings'});
        break;
    }
    instance.currentIndex = index;
    notifyListeners();
  }

  String getTitle(String title) {
    String returnValue = '';
    switch (title) {
      case 'home':
        returnValue = 'Home';
        break;
      case 'quizzes':
        returnValue = 'Quizzes';
        break;
      case 'books':
        returnValue = 'Books';
        break;
      case 'tests':
        returnValue = 'Tests';
        break;
      case 'settings':
        returnValue = 'Settings';
        break;
      case 'demo':
        returnValue = 'Demo';
        break;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    return returnValue;
  }
}
