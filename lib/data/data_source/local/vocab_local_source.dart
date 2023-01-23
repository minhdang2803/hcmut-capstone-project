import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/log_util.dart';
import '../../configs/hive_config.dart';
import '../../models/network/cvn_exception.dart';
import '../../models/vocab/vocab.dart';

abstract class VocabLocalSource {
  void addToMyDictionary(LocalVocabInfo dictionary);
  void addVocabToLocal(LocalVocabInfo vocab);
  LocalVocabInfo? getVocabFromLocalbyId(int id);
  List<LocalVocabInfo> getAllFromDictionary();
  void deleteAtKey(int id);
  Box getMyDictionaryBox();
}

class VocabLocalSourceImpl extends VocabLocalSource {
  @override
  void addToMyDictionary(LocalVocabInfo dictionary) async {
    try {
      final myDictionaryBox = Hive.box(HiveConfig.myDictionary);

      if (!myDictionaryBox.containsKey(dictionary.id)) {
        myDictionaryBox.put(dictionary.id, dictionary);

        LogUtil.debug('Saved dictionary: $dictionary');
      }
    } catch (e, s) {
      LogUtil.error('Save dictionary error: $e', error: e, stackTrace: s);
      throw LocalException(
          LocalException.unableSaveDictionary, 'Unable Save dictionary: $e');
    }
  }

  @override
  List<LocalVocabInfo> getAllFromDictionary() {
    List<LocalVocabInfo> res = [];
    final myDictionaryBox = Hive.box(HiveConfig.myDictionary);
    final myVocabList = myDictionaryBox.values;
    res.addAll(myVocabList.map((e) => e));
    return res;
  }

  @override
  void deleteAtKey(int id) {
    final myDictionaryBox = Hive.box(HiveConfig.myDictionary);
    myDictionaryBox.delete(id);
  }

  @override
  Box getMyDictionaryBox() => Hive.box(HiveConfig.myDictionary);

  @override
  void addVocabToLocal(LocalVocabInfo vocab) {
    try {
      final box = Hive.box(HiveConfig.localVocabs);
      if (!box.containsKey(vocab.id)) {
        box.put(vocab.id, vocab);
        LogUtil.debug('Saved vocab to local: $vocab');
      }
    } on LocalException catch (e, s) {
      LogUtil.error('Save vocab to local error: $e', error: e, stackTrace: s);
      throw LocalException(LocalException.unableSaveDictionary,
          'Unable Save local database: $e');
    }
  }

  @override
  LocalVocabInfo? getVocabFromLocalbyId(int id) {
    final box = Hive.box(HiveConfig.localVocabs);
    final result = box.get(id, defaultValue: null) as LocalVocabInfo?;
    LogUtil.debug('Get vocab from local: $result');
    return result;
  }
}
