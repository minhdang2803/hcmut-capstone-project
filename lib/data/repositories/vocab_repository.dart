import '../data_source/remote/vocab/vocab_source.dart';
import '../models/network/base_response.dart';
import '../models/vocab/vocab.dart';

class VocabRepository {
  late final VocabSource _vocabSource;
  VocabRepository._internal() {
    _vocabSource = VocabSourceImpl();
  }
  static final _instance = VocabRepository._internal();

  factory VocabRepository.instance() => _instance;
  Future<BaseResponse<VocabInfos>> getVocabInfos(String vocab) async {
    return _vocabSource.getVocabInfos(vocab);
  }
}
