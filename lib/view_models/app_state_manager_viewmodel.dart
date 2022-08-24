import 'dart:async';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'abstract/base_provider_model.dart';
import 'abstract/base_view_model.dart';

class AppStateModel {
  List<Widget> listofPage = <Widget>[
    const WelcomeScreen(),
    const QuizzesScreen(),
    const BookScreen(),
    const Center(child: Text('Tests')),
    const SettingScreen(),
    const DemoScreen()
  ];
  int currentIndex = 0;
  bool isSplashScreen = false;
  set isSplashScreenValue(bool value) => isSplashScreen = value;
}

class AppStateManagerViewModel extends BaseProvider {
  final BaseProviderModel<AppStateModel> _data =
      BaseProviderModel.init(data: AppStateModel());
  BaseProviderModel<AppStateModel> get data => _data;
  AppStateModel get instance => _data.data!;

  void initializeApp() {
    Timer(const Duration(milliseconds: 3000), () {
      _data.data!.isSplashScreen = true;
      notifyListeners();
    });
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
