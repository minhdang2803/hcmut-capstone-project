import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/toeic/toeic_models.dart';

abstract class ToeicLocalSource {
  void savePartToLocal(
      {required int part,
      List<ToeicQuestion>? part125,
      List<ToeicGroupQuestion>? part3467});
}

class ToeicLocalSourceImpl implements ToeicLocalSource {
  Box getToeicPartBox() => Hive.box(HiveConfig.toeicPart);
  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void savePartToLocal({
    required int part,
    List<ToeicQuestion>? part125,
    List<ToeicGroupQuestion>? part3467,
  }) async {
    List<ToeicQuestionLocal>? part125Local;
    List<ToeicGroupQuestionLocal>? part3467Local;
    List<LocalToeicPart> result = [];
    List<int> partOfTest = [];
    bool isInList = false;

    if (part125 != null) {
      part125Local = await ToeicQuestionLocal.fromInternet(part125);
    }
    if (part3467 != null) {
      part3467Local = await ToeicGroupQuestionLocal.fromInternet(part3467);
    }
    final box = getToeicPartBox();
    final userId = getUserId();
    final List<dynamic> fromLocal = box.get(userId);
    for (final element in fromLocal) {
      result.add(element);
      if (!partOfTest.contains(element.part)) {
        partOfTest.add(element.part); //!need check
      }
    }
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
    // for (final element in result) {
    //   if (element.part == partOfTest) {
    //     if (element.part125 != null && part125 != null) {
    //       element.part125!.addAll(part125Local!);
    //     }
    //     if (element.part3467 != null && part3467 != null) {
    //       element.part3467!.addAll(part3467Local!);
    //     }
    //     isInList = true;
    //     break;
    //   }
    // }
    // if (isInList == false) {
    //   result.add(LocalToeicPart(
    //       part: partOfTest, part125: part125Local, part3467: part3467Local));
    // }
    box.put(userId, result);
  }
}
