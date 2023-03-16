// part of 'toeic_part3467_cubit.dart';

// enum Toeic3467status { initial, loading, done, fail, finish }

// class ToeicPart3467State extends Equatable {
//   ToeicPart3467State({
//     this.status,
//     this.part3467,
//     this.errorMessage,
//     this.totalCorrect,
//     this.totalQuestion,
//     this.currentIndex,
//     this.answerPart3467,
//     this.isAnswerCorrect,
//     this.chosenIndex125,
//     this.part,
//     this.resultByQuestion,
//     this.timer,
//     this.isReal,
//   });
//   ToeicPart3467State.initial() {
//     status = Toeic3467status.initial;
//     part3467 = [];
//     errorMessage = "";
//     totalCorrect = 0;
//     totalQuestion = 0;
//     currentIndex = 0;
//     answerPart3467 = List<List<bool>>.generate(
//       3,
//       (index) => List<bool>.generate(4, (i) => false),
//     );
//     isAnswerCorrect = null;
//     chosenIndex125 = -1;
//     part = 0;
//     resultByQuestion = {};
//     timer = CountDownCubit();
//     isReal = false;
//   }
//   late final int? part;
//   late final Toeic3467status? status;
//   late final List<ToeicGroupQuestionLocal>? part3467;
//   late final String? errorMessage;
//   late final int? totalCorrect;
//   late final int? totalQuestion;
//   late final int? currentIndex;
//   late final List<List<bool>>? answerPart3467;
//   late final List<bool>? isAnswerCorrect;
//   late final int? chosenIndex125;
//   late final Map<String, dynamic>? resultByQuestion;
//   late final CountDownCubit? timer;
//   late final bool? isReal;

//   ToeicPart3467State copyWith({
//     int? part,
//     Toeic3467status? status,
//     List<ToeicGroupQuestionLocal>? part3467,
//     String? errorMessage,
//     int? totalCorrect,
//     int? totalQuestion,
//     int? currentIndex,
//     List<List<bool>>? answerPart3467,
//     List<bool>? isAnswerCorrect,
//     int? chosenIndex125,
//     Map<String, dynamic>? resultByQuestion,
//     CountDownCubit? timer,
//     bool? isReal,
//   }) {
//     return ToeicPart3467State(
//       isReal: isReal ?? this.isReal,
//       timer: timer ?? this.timer,
//       part: part ?? this.part,
//       answerPart3467: answerPart3467 ?? this.answerPart3467,
//       status: status ?? this.status,
//       part3467: part3467 ?? this.part3467,
//       errorMessage: errorMessage ?? this.errorMessage,
//       totalCorrect: totalCorrect ?? this.totalCorrect,
//       totalQuestion: totalQuestion ?? this.totalQuestion,
//       currentIndex: currentIndex ?? this.currentIndex,
//       isAnswerCorrect: isAnswerCorrect,
//       chosenIndex125: chosenIndex125 ?? this.chosenIndex125,
//       resultByQuestion: resultByQuestion ?? this.resultByQuestion,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         isReal,
//         part,
//         status,
//         part3467,
//         totalCorrect,
//         totalQuestion,
//         errorMessage,
//         currentIndex,
//         answerPart3467,
//         isAnswerCorrect,
//         chosenIndex125,
//         resultByQuestion,
//         timer,
//       ];
// }
