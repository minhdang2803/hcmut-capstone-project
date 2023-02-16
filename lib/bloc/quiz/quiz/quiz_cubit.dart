import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/data/repositories/quiz_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizState.initial());

  final instance = QuizRepository.instance();

  void getLevel(int level) async {
    try {
      emit(state.copyWith(status: QuizStatus.loading));
      final response = await instance.getMultipleChoicesQuizBylevel(level);
      emit(
        state.copyWith(
          quizId: response.id,
          status: QuizStatus.done,
          type: response.typeOfQuestion,
          total: response.numOfQuestions,
          quizMC: response.tests,
        ),
      );
    } on RemoteException catch (error) {
      emit(QuizState.initial());
      emit(
        state.copyWith(
          status: QuizStatus.fail,
          errorMessage: error.errorMessage,
        ),
      );
    }
  }

  void exit() {
    emit(QuizState.initial());
  }

  void onChosen(int index, String userAnswer) {
    emit(state.copyWith(status: QuizStatus.loading));
    final isChosen = [false, false, false, false];
    emit(state.copyWith(isChosen: isChosen));
    isChosen[index] = true;
    emit(state.copyWith(isChosen: isChosen, status: QuizStatus.done));
    final answer = state.quizMC![state.currentIndex!].answer;
    if (userAnswer == answer) {
      emit(state.copyWith(
        totalCorrect: state.totalCorrect! + 1,
        // status: QuizStatus.done,
      ));
    } else if (state.totalCorrect! > 0) {
      emit(state.copyWith(
        totalCorrect: state.totalCorrect! - 1,
        // status: QuizStatus.done,
      ));
    }
  }

  void onSubmit() {
    emit(state.copyWith(status: QuizStatus.loading));
    if (state.currentIndex! < state.total! - 1) {
      emit(
        state.copyWith(
            currentIndex: state.currentIndex! + 1,
            status: QuizStatus.done,
            isChosen: [
              false,
              false,
              false,
              false,
            ]),
      );
    } else {
      instance.saveResultToLocal(state.quizId!, state.totalCorrect!);
      emit(state.copyWith(status: QuizStatus.finished));
    }
  }
}
