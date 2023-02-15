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

  Future<VocabInfo?> getVocabFromServer(int id) async {
    final vocab = await _vocabSource.getVocabById(id);
    return vocab.data;
  }

  Future<List<VocabInfo>?> getVocabListFromServer(List<int> ids) async {
    final vocabList = await _vocabSource.getVocabsByIdList(ids);
    return vocabList.data;
  }

  void addToMyDictionary(LocalVocabInfo dictionary) async {
    _vocabLocalSource.addToMyDictionary(dictionary);
  }

  List<LocalVocabInfo> getAll() {
    return _vocabLocalSource.getAllFromDictionary();
  }

  void deleteAtKey(int id) {
    _vocabLocalSource.deleteAtKey(id);
  }

  LocalVocabInfo? getVocabFromLocal(int id) {
    return _vocabLocalSource.getVocabFromLocalbyId(id);
  }

  void addVocabToLocal(LocalVocabInfo vocab) {
    _vocabLocalSource.addVocabToLocal(vocab);
  }

  void getVocabList(List<int> ids) {
    final listVocabsFromLocal = _vocabLocalSource.getVocabsByListId(ids);
    if (listVocabsFromLocal.length != ids.length) {}
  }

  Box getMyDictionaryBox() => _vocabLocalSource.getMyDictionaryBox();
}
