import 'package:bke/bloc/countdown_cubit/count_down_cubit.dart';

import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/toeic/toeic_model_local.dart';
import 'package:bke/data/repositories/toeic_repository.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/utils/widget_util.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'toeic_state.dart';

class ToeicCubitPartOne extends Cubit<ToeicStatePartOne> {
  ToeicCubitPartOne() : super(ToeicStatePartOne.initial());

  final instance = ToeicRepository.instance();
  void setTimer(int part, bool isReal, AudioService audio) {
    emit(state.copyWith(isReal: isReal, status: ToeicStatus.loading));
    switch (part) {
      case 1:
        audio.setAudio(state.part125![0].mp3Url!);
        state.timer!.start(25);
        break;
      case 2:
        audio.setAudio(state.part125![0].mp3Url!);
        state.timer!.start(25);
        break;
      case 3:
        audio.setAudio(state.part3467![0].mp3Url!);
        state.timer!.start(90);
        break;
      case 4:
        audio.setAudio(state.part3467![0].mp3Url!);
        state.timer!.start(90);
        break;
      case 5:
        state.timer!.start(25);
        break;
      case 6:
        state.timer!.start(200);
        break;
      case 7:
        state.timer!.start(200);
        break;
    }
    emit(state.copyWith(isReal: isReal, status: ToeicStatus.done));
  }

  void resumeCountDown(AudioService audio) {
    audio.playOrPause();
    state.timer!.resume();
  }

  void stopCountDown(AudioService audio) {
    audio.playOrPause();
    state.timer!.pause();
  }

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

  Future<void> autoCheckAnswerPart1(AudioService audio,
      AnimationController animation, BuildContext context) async {
    audio.stop();
    state.timer!.reset();
    emit(state.copyWith(status: ToeicStatus.loading));
    final answer =
        state.part125![state.currentIndex!].correctAnswer!.replaceAll(".", '');
    emit(
      state.copyWith(
        status: ToeicStatus.done,
        isAnswer125Correct: false,
        totalCorrect: state.totalCorrect!,
      ),
    );
    WidgetUtil.showSnackBar(context, "Correct answer is: $answer");
    if (state.currentIndex! >= state.part125!.length - 1) {
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      emit(
        state.copyWith(currentIndex: state.currentIndex! + 1),
      );
      await audio.setAudio(state.part125![state.currentIndex!].mp3Url!);
      animation.reset();
      animation.forward();
      state.timer!.start(25);
      audio.play();
    }
  }

  Future<void> checkAnswerPart125(String userAnswer, int questionIndex,
      AudioService audio, AnimationController animation) async {
    audio.stop();
    state.timer!.reset();
    emit(state.copyWith(status: ToeicStatus.loading));
    final answer = state.part125![state.currentIndex!].correctAnswer!;
    final answerList = List<bool>.generate(4, (index) => false);

    if (userAnswer.replaceAll(".", "") == answer) {
      answerList[questionIndex] = true;
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer125Correct: true,
          answerPart125: answerList,
          totalCorrect: state.totalCorrect! + 1,
          chosenIndex125: questionIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer125Correct: false,
          answerPart125: answerList,
          totalCorrect: state.totalCorrect!,
          chosenIndex125: questionIndex,
        ),
      );
    }
    instance.saveToeicResultByPart(
        part: state.part!,
        totalQuestion: state.totalQuestion!,
        totalCorrect: state.totalCorrect!,
        chosenResult: {
          state.part125![state.currentIndex!].id!.toString(): userAnswer[0],
        });
    await Future.delayed(const Duration(seconds: 1));
    if (state.currentIndex! >= state.part125!.length - 1) {
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex! + 1,
        ),
      );
      await audio.setAudio(state.part125![state.currentIndex!].mp3Url!);
      animation.reset();
      animation.forward();
      state.timer!.start(25);
      audio.play();
    }
  }

  Future<void> checkAnswerPart5(String userAnswer, int questionIndex,
      AudioService audio, AnimationController animation) async {
    state.timer!.reset();
    emit(state.copyWith(status: ToeicStatus.loading));
    final answer = state.part125![state.currentIndex!].correctAnswer!;
    final answerList = List<bool>.generate(4, (index) => false);

    if (userAnswer[0] == answer) {
      answerList[questionIndex] = true;
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer125Correct: true,
          answerPart125: answerList,
          totalCorrect: state.totalCorrect! + 1,
          chosenIndex125: questionIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer125Correct: false,
          answerPart125: answerList,
          totalCorrect: state.totalCorrect!,
          chosenIndex125: questionIndex,
        ),
      );
    }
    instance.saveToeicResultByPart(
        part: state.part!,
        totalQuestion: state.totalQuestion!,
        totalCorrect: state.totalCorrect!,
        chosenResult: {
          state.part125![state.currentIndex!].id!.toString(): userAnswer[0],
        });
    await Future.delayed(const Duration(seconds: 1));
    if (state.currentIndex! >= state.part125!.length - 1) {
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex! + 1,
        ),
      );
      animation.reset();
      animation.forward();
      state.timer!.start(25);
    }
  }

  void deleteDataToServer() {
    instance.saveToeicResultByPart(
      part: state.part!,
      totalQuestion: state.totalQuestion!,
      totalCorrect: state.totalCorrect!,
      chosenResult: {},
    );
  }

  Future<void> checkAnswerPart3({
    required String userAnswer,
    required int questionIndex,
    required int answerIndex,
    required AudioService audio,
    required AnimationController animation,
    required int totalQuestion,
    required int time,
    TabController? tabController,
  }) async {
    int count = 0;
    for (final element in state.isAnswer3467Correct!) {
      if (element != null) {
        count++;
      }
    }
    if (count == totalQuestion - 1) {
      audio.stop();
      state.timer!.reset();
    }

    emit(state.copyWith(status: ToeicStatus.loading));
    final answer = state
        .part3467![state.currentIndex!].questions![questionIndex].correctAnswer;
    // check each small question is answered
    final answerChoosenList = state.isAnswer3467Correct!;
    // Chosen answer for each question
    final chosenIndexByQuestion = state.chosenIndex3467!;
    if (userAnswer[0] == answer) {
      answerChoosenList[questionIndex] = true;
      chosenIndexByQuestion[questionIndex] = answerIndex;
      emit(state.copyWith(totalChosen: state.totalChosen! + 1));
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer3467Correct: answerChoosenList,
          totalCorrect: state.totalChosen! == totalQuestion
              ? state.totalCorrect! + 1
              : state.totalCorrect!,
          chosenIndex3467: chosenIndexByQuestion,
        ),
      );
    } else {
      answerChoosenList[questionIndex] = false;
      chosenIndexByQuestion[questionIndex] = answerIndex;
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer3467Correct: answerChoosenList,
          totalCorrect: state.totalCorrect!,
          chosenIndex3467: chosenIndexByQuestion,
          totalChosen: state.totalChosen!,
        ),
      );
    }

    // instance.saveToeicResultByPart(
    //     part: state.part!,
    //     totalQuestion: state.totalQuestion!,
    //     totalCorrect: state.totalCorrect!,
    //     chosenResult: {
    //       state.part3467![state.currentIndex!].id!.toString(): userAnswer[0],
    //     });

    int countAnswered = 0;
    for (final element in state.isAnswer3467Correct!) {
      if (element != null) {
        countAnswered++;
      }
    }
    //Last question
    if (countAnswered == totalQuestion &&
        state.currentIndex! >= state.part3467!.length - 1) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      if (countAnswered == totalQuestion) {
        await Future.delayed(const Duration(seconds: 1));
        emit(
          state.copyWith(
            currentIndex: state.currentIndex! + 1,
            isAnswer3467Correct: List<bool?>.generate(4, (index) => null),
            chosenIndex3467: List<int>.generate(4, (index) => -1),
            totalChosen: 0,
          ),
        );
        if (state.part3467![state.currentIndex!].mp3Url != null) {
          await audio.setAudio(state.part3467![state.currentIndex!].mp3Url!);
        }
        animation.reset();
        animation.forward();
        state.timer!.start(90);
        audio.play();
        if (tabController != null) {
          tabController.animateTo(0);
        }
      }
      // Not the last question
    }
  }

  Future<void> checkAnswerPart7({
    required String userAnswer,
    required int questionIndex,
    required int answerIndex,
    required AudioService audio,
    required AnimationController animation,
    required int totalQuestion,
    required int time,
    TabController? tabController,
  }) async {
    int count = 0;
    for (final element in state.isAnswer3467Correct!) {
      if (element != null) {
        count++;
      }
    }
    if (count == totalQuestion - 1) {
      audio.stop();
      state.timer!.reset();
    }

    emit(state.copyWith(status: ToeicStatus.loading));
    final answer = state
        .part3467![state.currentIndex!].questions![questionIndex].correctAnswer;
    // check each small question is answered
    final answerChoosenList = state.isAnswer3467Correct!;
    // Chosen answer for each question
    final chosenIndexByQuestion = state.chosenIndex3467!;
    if (userAnswer[0] == answer) {
      answerChoosenList[questionIndex] = true;
      chosenIndexByQuestion[questionIndex] = answerIndex;
      emit(state.copyWith(totalChosen: state.totalChosen! + 1));
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer3467Correct: answerChoosenList,
          totalCorrect: state.totalChosen! == totalQuestion
              ? state.totalCorrect! + 1
              : state.totalCorrect!,
          chosenIndex3467: chosenIndexByQuestion,
        ),
      );
    } else {
      answerChoosenList[questionIndex] = false;
      chosenIndexByQuestion[questionIndex] = answerIndex;
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswer3467Correct: answerChoosenList,
          totalCorrect: state.totalCorrect!,
          chosenIndex3467: chosenIndexByQuestion,
          totalChosen: state.totalChosen!,
        ),
      );
    }

    // instance.saveToeicResultByPart(
    //     part: state.part!,
    //     totalQuestion: state.totalQuestion!,
    //     totalCorrect: state.totalCorrect!,
    //     chosenResult: {
    //       state.part3467![state.currentIndex!].id!.toString(): userAnswer[0],
    //     });

    int countAnswered = 0;
    for (final element in state.isAnswer3467Correct!) {
      if (element != null) {
        countAnswered++;
      }
    }
    // Not Last Question
    if (countAnswered == totalQuestion &&
        state.currentIndex! >= state.part3467!.length - 1) {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      //Last question
      if (countAnswered == totalQuestion) {
        await Future.delayed(const Duration(seconds: 1));
        emit(
          state.copyWith(
            currentIndex: state.currentIndex! + 1,
            isAnswer3467Correct: List<bool?>.generate(5, (index) => null),
            chosenIndex3467: List<int>.generate(5, (index) => -1),
            totalChosen: 0,
          ),
        );
        if (state.part3467![state.currentIndex!].mp3Url != null) {
          await audio.setAudio(state.part3467![state.currentIndex!].mp3Url!);
        }
        animation.reset();
        animation.forward();
        state.timer!.start(90);
        audio.play();
        if (tabController != null) {
          tabController.animateTo(0);
        }
      }
    }
  }

  Future<void> autoCheckAnswerPart3467({
    required AudioService audio,
    required AnimationController animation,
    required BuildContext context,
    required int time,
    TabController? tabController,
  }) async {
    audio.stop();
    state.timer!.reset();
    emit(state.copyWith(status: ToeicStatus.loading));
    emit(
      state.copyWith(
        status: ToeicStatus.done,
        totalCorrect: state.totalCorrect!,
      ),
    );
    if (state.currentIndex! >= state.part3467!.length - 1) {
      emit(state.copyWith(status: ToeicStatus.finish));
    } else {
      emit(
        state.copyWith(currentIndex: state.currentIndex! + 1),
      );
      await audio.setAudio(state.part3467![state.currentIndex!].mp3Url!);
      animation.reset();
      animation.forward();
      state.timer!.start(time);
      audio.play();
      if (tabController != null) {
        tabController.animateTo(0);
      }
    }
  }
}
