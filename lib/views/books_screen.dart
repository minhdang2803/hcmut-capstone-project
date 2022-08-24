import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);
  static const String routeName = 'BookScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: BookScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Center(child: Text('Books Screen')),
      ),
    ));
  }
}
