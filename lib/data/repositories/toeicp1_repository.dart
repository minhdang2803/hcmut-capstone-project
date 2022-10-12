import '../data_source/remote/toeic/toeic_source.dart';
import '../models/network/base_response.dart';
import '../models/toeic/toeic_test.dart';

class ToeicP1Repository {
  late final ToeicSource _toeicSource;
  ToeicP1Repository._internal() {
    _toeicSource = ToeicSourceImpl();
  }
  static final _instance = ToeicP1Repository._internal();

  factory ToeicP1Repository.instance() => _instance;
  Future<BaseResponse<ToeicTest>> getToeicP1QandA() async {
    return _toeicSource.getToeicP1QandA();
  }

  Future<BaseResponse> saveScoreToeicP1(
    List<int> listQid,
    List<String> listUserAnswer,
  ) async {
    return _toeicSource.saveScoreToeicP1(listQid, listUserAnswer);
  }
}
