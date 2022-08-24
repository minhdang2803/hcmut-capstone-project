import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'QuizzesScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: WelcomeScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Center(child: Text('Wellcome Screen')),
      ),
    ));
  }
}
