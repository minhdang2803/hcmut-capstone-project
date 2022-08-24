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
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: Svg(
                  scale: 2,
                  color: kHawkBlueColor,
                  'assets/splash_screen/splash_screen.svg',
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height),
                ),
              ),
            ),
          ),
          Image(
            image: Svg(
              'assets/splash_screen/logo.svg',
              size: Size(MediaQuery.of(context).size.width * 0.8,
                  MediaQuery.of(context).size.width * 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
