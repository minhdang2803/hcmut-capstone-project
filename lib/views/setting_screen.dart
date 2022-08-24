import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const String routeName = 'SettingScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: SettingScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Center(child: Text('Setting Screen')),
      ),
    ));
  }
}
