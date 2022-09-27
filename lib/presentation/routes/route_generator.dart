import 'package:flutter/material.dart';

import '../pages/about_us/about_us.dart';
import '../pages/authentication/authentication_page.dart';
import '../pages/welcome/welcome.dart';
import '../pages/main/main_page.dart';
import '../pages/profile/main/profile_page.dart';
import 'route_name.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case RouteName.main:
        page = const MainPage();
        break;
      case RouteName.welcome:
        page = const WelcomeScreen();
        break;
      case RouteName.authentication:
        page = const AuthenticationPage();
        break;
      case RouteName.profile:
        page = const ProfilePage();
        break;
      case RouteName.aboutUs:
        page = const AboutUsPage();
        break;
    }

    return _getPageRoute(page, settings);
  }

  static PageRouteBuilder<dynamic>? _getPageRoute(
    Widget? page,
    RouteSettings settings,
  ) {
    if (page == null) {
      return null;
    }
    return PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) => page,
        settings: settings,
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );

          // return FadeTransition(
          //   opacity: animation,
          //   child: child,
          // );
        });
  }
}
