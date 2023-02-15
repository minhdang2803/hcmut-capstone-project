import 'dart:typed_data';

import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class QuizLocalSource {
  void saveResultToLocal(int level, int result);
  List<Map<String, dynamic>> getResultsFromLocal();
  Map<String, dynamic> getAnAnswerFromLocal(int level, int quizId);
  Future<void> saveMCTestsToLocal(QuizMultipleChoiceResponse quiz, int id);
  QuizMCTests? getMCTestsFromLocal(int id);
}

class QuizLocalSourceImpl implements QuizLocalSource {
  Box getAnswerBox() => Hive.box(HiveConfig.quizMCAnswer);
  Box getTestsBox() => Hive.box(HiveConfig.quizMCtests);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void saveResultToLocal(int level, int result) {
    Set<Map<String, dynamic>> answers = {};
    final box = getAnswerBox();
    String userId = getUserId();
    final response =
        box.get(userId, defaultValue: {} as Set<Map<String, dynamic>>);
    answers.addAll(response.cast<Map<String, dynamic>>());
    Map<String, dynamic> data = {"level": level, "result": result};
    answers.add(data);
    box.put(userId, answers);
  }

  @override
  List<Map<String, dynamic>> getResultsFromLocal() {
    Set<Map<String, dynamic>> answers = {};
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    answers.addAll(response.cast<Map<String, dynamic>>());
    return answers.map((e) => e).toList();
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

  @override
  Future<void> saveMCTestsToLocal(
      QuizMultipleChoiceResponse quiz, int id) async {
    List<QuizMCTests> local = [];
    List<QuizMultipleChoiceLocalModel> localMC = [];
    final box = getTestsBox();
    final String userId = getUserId();
    final List<dynamic>? response = box.get(userId, defaultValue: []);
    if (response != null) {
      local.addAll(response.cast<QuizMCTests>());
    }
    for (final element in quiz.dataQuiz) {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(element.imgUrl!)).load("");
      final Uint8List bytes = imageData.buffer.asUint8List();
      localMC.add(QuizMultipleChoiceLocalModel(
        answer: element.answer,
        id: element.id,
        sentence: element.sentence,
        vocabAns: element.vocabAns,
        topic: element.topic,
        level: element.level,
        imgUrl: bytes,
      ));
    }
    local.add(
      QuizMCTests(
          id: id,
          typeOfQuestion: quiz.typeOfQuestion,
          numOfQuestions: quiz.numOfQuestions,
          tests: localMC),
    );
    LogUtil.debug("sucessfully add quizzes to local");
    box.put(userId, local);
  }

  @override
  QuizMCTests? getMCTestsFromLocal(int id) {
    List<QuizMCTests> local = [];
    final box = getTestsBox();
    final String userId = getUserId();
    final List<dynamic>? response = box.get(userId, defaultValue: []);
    if (response != null) {
      local.addAll(response.cast<QuizMCTests>());
    }
    for (final element in local) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }
}
