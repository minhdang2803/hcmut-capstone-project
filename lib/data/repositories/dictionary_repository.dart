import 'package:bke/data/data_source/local/dictionary_local_source.dart';
import 'package:bke/data/models/vocab/vocab.dart';

class DictionaryRepository {
  late final DictionaryLocalSource _local;
  DictionaryRepository._privateConstructor() {
    _local = DictionaryLocalSourceImpl();
  }
  static final _instance = DictionaryRepository._privateConstructor();
  factory DictionaryRepository.instance() => _instance;

  Future<void> importDictionary() {
    return _local.importDictionary();
  }

  Future<List<LocalVocabInfo>> getDictionary() {
    return _local.getLocalDictionary();
  }

  Future<List<LocalVocabInfo>> findWord(String word) {
    return _local.getResult(word);
  }
}
