import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/log_util.dart';
import '../../configs/hive_config.dart';
import '../../models/network/cvn_exception.dart';
import '../../models/vocab/vocab.dart';

abstract class VocabLocalSource {
  void addToMyDictionary(LocalVocabInfo dictionary);

  dynamic getAll();
  void delete(LocalVocabInfo dictionary);

  Box getMyDictionaryBox();
}

class VocabLocalSourceImpl extends VocabLocalSource {
  @override
  void addToMyDictionary(LocalVocabInfo dictionary) async {
    try {
      final myDictionaryBox = Hive.box(HiveConfig.myDictionary);
      myDictionaryBox.add(dictionary);
      LogUtil.debug('Saved dictionary: ${dictionary}');
    } catch (e, s) {
      LogUtil.error('Save dictionary error: $e', error: e, stackTrace: s);
      throw LocalException(
          LocalException.unableSaveDictionary, 'Unable Save dictionary: $e');
    }
  }

  @override
  dynamic getAll() {
    final myDictionaryBox = Hive.box(HiveConfig.myDictionary);
    final myVocabList = myDictionaryBox.values;
    return myVocabList;
  }

  @override
  void delete(LocalVocabInfo dictionary) {
    final myDictionaryBox = Hive.box(HiveConfig.myDictionary);
    myDictionaryBox.delete(dictionary);
  }

  @override
  Box getMyDictionaryBox() => Hive.box(HiveConfig.myDictionary);
}
