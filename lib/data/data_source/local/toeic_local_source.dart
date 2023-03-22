import 'dart:math';

import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/toeic/toeic_models.dart';

abstract class ToeicLocalSource {
  Future<void> savePartToLocal({
    required int part,
    List<ToeicQuestion>? part125,
    List<ToeicGroupQuestion>? part3467,
  });
  LocalToeicPart? getPartFromLocal(int part, {int limit = 10});
  void saveResultByPart(
    int part,
    int totalQuestion,
    int totalCorrect,
    Map<String, dynamic> chosenResult,
  );
  ToeicResultLocal? getResultByPartFromLocal(int part);
}

class ToeicLocalSourceImpl implements ToeicLocalSource {
  Box getToeicPartBox() => Hive.box(HiveConfig.toeicPart);
  Box getToeicResultBox() => Hive.box(HiveConfig.toeicResult);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  Future<void> savePartToLocal({
    required int part,
    List<ToeicQuestion>? part125,
    List<ToeicGroupQuestion>? part3467,
  }) async {
    final box = getToeicPartBox();
    final userId = getUserId();
    List<ToeicQuestionLocal>? part125Local;
    List<ToeicGroupQuestionLocal>? part3467Local;
    List<LocalToeicPart> result = [];
    List<int> partOfTest = [];
    bool isInList = false;

    //1 Parse String to Uint8List
    if (part125 != null) {
      part125Local = await ToeicQuestionLocal.fromInternet(part125);
    }
    if (part3467 != null) {
      part3467Local = await ToeicGroupQuestionLocal.fromInternet(part3467);
    }
    //2 Save the local response to return List;
    final List<dynamic> fromLocal = box.get(userId, defaultValue: []);
    for (final element in fromLocal) {
      result.add(element);

      if (!partOfTest.contains(element.part as int)) {
        partOfTest.add(element.part as int); //!need check
      }
    }
    //3. Save data to the correct part
    isInList = partOfTest.contains(part);
    if (isInList) {
      final index = partOfTest.indexOf(part);
      final elementAt = result.elementAt(index);
      if (elementAt.part125 != null && part125 != null) {
        elementAt.part125!.addAll(part125Local!);
      }
      if (elementAt.part3467 != null && part3467 != null) {
        elementAt.part3467!.addAll(part3467Local!);
      }
      result.removeAt(index);
      result.insert(index, elementAt);
    } else {
      result.add(
        LocalToeicPart(
          part: part,
          part125: part125Local,
          part3467: part3467Local,
        ),
      );
    }
    box.put(userId, result);
  }

  List<T> getRandomElements<T>(List<T> originalList, int count) {
    final random = Random();
    final listLength = originalList.length;

    // If count is greater than listLength, return the entire originalList.
    if (count >= listLength) {
      return List<T>.from(originalList);
    }

    final resultList = <T>[];
    while (resultList.length < count) {
      final randomIndex = random.nextInt(listLength);
      final randomElement = originalList[randomIndex];
      if (!resultList.contains(randomElement)) {
        resultList.add(randomElement);
      }
    }

    return resultList;
  }

  @override
  LocalToeicPart? getPartFromLocal(int part, {int limit = 10}) {
    LocalToeicPart? toeicPart;
    final List<LocalToeicPart> parts = [];
    final box = Hive.box(HiveConfig.toeicPart);
    final userId = getUserId();

    // 1. get Box of Toeic Part
    final List<dynamic> response = box.get(userId, defaultValue: []);
    // 2. addAll element from local to a parts get
    for (final element in response) {
      parts.add(element);
    }
    if (parts.isEmpty) return null;
    // 3. select an approriate part
    for (final element in parts) {
      if (element.part == part) {
        toeicPart = element;
        break;
      }
    }
    if (toeicPart == null) {
      return null;
    }
    // 4. check if the part is Question or GroupQuestion

    if ([1, 2, 5].contains(part)) {
      if (toeicPart.part125!.length < limit) {
        return null;
      }
      final list = getRandomElements(toeicPart.part125!, limit);

      return LocalToeicPart(
        part: toeicPart.part,
        part125: list,
        //(toeicPart.part125!..shuffle(Random())).take(limit).toList(),
      );
    } else {
      if (toeicPart.part3467!.length < limit) {
        return null;
      }
      final list = getRandomElements(toeicPart.part3467!, limit);
      return LocalToeicPart(
        part: toeicPart.part,
        part3467:
            list, //(toeicPart.part3467!..shuffle(Random())).take(limit).toList(),
      );
    }
  }

  //
  @override
  void saveResultByPart(
    int part,
    int totalQuestion,
    int totalCorrect,
    Map<String, dynamic> choosenResult,
  ) {
    final List<ToeicResultLocal> result = [];
    // Some temp variables
    bool isContain = false;
    final box = getToeicResultBox();
    final userId = getUserId();

    //1. Get data from local
    final List<dynamic> fromLocal = box.get(userId, defaultValue: []);
    for (final element in fromLocal) {
      result.add(element);
    }
    //2. Add data to local
    for (final element in result) {
      if (element.part == part) {
        element.correct += totalCorrect;
        element.total += totalQuestion;
        element.choosenAnswers.addAll(element.choosenAnswers);
        element.choosenAnswers.addAll(choosenResult);
        isContain = true;
        break;
      }
    }
    if (!isContain) {
      result.add(ToeicResultLocal(
        part: part,
        total: totalQuestion,
        correct: totalCorrect,
        choosenAnswers: choosenResult,
      ));
    }
    box.put(userId, result);
  }

  @override
  ToeicResultLocal? getResultByPartFromLocal(int part) {
    final List<ToeicResultLocal> result = [];
    final box = getToeicResultBox();
    final userId = getUserId();
    final List<dynamic> fromLocal = box.get(userId, defaultValue: []);
    result.addAll(fromLocal.cast<ToeicResultLocal>());
    for (final element in result) {
      if (element.part == part) {
        return element;
      }
    }
    return null;
  }
}
