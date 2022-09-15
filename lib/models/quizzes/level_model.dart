import 'package:flutter/material.dart';

class GameLevelModel {
  final Widget? icon;
  final String? name;
  final int? numberOfQuizzes;
  final double? process;
  //Data of games

  GameLevelModel({
    this.icon,
    this.name,
    this.numberOfQuizzes,
    this.process,
  });
}
