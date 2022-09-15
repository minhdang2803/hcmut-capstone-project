import 'package:capstone_project_hcmut/data/network/quizzes/game_source.dart';
import 'package:capstone_project_hcmut/models/models.dart';

class GameRepository {
  late final GameSourceImpl _gameSource;
  GameRepository._internal() {
    _gameSource = GameSourceImpl();
  }
  static final _instance = GameRepository._internal();

  factory GameRepository.instance() => _instance;
  Future<QuizOneResponseModel> getGameLevelOne() async {
    return _gameSource.getGameLevelOne();
  }
}
