import 'package:bke/data/data_source/local/local_sources.dart';
import 'package:bke/data/data_source/remote/quiz/quiz_remote_source.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';

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

  //Local
  void saveResultToLocal(int level, int result) {
    _local.saveResultToLocal(level, result);
  }

  List<Map<String, dynamic>> getResultsFromLocal() {
    return _local.getResultsFromLocal();
  }

  Map<String, dynamic> getAnAnswerFromLocal(int level, int quizId) {
    return _local.getAnAnswerFromLocal(level, quizId);
  }
}
