import 'package:capstone_project_hcmut/models/quizzes/level_model.dart';
import 'package:capstone_project_hcmut/views/quizzes_screen/game_component.dart';
import 'package:capstone_project_hcmut/views/quizzes_screen/level_one_screen/quizzes_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              height: size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  buildQuizzes(
                    context,
                    GameLevelModel(
                        icon: const Center(child: FaIcon(FontAwesomeIcons.one)),
                        name: 'Level One',
                        numberOfQuizzes: 10,
                        process: 1 / 3),
                    () {
                      context.pushNamed(LevelOneScreen.routeName,
                          params: {'tab': 'quizzes'});
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}

Widget buildQuizzes(
    BuildContext context, GameLevelModel game, void Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: GameComponent(
      gameModel: game,
    ),
  );
}
