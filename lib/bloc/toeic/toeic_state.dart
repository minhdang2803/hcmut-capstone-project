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
    // this.answerPart125,
    this.isAnswer125Correct,
    this.isAnswer3467Correct,
    this.chosenIndex125,
    this.chosenIndex3467,
    this.part,
    this.resultByQuestion,
    this.timer,
    this.isReal,
    this.totalChosen,
  });
  ToeicStatePartOne.initial() {
    status = ToeicStatus.initial;
    part125 = [];
    part3467 = [];
    errorMessage = "";
    totalCorrect = 0;
    totalQuestion = 0;
    currentIndex = 0;
    // answerPart125 = List<bool>.generate(4, (index) => false);
    totalChosen = 0;
    isAnswer125Correct = null;
    isAnswer3467Correct = List<bool?>.generate(5, (index) => null);
    chosenIndex125 = -1;
    chosenIndex3467 = List<int?>.generate(5, (index) => -1);
    part = 0;
    resultByQuestion = {};
    timer = CountDownCubit();
    isReal = false;
  }
  late final int? part;
  late final ToeicStatus? status;
  late final List<ToeicQuestionLocal>? part125;
  late final List<ToeicGroupQuestionLocal>? part3467;
  late final String? errorMessage;
  late final int? totalCorrect;
  late final int? totalQuestion;
  late final int? currentIndex;
  // late final List<bool>? answerPart125;
  late final bool? isAnswer125Correct;
  late final List<bool?>? isAnswer3467Correct;
  late final int? chosenIndex125;
  late final List<int?>? chosenIndex3467;
  late final Map<String, dynamic>? resultByQuestion;
  late final CountDownCubit? timer;
  late final bool? isReal;
  late final int? totalChosen;

  ToeicStatePartOne copyWith({
    int? part,
    ToeicStatus? status,
    List<ToeicQuestionLocal>? part125,
    List<ToeicGroupQuestionLocal>? part3467,
    String? errorMessage,
    int? totalCorrect,
    int? totalQuestion,
    int? currentIndex,
    // List<bool>? answerPart125,
    bool? isAnswer125Correct,
    List<bool?>? isAnswer3467Correct,
    int? chosenIndex125,
    List<int?>? chosenIndex3467,
    Map<String, dynamic>? resultByQuestion,
    CountDownCubit? timer,
    bool? isReal,
    int? totalChosen,
  }) {
    return ToeicStatePartOne(
      totalChosen: totalChosen ?? this.totalChosen,
      isReal: isReal ?? this.isReal,
      timer: timer ?? this.timer,
      part: part ?? this.part,
      // answerPart125: answerPart125 ?? this.answerPart125,
      status: status ?? this.status,
      part125: part125 ?? this.part125,
      part3467: part3467 ?? this.part3467,
      errorMessage: errorMessage ?? this.errorMessage,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestion: totalQuestion ?? this.totalQuestion,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswer125Correct: isAnswer125Correct,
      isAnswer3467Correct: isAnswer3467Correct ?? this.isAnswer3467Correct,
      chosenIndex125: chosenIndex125 ?? this.chosenIndex125,
      chosenIndex3467: chosenIndex3467 ?? this.chosenIndex3467,
      resultByQuestion: resultByQuestion ?? this.resultByQuestion,
    );
  }

  @override
  List<Object?> get props => [
        isReal,
        part,
        status,
        part125,
        part3467,
        totalCorrect,
        totalQuestion,
        errorMessage,
        currentIndex,
        // answerPart125,
        isAnswer125Correct,
        isAnswer3467Correct,
        chosenIndex125,
        chosenIndex3467,
        resultByQuestion,
        timer,
        totalChosen,
      ];
}
