import '../data_source/remote/game/game_source.dart';
import '../models/network/base_response.dart';
import '../models/quiz/game.dart';

class GameRepository {
  late final GameSource _gameSource;
  GameRepository._internal() {
    _gameSource = GameSourceImpl();
  }
  static final _instance = GameRepository._internal();

  factory GameRepository.instance() => _instance;
  Future<BaseResponse<Game>> getGame() async {
    return _gameSource.getGame();
  }
}
