import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerState extends Equatable {
  int? durationInSecond;
  int? totalLoop;
  TimerState.initial(int time) {
    durationInSecond = time;
    totalLoop = 0;
  }
  TimerState({this.durationInSecond, this.totalLoop});
  TimerState copyWith({int? durationInSecond, int? totalLoop}) {
    return TimerState(
        durationInSecond: durationInSecond ?? this.durationInSecond,
        totalLoop: totalLoop ?? this.totalLoop);
  }

  @override
  List<Object?> get props => [totalLoop, durationInSecond];
}

class TimerCubit extends Cubit<TimerState> {
  TimerCubit(int durationInSecond)
      : super(TimerState.initial(durationInSecond));

  Timer? _timer;

  void startCountdown() {
    emit(state.copyWith(totalLoop: state.totalLoop! + 1));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.durationInSecond! > 0) {
        emit(state.copyWith(durationInSecond: state.durationInSecond! - 1));
      } else {
        _timer!.cancel();
      }
    });
  }

  void pauseCountdown() {
    _timer!.cancel();
  }

  void resumeCountdown() {
    startCountdown();
  }

  void resetCountdown(int durationInSeconds) {
    _timer!.cancel();
    emit(state.copyWith(durationInSecond: durationInSeconds));
  }
}
