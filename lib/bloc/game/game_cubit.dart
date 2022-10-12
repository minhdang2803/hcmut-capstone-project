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
      LogUtil.error('Login error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const GameFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(GameFailure(e.message));
          break;
        default:
          emit(const GameFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const GameFailure('Please try again later!'));
      LogUtil.error('Login error ', error: e, stackTrace: s);
    }
  }
}
