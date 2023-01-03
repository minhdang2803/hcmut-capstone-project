import 'dart:convert';
import 'package:bke/data/models/quiz/quiz.dart';

class Game {
  Game({
    required this.userId,
    required this.examKey,
    required this.quizs,
  });

  late final String userId;
  late final String? examKey;
  late final List<Quiz> quizs;

  Game.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    examKey = json["exam_key"];
    quizs = (json["game"] as List).map((i) => Quiz.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['exam_key'] = examKey;
    map['game'] = json.encode(quizs.map((i) => i.toJson()).toList());
    return map;
  }
}
