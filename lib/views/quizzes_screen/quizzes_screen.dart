import 'package:capstone_project_hcmut/views/quizzes_screen/game_component.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: const GameComponent(),
                onTap: () => context.pushNamed(QuizzesScreen.routeName, params: {'tab':'quizzes'}),
              );
            },
            itemCount: 20,
          ),
        ),
      ),
    );
  }
}
