import 'package:bke/data/data_source/local/local_sources.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';

import '../data_source/remote/toeic/toeic_source.dart';

class ToeicRepository {
  late final ToeicSource _remote;
  late final ToeicLocalSource _local;
  ToeicRepository._internal() {
    _remote = ToeicSourceImpl();
    _local = ToeicLocalSourceImpl();
  }
  static final _instance = ToeicRepository._internal();

  factory ToeicRepository.instance() => _instance;
  
  Future<void> getPart125(int part, {int limit = 10}) async {
    final response = await _remote.getPart125(part, limit);
    final result = response.data!.listOfQuestions;
    await _local.savePartToLocal(part: part, part125: result);
  }

  Future<void> getPart3467(int part, {int limit = 10}) async {
    final response = await _remote.getPart3467(part, limit);
    final result = response.data!.listOfQuestions;
    await _local.savePartToLocal(part: part, part3467: result);
  }

  Future<LocalToeicPart> getPartFromLocal(int part, {int limit = 10}) async {
    final response = _local.getPartFromLocal(part);
    if (response != null) {
      return response;
    }
    // Case if list of data < limit
    if ([1, 2, 5].contains(part)) {
      await getPart125(part, limit: limit);
      final fromLocal = _local.getPartFromLocal(part, limit: limit);
      return fromLocal!;
    } else {
      await getPart3467(part, limit: limit);
      final fromLocal = _local.getPartFromLocal(part, limit: limit);
      return fromLocal!;
    }
  }

  // Future<BaseResponse> saveScoreToeicP1(
  //   List<int> listQid,
  //   List<String> listUserAnswer,
  // ) async {
  //   return _toeicSource.saveScoreToeicP1(listQid, listUserAnswer);
  // }
}
