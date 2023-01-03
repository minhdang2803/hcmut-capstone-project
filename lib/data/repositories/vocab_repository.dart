import 'package:hive_flutter/hive_flutter.dart';

import '../data_source/local/vocab_local_source.dart';
import '../data_source/remote/vocab/vocab_source.dart';
import '../models/network/base_response.dart';
import '../models/vocab/vocab.dart';

class VocabRepository {
  late final VocabSource _vocabSource;
  late final VocabLocalSource _vocabLocalSource;

  VocabRepository._internal() {
    _vocabSource = VocabSourceImpl();
    _vocabLocalSource = VocabLocalSourceImpl();
  }
  static final _instance = VocabRepository._internal();

  factory VocabRepository.instance() => _instance;
  Future<BaseResponse<VocabInfos>> getVocabInfos(String vocab) async {
    return _vocabSource.getVocabInfos(vocab);
  }

  void addToMyDictionary(LocalVocabInfo dictionary) async {
    _vocabLocalSource.addToMyDictionary(dictionary);
  }

  List<LocalVocabInfo> getAll() {
    return _vocabLocalSource.getAll();
  }

  void deleteAtKey(int id) {
    _vocabLocalSource.deleteAtKey(id);
  }

  Box getMyDictionaryBox() => _vocabLocalSource.getMyDictionaryBox();
}
