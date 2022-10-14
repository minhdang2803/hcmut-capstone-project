import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/log_util.dart';
import '../../configs/hive_config.dart';
import '../../models/network/cvn_exception.dart';
import '../../models/vocab/vocab.dart';

abstract class VocabLocalSource {
  void saveToDictionary(Dictionary dictionary);

  VocabInfos? getVocab();

  Box getUserBox();
}

class VocabLocalSourceImpl extends VocabLocalSource {
  @override
  void saveToDictionary(Dictionary dictionary) async {
    try {
      final userBox = Hive.box(HiveConfig.userBox);
      userBox.put(HiveConfig.dictionary, dictionary);
      LogUtil.debug('Saved dictionary: ${dictionary}');
    } catch (e, s) {
      LogUtil.error('Save dictionary error: $e', error: e, stackTrace: s);
      throw LocalException(
          LocalException.unableSaveDictionary, 'Unable Save dictionary: $e');
    }
  }

  @override
  VocabInfos? getVocab() {
    final userBox = Hive.box(HiveConfig.userBox);
    return userBox.get(HiveConfig.currentUserKey);
  }

  @override
  Box getUserBox() => Hive.box(HiveConfig.userBox);
}
