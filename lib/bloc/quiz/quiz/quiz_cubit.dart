import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/data/repositories/quiz_repository.dart';
import 'package:bke/presentation/pages/uitest/component/map_object.dart';
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
            answerChoosen: List.generate(
                response.tests[0].answer!.split("").length, (index) => "")),
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

  void updateData() {
    final MapObjectLocal currentObject =
        instance.getMapObjectById(state.quizId!)!;
    instance.upSertListMapObject(
      currentObject.copyWith(total: state.totalCorrect, type: state.type),
    );
    final MapObjectLocal nextObject =
        instance.getMapObjectById(state.quizId! + 1)!;
    instance.upSertListMapObject(
      nextObject.copyWith(isDone: true),
    );
  }

  void setInitial() => emit(QuizState.initial());

  void onGame2Erase() {
    int wordIndex = state.wordIndex!;
    List<String> answerChosenList = state.answerChoosen!;
    if (wordIndex >= 0) {
      emit(state.copyWith(status: QuizStatus.loading));
      answerChosenList.removeAt(wordIndex);
      answerChosenList.add("");
      if (wordIndex > 0) {
        wordIndex = wordIndex - 1;
      }
      emit(state.copyWith(
        status: QuizStatus.done,
        answerChoosen: answerChosenList,
        wordIndex: wordIndex,
      ));
    }
  }

  void onAnswerGame2Clear(int index) {
    int wordIndex = state.wordIndex!;
    List<String> answerChosenList = state.answerChoosen!;
    if (wordIndex >= 0) {
      emit(state.copyWith(status: QuizStatus.loading));
      answerChosenList.removeAt(index);
      answerChosenList.add("");
      if (wordIndex > 0) {
        wordIndex = wordIndex - 1;
      }
      emit(state.copyWith(
        status: QuizStatus.done,
        answerChoosen: answerChosenList,
        wordIndex: wordIndex,
      ));
    }
  }

  void onChosenGame2(int index, String userAnswer) {
    int wordIndex = state.wordIndex!;
    List<String> answerChosenList = state.answerChoosen!;
    if (wordIndex >= 0 && wordIndex <= answerChosenList.length - 1) {
      if (answerChosenList[wordIndex] == "") {
        emit(state.copyWith(status: QuizStatus.loading));
        answerChosenList[wordIndex] = userAnswer;
        emit(state.copyWith(
          status: QuizStatus.done,
          answerChoosen: answerChosenList,
          wordIndex: wordIndex < answerChosenList.length - 1
              ? wordIndex + 1
              : wordIndex,
        ));
      }
    }

    if (wordIndex > answerChosenList.length - 1) {
      return;
    }
  }

  void onChosen(int index, String userAnswer) {
    emit(state.copyWith(status: QuizStatus.loading));
    final serverAnswer = state.quizMC![state.currentIndex!].answer;
    if (userAnswer == serverAnswer) {
      final answerList = state.answerCorrectColor;
      answerList![index] = true;
      emit(state.copyWith(
        totalCorrect: state.totalCorrect! + 1,
        answerCorrectColor: answerList,
      ));
    } else if (state.totalCorrect! >= 0) {
      final answerList = state.answerCorrectColor;
      final trueAnsIndex =
          state.quizMC![state.currentIndex!].vocabAns!.indexOf(serverAnswer!);
      answerList![trueAnsIndex] = true;
      emit(state.copyWith(answerCorrectColor: answerList));
    }
    emit(state.copyWith(status: QuizStatus.done, allowReChoose: false));
  }

  void onSubmitGame1() {
    emit(state.copyWith(status: QuizStatus.loading));
    if (state.currentIndex! < state.total! - 1) {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex! + 1,
          status: QuizStatus.done,
          answerCorrectColor: [false, false, false, false],
          allowReChoose: true,
        ),
      );
    } else {
      instance.saveResultToLocal(state.quizId!, state.totalCorrect!);
      emit(state.copyWith(status: QuizStatus.finished));
    }
  }

  void onSubmitGame2() {
    emit(state.copyWith(status: QuizStatus.loading));
    if (state.currentIndex! < state.total! - 1) {
      final String userAnswer = state.answerChoosen!.join("");
      final String questionAnswer =
          state.quizMC![state.currentIndex!].answer!.split(",").join("");
      final isTrue = userAnswer == questionAnswer;
      emit(
        state.copyWith(
          currentIndex: state.currentIndex! + 1,
          status: QuizStatus.done,
          answerChoosen: List.generate(
              state.quizMC![state.currentIndex!].answer!.split("").length,
              (index) => ""),
          wordIndex: 0,
          totalCorrect: isTrue ? state.totalCorrect! + 1 : state.totalCorrect!,
        ),
      );
    } else {
      instance.saveResultToLocal(state.quizId!, state.totalCorrect!);
      emit(state.copyWith(status: QuizStatus.finished));
    }
  }
}
