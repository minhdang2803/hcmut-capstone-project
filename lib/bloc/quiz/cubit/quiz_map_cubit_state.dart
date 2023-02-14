part of 'quiz_map_cubit_cubit.dart';

enum QuizStatus { loading, initial, done, fail }

class QuizMapState extends Equatable {
  QuizMapState({
    this.time,
    this.total,
    this.type,
    this.quizMC,
    // this.quizWord,
    this.status,
    this.errorMessage,
  });

  late final QuizStatus? status;
  late final int? time;
  late final int? total;
  late final GameType? type;
  late final List<QuizMultipleChoiceModel>? quizMC;
  // late final List<QuizChoseWordModel>? quizWord;
  late final String? errorMessage;

  QuizMapState.initial() {
    status = QuizStatus.initial;
    time = 30;
    total = 10;
    type = null;
    quizMC = [];
    errorMessage = '';
    // quizWord = [];
  }

  QuizMapState copyWith({
    QuizStatus? status,
    int? time,
    int? total,
    GameType? type,
    List<QuizMultipleChoiceModel>? quizMC,
    // List<QuizChoseWordModel>? quizWord,
    String? errorMessage,
  }) {
    return QuizMapState(
      quizMC: quizMC ?? this.quizMC,
      // quizWord: quizWord ?? this.quizWord,
      time: time ?? this.time,
      total: total ?? this.total,
      type: type ?? this.type,
      status: status ?? this.status,
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
        // quizWord
      ];
}
