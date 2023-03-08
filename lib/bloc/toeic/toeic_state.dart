part of 'toeic_cubit.dart';

enum ToeicStatus { initial, loading, done, fail, finish }

class ToeicStatePartOne extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  ToeicStatePartOne({
    this.status,
    this.part125,
    this.part3467,
    this.errorMessage,
    this.totalCorrect,
    this.totalQuestion,
    this.currentIndex,
    this.answerPart1,
    this.isAnswerCorrect,
    this.chosenIndex,
    this.part,
    this.resultByQuestion,
  });
  ToeicStatePartOne.initial() {
    status = ToeicStatus.initial;
    part125 = [];
    part3467 = [];
    errorMessage = "";
    totalCorrect = 0;
    totalQuestion = 0;
    currentIndex = 0;
    answerPart1 = List<bool>.generate(4, (index) => false);
    isAnswerCorrect = null;
    chosenIndex = -1;
    part = 0;
    resultByQuestion = {};
  }
  late final int? part;
  late final ToeicStatus? status;
  late final List<ToeicQuestionLocal>? part125;
  late final List<ToeicGroupQuestionLocal>? part3467;
  late final String? errorMessage;
  late final int? totalCorrect;
  late final int? totalQuestion;
  late final int? currentIndex;
  late final List<bool>? answerPart1;
  late final bool? isAnswerCorrect;
  late final int? chosenIndex;
  late final Map<String, dynamic>? resultByQuestion;

  ToeicStatePartOne copyWith({
    int? part,
    ToeicStatus? status,
    List<ToeicQuestionLocal>? part125,
    List<ToeicGroupQuestionLocal>? part3467,
    String? errorMessage,
    int? totalCorrect,
    int? totalQuestion,
    int? currentIndex,
    List<bool>? answerPart1,
    bool? isAnswerCorrect,
    int? chosenIndex,
    Map<String, dynamic>? resultByQuestion,
  }) {
    return ToeicStatePartOne(
      part: part ?? this.part,
      answerPart1: answerPart1 ?? this.answerPart1,
      status: status ?? this.status,
      part125: part125 ?? this.part125,
      part3467: part3467 ?? this.part3467,
      errorMessage: errorMessage ?? this.errorMessage,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestion: totalQuestion ?? this.totalQuestion,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerCorrect: isAnswerCorrect,
      chosenIndex: chosenIndex ?? this.chosenIndex,
      resultByQuestion: resultByQuestion ?? this.resultByQuestion,
    );
  }

  @override
  List<Object?> get props => [
        part,
        status,
        part125,
        part3467,
        totalCorrect,
        totalQuestion,
        errorMessage,
        currentIndex,
        answerPart1,
        isAnswerCorrect,
        chosenIndex,
        resultByQuestion,
      ];
}
