part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();
}

class GameInitial extends GameState {
  @override
  List<Object> get props => [];
}

class GameLoading extends GameState {
  @override
  List<Object> get props => [];
}

class GameSuccess extends GameState {
  const GameSuccess(this.game);

  final Game? game;

  @override
  List<Object?> get props => [game];
}

class GameFailure extends GameState {
  const GameFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;
  @override
  List<Object?> get props => [errorCode, errorMessage];
}
