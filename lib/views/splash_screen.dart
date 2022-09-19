import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../view_models/theme_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = 'SplashScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: const SplashScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              ),
          ),
          Image.asset(
              'assets/splash_screen/logo.png',
              ),
        ],
      ),
    );
  }
}
