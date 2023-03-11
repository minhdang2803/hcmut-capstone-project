part of 'toeic_part_cubit.dart';

enum ToeicPartStatus { initial, loading, done, fail }

class ToeicPartState extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  ToeicPartState({
    this.status,
    this.errorMessage,
    this.total,
    this.correct,
  });
  late final ToeicPartStatus? status;
  late final String? errorMessage;
  late final int? total;
  late final int? correct;

  ToeicPartState copyWith({
    ToeicPartStatus? status,
    String? errorMessage,
    int? correct,
    int? total,
  }) {
    return ToeicPartState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      total: total ?? this.total,
      correct: correct ?? this.correct,
    );
  }

  ToeicPartState.initial() {
    status = ToeicPartStatus.initial;
    errorMessage = "";
    total = 0;
    correct = 0;
  }
  @override
  List<Object?> get props => [status, errorMessage];
}
