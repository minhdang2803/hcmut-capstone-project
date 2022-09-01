import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class QuizzesListScreen extends StatelessWidget {
  const QuizzesListScreen({Key? key}) : super(key: key);
  static String routeName = 'QuizzesListScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: const QuizzesListScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(child: Text('clm')),
      ),
    );
  }
}
