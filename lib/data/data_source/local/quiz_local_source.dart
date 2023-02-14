import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class QuizLocalSource {
  void saveAnswerToLocal(int level, int quizId, String answer);
  Set<Map<String, dynamic>> getAnswersFromLocal();
  Map<String, dynamic> getAnAnswerFromLocal(int level, int quizId);
}

class QuizLocalSourceImpl implements QuizLocalSource {
  Box getAnswerBox() => Hive.box(HiveConfig.quizMCAnswer);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void saveAnswerToLocal(int level, int quizId, String answer) {
    Set<Map<String, dynamic>> answers = {};
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    for (final element in response) {
      answers.add(element);
    }
    Map<String, dynamic> data = {
      "level": level,
      "id": quizId,
      "answer": answer
    };
    answers.add(data);
    box.put(userId, answers);
  }

  @override
  Set<Map<String, dynamic>> getAnswersFromLocal() {
    Set<Map<String, dynamic>> answers = {};
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    for (final element in response) {
      answers.add(element);
    }
    return answers;
  }

  @override
  Map<String, dynamic> getAnAnswerFromLocal(int level, int quizId) {
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    for (final element in response) {
      if (element['level'] == level && element['quizId'] == quizId) {
        return element;
      }
    }
    return {};
  }
}
