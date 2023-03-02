import '../data_source/remote/toeic/toeic_source.dart';
import '../models/toeic/toeic_models.dart';

class ToeicRepository {
  late final ToeicSource _remote;
  ToeicRepository._internal() {
    _remote = ToeicSourceImpl();
  }
  static final _instance = ToeicRepository._internal();

  factory ToeicRepository.instance() => _instance;
  Future<List<ToeicQuestion>?> getPart125(int part, {int limit = 10}) async {
    final response = await _remote.getPart125(part, limit);
    return response.data!.listOfQuestions;
  }

  Future<List<ToeicGroupQuestion>> getPart3467(int part,
      {int limit = 10}) async {
    final response = await _remote.getPart3467(part, limit);
    return response.data!.listOfQuestions;
  }
  // Future<BaseResponse> saveScoreToeicP1(
  //   List<int> listQid,
  //   List<String> listUserAnswer,
  // ) async {
  //   return _toeicSource.saveScoreToeicP1(listQid, listUserAnswer);
  // }
}
