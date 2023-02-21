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
    this.allowReChoose,
    this.answerChoosen,
    this.wordIndex,
    this.answerCorrectColor,
    this.isCorrectGame2,
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
  late final bool? allowReChoose;
  late final List<String>? answerChoosen;
  late final bool? isCorrectGame2;
  late final List<bool>? answerCorrectColor;

  QuizState.initial() {
    quizId = -1;
    status = QuizStatus.initial;
    time = 30;
    total = 10;
    type = null;
    quizMC = [];
    errorMessage = '';
    currentIndex = 0;
    allowReChoose = true;
    totalCorrect = 0;
    wordIndex = 0;
    answerCorrectColor = [false, false, false, false];
    answerChoosen = [];
    isCorrectGame2 = null;
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
    bool? allowReChoose,
    List<String>? answerChoosen,
    int? wordIndex,
    bool? isCorrectGame2,
    List<bool>? answerCorrectColor,
  }) {
    return QuizState(
      isCorrectGame2: isCorrectGame2,
      answerCorrectColor: answerCorrectColor ?? this.answerCorrectColor,
      wordIndex: wordIndex ?? this.wordIndex,
      answerChoosen: answerChoosen ?? this.answerChoosen,
      quizId: quizId ?? this.quizId,
      allowReChoose: allowReChoose ?? this.allowReChoose,
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
        allowReChoose,
        currentIndex,
        totalCorrect,
        errorMessage,
        answerChoosen,
        wordIndex,
        isCorrectGame2,
        answerCorrectColor
      ];
}
