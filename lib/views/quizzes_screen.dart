import 'package:flutter/material.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({Key? key}) : super(key: key);
  static const String routeName = 'QuizzesScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: QuizzesScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Text('Quiz $index'),
                onTap: () => null,
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 20,
          ),
        ),
      ),
    );
  }
}
