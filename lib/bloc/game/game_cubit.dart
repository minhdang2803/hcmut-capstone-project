import 'package:bke/data/models/network/base_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/network/cvn_exception.dart';
import '../../data/models/quiz/game.dart';
import '../../data/repositories/game_repository.dart';
import '../../utils/log_util.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  final _gameRepository = GameRepository.instance();

  void getGame() async {
    try {
      emit(GameLoading());
      final BaseResponse<Game> response = await _gameRepository.getGame();
      final data = response.data!;
      emit(GameSuccess(data));
      LogUtil.debug(
          'Get game success: ${response.data?.toJson() ?? 'empty game'}');
    } on RemoteException catch (e, s) {
      if (e.code == RemoteException.other) {
        emit(GameFailure(e.message));
        return;
      }
      if (e.code == RemoteException.responseError) {
        emit(const GameFailure('Loi nao do'));
        return;
      }
      emit(GameFailure(e.message, errorCode: e.code));
      LogUtil.error('Get game error: ${e.message}', error: e, stackTrace: s);
    }
  }
}
