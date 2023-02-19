part of 'quiz_cubit.dart';

enum QuizStatus { loading, initial, done, fail, finished }

class QuizState extends Equatable {
  QuizState({
    this.quizId,
    this.time,
    this.total,
    this.type,
    this.quizMC,
    this.totalCorrect,
    this.status,
    this.errorMessage,
    this.currentIndex,
    this.isChosen,
    this.answerChoosen,
    this.wordIndex,
  });

  late final int? wordIndex;
  late final int? quizId;
  late final QuizStatus? status;
  late final int? time;
  late final int? total;
  late final GameType? type;
  late final List<QuizMultipleChoiceLocalModel>? quizMC;
  late final int? totalCorrect;
  late final int? currentIndex;
  late final String? errorMessage;
  late final List<bool>? isChosen;
  late final List<String>? answerChoosen;

  QuizState.initial() {
    quizId = -1;
    status = QuizStatus.initial;
    time = 30;
    total = 10;
    type = null;
    quizMC = [];
    errorMessage = '';
    currentIndex = 0;
    totalCorrect = 0;
    isChosen = [false, false, false, false];
    wordIndex = 0;
    answerChoosen = ["", "", "", ""];
  }

  QuizState copyWith({
    int? quizId,
    QuizStatus? status,
    int? time,
    int? total,
    GameType? type,
    List<QuizMultipleChoiceLocalModel>? quizMC,
    int? totalCorrect,
    int? currentIndex,
    String? errorMessage,
    List<bool>? isChosen,
    List<String>? answerChoosen,
    int? wordIndex,
  }) {
    return QuizState(
      wordIndex: wordIndex ?? this.wordIndex,
      answerChoosen: answerChoosen ?? this.answerChoosen,
      quizId: quizId ?? this.quizId,
      isChosen: isChosen ?? this.isChosen,
      quizMC: quizMC ?? this.quizMC,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      time: time ?? this.time,
      total: total ?? this.total,
      type: type ?? this.type,
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        time,
        type,
        total,
        quizMC,
        currentIndex,
        totalCorrect,
        errorMessage,
        answerChoosen,
        wordIndex,
      ];
}
