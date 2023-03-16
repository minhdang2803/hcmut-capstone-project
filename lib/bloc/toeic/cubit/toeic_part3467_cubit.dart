// import 'package:bke/bloc/cubit/count_down_cubit.dart';
// import 'package:bke/data/models/network/cvn_exception.dart';
// import 'package:bke/data/models/toeic/toeic_models.dart';
// import 'package:bke/data/repositories/toeic_repository.dart';
// import 'package:bke/data/services/audio_service.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// part 'toeic_part3467_state.dart';

// class ToeicPart3467Cubit extends Cubit<ToeicPart3467State> {
//   ToeicPart3467Cubit() : super(ToeicPart3467State.initial());
//   final instance = ToeicRepository.instance();
//   void setTimer(int part, bool isReal, AudioService audio) {
//     emit(state.copyWith(isReal: isReal, status: Toeic3467status.loading));
//     switch (part) {
//       case 3:
//         audio.setAudio(state.part3467![0].mp3Url!);
//         state.timer!.start(25);
//         break;
//     }
//     emit(state.copyWith(isReal: isReal, status: Toeic3467status.done));
//   }

//   void resumeCountDown(AudioService audio) {
//     audio.playOrPause();
//     state.timer!.resume();
//   }

//   void stopCountDown(AudioService audio) {
//     audio.playOrPause();
//     state.timer!.pause();
//   }

//   void exit() => emit(ToeicPart3467State.initial());
//   void getQuestions(int part, int limit) async {
//     try {
//       emit(state.copyWith(status: Toeic3467status.loading));
//       final fromLocal = await instance.getPartFromLocal(part, limit: limit);
//       emit(state.copyWith(
//         part: fromLocal.part,
//         status: Toeic3467status.done,
//         part3467: fromLocal.part3467,
//         totalQuestion: limit,
//       ));
//     } on RemoteException catch (error) {
//       emit(ToeicPart3467State.initial());
//       emit(
//         state.copyWith(
//             status: Toeic3467status.fail, errorMessage: error.message),
//       );
//     }
//   }

//   // Future<void> autoCheckAnswerPart1(AudioService audio,
//   //     AnimationController animation, BuildContext context) async {
//   //   audio.stop();
//   //   state.timer!.reset();
//   //   emit(state.copyWith(status: Toeic3467status.loading));
//   //   final answer =
//   //       state.part3467![state.currentIndex!].correctAnswer!.replaceAll(".", '');
//   //   emit(
//   //     state.copyWith(
//   //       status: Toeic3467status.done,
//   //       isAnswerCorrect: false,
//   //       totalCorrect: state.totalCorrect!,
//   //     ),
//   //   );
//   //   WidgetUtil.showSnackBar(context, "Correct answer is: $answer");
//   //   if (state.currentIndex! >= state.part3467!.length - 1) {
//   //     emit(state.copyWith(status: Toeic3467status.finish));
//   //   } else {
//   //     emit(
//   //       state.copyWith(currentIndex: state.currentIndex! + 1),
//   //     );
//   //     await audio.setAudio(state.part3467![state.currentIndex!].mp3Url!);
//   //     animation.reset();
//   //     animation.forward();
//   //     state.timer!.start(25);
//   //     audio.play();
//   //   }
//   // }

//   Future<void> checkAnswerPart3({
//     required String userAnswer,
//     required int questionIndex,
//     required int answerIndex,
//     required AudioService audio,
//     required AnimationController animation,
//   }) async {
//     audio.stop();
//     state.timer!.reset();
//     emit(state.copyWith(status: Toeic3467status.loading));
//     final answer = state
//         .part3467![state.currentIndex!].questions![questionIndex].correctAnswer;

//     // check each answer in each small question chosen
//     final answerList = List<List<bool>>.generate(
//       3,
//       (index) => List<bool>.generate(4, (i) => false),
//     );

//     // check each small question is answered
//     final answerChoosenList = List<bool>.generate(4, (index) => false);

//     if (userAnswer[0] == answer) {
//       answerList[questionIndex][answerIndex] = true;
//       answerChoosenList[questionIndex] = true;
//       emit(
//         state.copyWith(
//           status: Toeic3467status.done,
//           isAnswerCorrect: answerChoosenList,
//           answerPart3467: answerList,
//           totalCorrect: state.totalCorrect! + 1,
//           chosenIndex125: questionIndex,
//         ),
//       );
//     } else {
//       emit(
//         state.copyWith(
//           status: Toeic3467status.done,
//           isAnswerCorrect: answerChoosenList,
//           answerPart3467: answerList,
//           totalCorrect: state.totalCorrect!,
//           chosenIndex125: questionIndex,
//         ),
//       );
//     }
//     instance.saveToeicResultByPart(
//         part: state.part!,
//         totalQuestion: state.totalQuestion!,
//         totalCorrect: state.totalCorrect!,
//         chosenResult: {
//           state.part3467![state.currentIndex!].id!.toString(): userAnswer[0],
//         });
//     await Future.delayed(const Duration(seconds: 1));
//     //Last question
//     if (state.currentIndex! >= state.part3467!.length - 1) {
//       emit(state.copyWith(status: Toeic3467status.finish));
//     } else {
//       // Not the last question
//       emit(
//         state.copyWith(currentIndex: state.currentIndex! + 1),
//       );
//       await audio.setAudio(state.part3467![state.currentIndex!].mp3Url!);
//       animation.reset();
//       animation.forward();
//       state.timer!.start(25);
//       audio.play();
//     }
//   }

//   // Future<void> checkAnswerPart5(String userAnswer, int questionIndex,
//   //     AudioService audio, AnimationController animation) async {
//   //   state.timer!.reset();
//   //   emit(state.copyWith(status: Toeic3467status.loading));
//   //   final answer = state.part3467![state.currentIndex!].correctAnswer!;
//   //   final answerList = List<bool>.generate(4, (index) => false);

//   //   if (userAnswer[0] == answer) {
//   //     answerList[questionIndex] = true;
//   //     emit(
//   //       state.copyWith(
//   //         status: Toeic3467status.done,
//   //         isAnswerCorrect: true,
//   //         answerPart3467: answerList,
//   //         totalCorrect: state.totalCorrect! + 1,
//   //         chosenIndex: questionIndex,
//   //       ),
//   //     );
//   //   } else {
//   //     emit(
//   //       state.copyWith(
//   //         status: Toeic3467status.done,
//   //         isAnswerCorrect: false,
//   //         answerPart3467: answerList,
//   //         totalCorrect: state.totalCorrect!,
//   //         chosenIndex: questionIndex,
//   //       ),
//   //     );
//   //   }
//   //   instance.saveToeicResultByPart(
//   //       part: state.part!,
//   //       totalQuestion: state.totalQuestion!,
//   //       totalCorrect: state.totalCorrect!,
//   //       chosenResult: {
//   //         state.part3467![state.currentIndex!].id!.toString(): userAnswer,
//   //       });
//   //   await Future.delayed(const Duration(seconds: 1));
//   //   if (state.currentIndex! >= state.part3467!.length - 1) {
//   //     emit(state.copyWith(status: Toeic3467status.finish));
//   //   } else {
//   //     emit(
//   //       state.copyWith(
//   //         currentIndex: state.currentIndex! + 1,
//   //       ),
//   //     );
//   //     animation.reset();
//   //     animation.forward();
//   //     state.timer!.start(25);
//   //   }
//   // }

//   // void deleteDataToServer() {
//   //   instance.saveToeicResultByPart(
//   //     part: state.part!,
//   //     totalQuestion: state.totalQuestion!,
//   //     totalCorrect: state.totalCorrect!,
//   //     chosenResult: {},
//   //   );
//   // }
// }
