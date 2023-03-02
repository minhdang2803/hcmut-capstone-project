import 'package:bke/data/data_source/local/local_sources.dart';
import 'package:bke/data/data_source/remote/quiz/quiz_remote_source.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/presentation/pages/quiz/component/map_object.dart';
import 'package:bke/utils/sharedpref.dart';

import '../models/network/base_response.dart';

class QuizRepository {
  late final QuizRemoteSource _remote;
  late final QuizLocalSource _local;
  QuizRepository._internal() {
    _remote = QuizRemoteSourceImpl();
    _local = QuizLocalSourceImpl();
  }
  static final _instance = QuizRepository._internal();
  factory QuizRepository.instance() => _instance;

  //Remote
  Future<QuizMCTests> getMultipleChoicesQuizBylevel(int id) async {
    final fromLocal = _local.getMCTestsFromLocal(id);
    if (fromLocal == null) {
      final fromServer = await _remote.getMultipleChoicesByLevel(id);
      final data = fromServer.data;
      await _local.saveMCTestsToLocal(data!, id);
      return _local.getMCTestsFromLocal(id)!;
    }
    return fromLocal;
  }

  Future<BaseResponse<void>> upsertQuizResultBylevel() async {
    final answers = _local.getResultFromLocal();
    return await _remote.upsertQuizResultBylevel(answers);
  }

  //Local
  void saveResultToLocal(int level, int result) {
    _local.saveResultToLocal(level, result);
  }

  Map<String, dynamic> getResultsFromLocalByLevel(int level) {
    return _local.getResultFromLocalByLevel(level);
  }

  List<Map<String, dynamic>> getResultsFromLocal() {
    return _local.getResultFromLocal();
  }

  Map<String, dynamic> getAnAnswerFromLocal(int level) {
    return _local.getResultFromLocalByLevel(level);
  }

  List<MapObjectLocal> getListMapObject() {
    return _local.getListMapObjectLocal();
  }

  Future<List<QuizAnswerModel>> getResultFromServer() async {
    final clm = await _remote.getScore();
    return clm.data!.listAnswers;
  }

  void upSertListMapObject(MapObjectLocal obj) =>
      _local.upsertMapObjectLocal(obj);
  MapObjectLocal? getMapObjectById(int id) => _local.getMapObjectLocalById(id);

  Future<void> retreiveMapObjectFromServer() async {
    final isSecondTime = await SharedPref.instance.getBool("isSecondTime");
    if (isSecondTime) {
      return;
    } else {
      final clm = await _remote.getScore();
      final data = clm.data!.listAnswers;
      List<MapObjectLocal> listObj = _local.getListMapObjectLocal();
      if (data.isNotEmpty) {
        for (int i = 0; i < listObj.length; i++) {
          if (i > data.length - 1) {
            break;
          } else {
            listObj[i] = listObj[i]
                .copyWith(total: data[i].score, isDone: data[i].isDone);
            _local.upsertMapObjectLocal(listObj[i]);
            if (listObj[i].total == 8) {
              listObj[i + 1] = listObj[i + 1].copyWith(isDone: true);
              _local.upsertMapObjectLocal(listObj[i + 1]);
            }
          }
        }
      }
      await SharedPref.instance.setBool("isSecondTime", true);
    }
  }
}
