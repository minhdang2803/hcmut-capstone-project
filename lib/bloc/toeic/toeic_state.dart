part of 'toeic_cubit.dart';

enum ToeicStatus { initial, loading, done, fail, downloadDone }

class ToeicState extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  ToeicState({
    this.status,
    this.part125,
    this.part3467,
    this.errorMessage,
    this.totalCorrect,
    this.totalQuestion,
  });
  ToeicState.initial() {
    status = ToeicStatus.initial;
    part125 = [];
    part3467 = [];
    errorMessage = "";
    totalCorrect = 0;
    totalQuestion = 0;
  }
  late final ToeicStatus? status;
  late final List<ToeicQuestionLocal>? part125;
  late final List<ToeicGroupQuestionLocal>? part3467;
  late final String? errorMessage;
  late final int? totalCorrect;
  late final int? totalQuestion;

  ToeicState copyWith({
    ToeicStatus? status,
    List<ToeicQuestionLocal>? part125,
    List<ToeicGroupQuestionLocal>? part3467,
    String? errorMessage,
    int? totalCorrect,
    int? totalQuestion,
  }) {
    return ToeicState(
      status: status ?? this.status,
      part125: part125 ?? this.part125,
      part3467: part3467 ?? this.part3467,
      errorMessage: errorMessage ?? this.errorMessage,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalQuestion: totalQuestion ?? this.totalQuestion,
    );
  }

  @override
  List<Object?> get props => [
        status,
        part125,
        part3467,
        totalCorrect,
        totalQuestion,
        errorMessage,
      ];
}
