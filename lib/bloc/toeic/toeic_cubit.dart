import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/toeic/toeic_model_local.dart';
import 'package:bke/data/repositories/toeic_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

part 'toeic_state.dart';

Future<LocalToeicPart> getPartFromLocal(Tuple2<int, int> data) {
  final instance = ToeicRepository.instance();
  return instance.getPartFromLocal(data.item1, limit: data.item2);
}

class ToeicCubitPartOne extends Cubit<ToeicStatePartOne> {
  ToeicCubitPartOne() : super(ToeicStatePartOne.initial());

  final instance = ToeicRepository.instance();

  void exit() => emit(ToeicStatePartOne.initial());
  void getQuestions(int part, int limit) async {
    try {
      emit(state.copyWith(status: ToeicStatus.loading));
      final fromLocal = await instance.getPartFromLocal(part, limit: limit);
      emit(state.copyWith(
        part: fromLocal.part,
        status: ToeicStatus.done,
        part125: fromLocal.part125,
        part3467: fromLocal.part3467,
        totalQuestion: limit,
      ));
    } on RemoteException catch (error) {
      emit(ToeicStatePartOne.initial());
      emit(
        state.copyWith(status: ToeicStatus.fail, errorMessage: error.message),
      );
    }
  }

  Future<void> checkAnswerPart1(String userAnswer, int questionIndex) async {
    emit(state.copyWith(status: ToeicStatus.loading));
    final answer = state.part125![state.currentIndex!].correctAnswer!;
    final answerList = List<bool>.generate(4, (index) => false);
    if (userAnswer.replaceAll(".", "") == answer) {
      answerList[questionIndex] = true;
      emit(
        state.copyWith(
          isAnswerCorrect: true,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect! + 1,
          chosenIndex: questionIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isAnswerCorrect: false,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect!,
          chosenIndex: questionIndex,
        ),
      );
    }
    await Future.delayed(const Duration(seconds: 1));
    if (state.currentIndex! >= state.part125!.length - 1) {
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          currentIndex: state.currentIndex! + 1,
        ),
      );
    }
  }
}
