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
  Future<QuizMultipleChoiceResponse> getMultipleChoicesQuizBylevel(
      int id) async {
    final response = await _remote.getMultipleChoicesByLevel(id);
    return response.data!;
  }

  //Local
  void saveAnswerToLocal(int level, int quizId, String answer) {
    _local.saveAnswerToLocal(level, quizId, answer);
  }

  Set<Map<String, dynamic>> getAnswersFromLocal() {
    return _local.getAnswersFromLocal();
  }

  Map<String, dynamic> getAnAnswerFromLocal(int level, int quizId) {
    return _local.getAnAnswerFromLocal(level, quizId);
  }
}
