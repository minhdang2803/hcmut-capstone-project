import 'package:bke/bloc/cubit/count_down_cubit.dart';

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
      case 5:
        state.timer!.start(25);
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
        isAnswerCorrect: false,
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

  Future<void> checkAnswerPart1(String userAnswer, int questionIndex,
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
          isAnswerCorrect: true,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect! + 1,
          chosenIndex: questionIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswerCorrect: false,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect!,
          chosenIndex: questionIndex,
        ),
      );
    }
    instance.saveToeicResultByPart(
        part: state.part!,
        totalQuestion: state.totalQuestion!,
        totalCorrect: state.totalCorrect!,
        chosenResult: {
          state.part125![state.currentIndex!].id!.toString(): userAnswer,
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
          isAnswerCorrect: true,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect! + 1,
          chosenIndex: questionIndex,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ToeicStatus.done,
          isAnswerCorrect: false,
          answerPart1: answerList,
          totalCorrect: state.totalCorrect!,
          chosenIndex: questionIndex,
        ),
      );
    }
    instance.saveToeicResultByPart(
        part: state.part!,
        totalQuestion: state.totalQuestion!,
        totalCorrect: state.totalCorrect!,
        chosenResult: {
          state.part125![state.currentIndex!].id!.toString(): userAnswer,
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
}
