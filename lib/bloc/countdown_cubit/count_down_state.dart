part of 'count_down_cubit.dart';

enum CountDownStatus { initial, running, pause, done }

class CountDownState extends Equatable {
  CountDownState({
    this.errorMessage,
    this.status,
    this.timeLeft,
  });

  late final int? timeLeft;
  late final CountDownStatus? status;
  late final String? errorMessage;
  CountDownState.initial() {
    timeLeft = 25;
    status = CountDownStatus.initial;
    errorMessage = "";
  }

  CountDownState copyWith({
    int? timeLeft,
    CountDownStatus? status,
    String? errorMessage,
  }) {
    return CountDownState(
      timeLeft: timeLeft ?? this.timeLeft,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [timeLeft, errorMessage, status];
}
