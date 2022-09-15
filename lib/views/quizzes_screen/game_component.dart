import 'dart:io';

import 'package:capstone_project_hcmut/models/quizzes/level_model.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:flutter/material.dart';

class GameComponent extends StatelessWidget {
  const GameComponent({Key? key, this.gameModel}) : super(key: key);

  final GameLevelModel? gameModel;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: kQuizGameUnselectedColor),
        child: Column(
          children: [
            _buildLogo(context, size),
            SizedBox(height: size.height * 0.001),
            Text(
              gameModel?.name ?? 'Name',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
            ),
            SizedBox(height: size.height * 0.005),
            Text(
              '${gameModel?.numberOfQuizzes} quizzes',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: size.height * 0.015),
            LinearProgressIndicator(
              value: gameModel!.process,
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.15,
      height: size.width * 0.15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: gameModel?.icon ?? const Icon(Icons.add, size: 40),
    );
  }
}
