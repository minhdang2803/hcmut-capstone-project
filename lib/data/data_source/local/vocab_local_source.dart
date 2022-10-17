import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/log_util.dart';
import '../../configs/hive_config.dart';
import '../../models/network/cvn_exception.dart';
import '../../models/vocab/vocab.dart';

abstract class VocabLocalSource {
  void addToMyDictionary(LocalVocabInfo dictionary);

  List<LocalVocabInfo> getAll();
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

        LogUtil.debug('Saved dictionary: ${dictionary}');
      }
    } catch (e, s) {
      LogUtil.error('Save dictionary error: $e', error: e, stackTrace: s);
      throw LocalException(
          LocalException.unableSaveDictionary, 'Unable Save dictionary: $e');
    }
  }

  @override
  List<LocalVocabInfo> getAll() {
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
}
