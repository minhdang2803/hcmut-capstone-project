import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/presentation/pages/quiz/component/map_object.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class QuizLocalSource {
  void saveResultToLocal(int level, int result);
  List<Map<String, dynamic>> getResultFromLocal();
  Map<String, dynamic> getResultFromLocalByLevel(int level);
  Future<void> saveMCTestsToLocal(QuizMultipleChoiceResponse quiz, int id);
  QuizMCTests? getMCTestsFromLocal(int id);
  List<MapObjectLocal> getListMapObjectLocal();
  MapObjectLocal? getMapObjectLocalById(int id);
  void upsertMapObjectLocal(MapObjectLocal mapObject);
}

class QuizLocalSourceImpl implements QuizLocalSource {
  Box getAnswerBox() => Hive.box(HiveConfig.quizMCAnswers);
  Box getTestsBox() => Hive.box(HiveConfig.quizMCtests);
  Box getMapObjectLocalBox() => Hive.box(HiveConfig.mapObject);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void saveResultToLocal(int id, int result) {
    Set<Map<String, dynamic>> answers = {};
    final box = getAnswerBox();
    String userId = getUserId();
    final List<dynamic> response = box.get(userId, defaultValue: []);
    for (final element in response) {
      answers.add({"id": element["id"], "score": element["score"]});
    }
    Map<String, dynamic> data = {"id": id, "score": result};
    answers.removeWhere((element) =>
        element.containsKey("id") && element.containsValue(id));
    answers.add(data);
    LogUtil.debug(
        "Succesfully save the answer of quiz level $id, score: $result");
    box.put(userId, answers.toList());
  }

  @override
  Map<String, dynamic> getResultFromLocalByLevel(int level) {
    final box = getAnswerBox();
    String userId = getUserId();
    final response = box.get(userId, defaultValue: []);
    for (final element in response) {
      if (element['id'] == level) {
        return element;
      }
    }
    return {};
  }

  @override
  List<Map<String, dynamic>> getResultFromLocal() {
    List<Map<String, dynamic>> result = [];
    final box = getAnswerBox();
    final userId = getUserId();
    final List<dynamic> fromLocal = box.get(userId, defaultValue: []);
    for (final element in fromLocal) {
      result.add({"id": element["id"], "score": element["score"]});
    }
    return result;
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
  List<MapObjectLocal> getListMapObjectLocal() {
    List<MapObjectLocal> result = [];
    final box = getMapObjectLocalBox();
    final String userId = getUserId();
    final response = box.get(userId, defaultValue: clm);
    result.addAll(response.cast<MapObjectLocal>());
    return result;
  }

  @override
  void upsertMapObjectLocal(MapObjectLocal mapObject) {
    List<MapObjectLocal> result = [];
    bool isLastElement = false;
    final box = getMapObjectLocalBox();
    final String userId = getUserId();
    final response = box.get(userId, defaultValue: clm);
    result.addAll(response.cast<MapObjectLocal>());
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
    LogUtil.debug("Succesfully save MapObjectLocal of quiz level $mapObject");
  }

  @override
  MapObjectLocal? getMapObjectLocalById(int id) {
    List<MapObjectLocal> result = [];

    final box = getMapObjectLocalBox();
    final String userId = getUserId();
    final response = box.get(userId, defaultValue: clm);
    result.addAll(response.cast<MapObjectLocal>());
    for (final element in result) {
      if (int.parse(element.id) == id) {
        return element;
      }
    }
    return null;
  }

  List<MapObjectLocal> clm = [
    MapObjectLocal(
      id: '1',
      dx: 0.5,
      dy: 0.93,
      sizeDx: 25.r,
      sizeDy: 25.r,
    ),
    MapObjectLocal(
      id: '2',
      dx: 0.13,
      dy: 0.86,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '3',
      dx: 0.25,
      dy: 0.78,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '4',
      dx: -0.1,
      dy: 0.78,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '5',
      dx: -0.4,
      dy: 0.79,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '6',
      dx: -0.5,
      dy: 0.73,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '7',
      dx: -0.2,
      dy: 0.70,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '8',
      dx: 0.1,
      dy: 0.69,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
    MapObjectLocal(
      id: '9',
      dx: 0.5,
      dy: 0.62,
      sizeDx: 25.r,
      sizeDy: 25.r,
      isDone: false,
    ),
  ];
}
