part of 'toeic_part_cubit.dart';

enum ToeicPartStatus { initial, loading, done, fail }

class ToeicPartState extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  ToeicPartState({
    this.status,
    this.errorMessage,
  });
  late final ToeicPartStatus? status;
  late final String? errorMessage;

  ToeicPartState copyWith({
    ToeicPartStatus? status,
    String? errorMessage,
  }) {
    return ToeicPartState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  ToeicPartState.initial() {
    status = ToeicPartStatus.initial;
    errorMessage = "";
  }
  @override
  List<Object?> get props => [status, errorMessage];
}
