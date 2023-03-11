import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'count_down_state.dart';

class CountDownCubit extends Cubit<CountDownState> {
  late Timer _timer;

  CountDownCubit() : super(CountDownState.initial());

  void start(int timeInSecond) {
    emit(state.copyWith(
      timeLeft: timeInSecond,
      status: CountDownStatus.initial,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeLeft! > 0) {
        emit(
          state.copyWith(
              timeLeft: state.timeLeft! - 1, status: CountDownStatus.running),
        );
      } else {
        emit(state.copyWith(status: CountDownStatus.done));
      }
    });
    emit(state.copyWith(status: CountDownStatus.done));
  }

  void pause() {
    _timer.cancel();
    emit(state.copyWith(status: CountDownStatus.pause));
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
