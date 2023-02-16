import 'dart:typed_data';

import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/presentation/pages/uitest/component/map_object.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class QuizLocalSource {
  void saveResultToLocal(int level, int result);
  Map<String, dynamic> getResultFromLocalByLevel(int level);
  Future<void> saveMCTestsToLocal(QuizMultipleChoiceResponse quiz, int id);
  QuizMCTests? getMCTestsFromLocal(int id);
  List<MapObject> getListMapObject();
  void upsertMapObject(MapObject mapObject);
}

class QuizLocalSourceImpl implements QuizLocalSource {
  Box getAnswerBox() => Hive.box(HiveConfig.quizMCAnswers);
  Box getTestsBox() => Hive.box(HiveConfig.quizMCtests);
  Box getMapObjectBox() => Hive.box(HiveConfig.mapObject);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void saveResultToLocal(int level, int result) {
    List<Map<String, dynamic>> answers = [];
    bool isLastElement = false; // check if last element
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    answers.addAll(response.cast<Map<String, dynamic>>());
    Map<String, dynamic> data = {"level": level, "result": result};
    for (final element in answers) {
      if (element["level"] == level && element["result"] == result) {
        final index = answers.indexOf(element);
        answers.removeAt(index);
        answers.insert(index, data);
      } else if (answers.indexOf(element) == answers.length - 1) {
        isLastElement = true;
      }
    }
    if (isLastElement) {
      answers.add(data);
    }
    LogUtil.debug(
        "Succesfully save the answer of quiz level $level, result: $result");
    box.put(userId, answers);
  }

  @override
  Map<String, dynamic> getResultFromLocalByLevel(int level) {
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    for (final element in response) {
      if (element['level'] == level) {
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

  @override
  List<MapObject> getListMapObject() {
    List<MapObject> result = [];
    final box = getMapObjectBox();
    final String userId = getUserId();
    final response = box.get(userId, defaultValue: [
      MapObject(
        id: '1',
        offset: const Offset(-0.12, 0.97),
        size: Size(25.r, 25.r),
      ),
      MapObject(
        id: '2',
        offset: const Offset(0.5, 0.93),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
      MapObject(
        id: '3',
        offset: const Offset(0.13, 0.86),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
      MapObject(
        id: '4',
        offset: const Offset(0.25, 0.78),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
    ]);
    result.addAll(response.cast<MapObject>());
    return result;
  }

  @override
  void upsertMapObject(MapObject mapObject) {
    List<MapObject> result = [];
    bool isLastElement = false;
    final box = getMapObjectBox();
    final String userId = getUserId();
    final response = box.get(userId, defaultValue: [
      MapObject(
        id: '1',
        offset: const Offset(-0.12, 0.97),
        size: Size(25.r, 25.r),
      ),
      MapObject(
        id: '2',
        offset: const Offset(0.5, 0.93),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
      MapObject(
        id: '3',
        offset: const Offset(0.13, 0.86),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
      MapObject(
        id: '4',
        offset: const Offset(0.25, 0.78),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
    ]);
    result.addAll(response.cast<MapObject>());
    for (final element in result) {
      if (element.id == mapObject.id) {
        final index = response.indexOf(element);
        result.removeAt(result.indexOf(element));
        result.insert(index, mapObject);
      } else if (result.indexOf(element) == result.length - 1) {
        isLastElement = true;
      }
    }
    if (isLastElement) {
      result.add(mapObject);
    }
    box.put(userId, result);
    LogUtil.debug("Succesfully save MapObject of quiz level $mapObject");
  }
}
