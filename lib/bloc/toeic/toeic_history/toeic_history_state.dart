part of 'toeic_history_cubit.dart';

enum ToeicHistoryStatus { initial, loading, done, fail, finish }

class ToeicHistoryState extends Equatable {
  ToeicHistoryState({
    this.status,
    this.histories,
    this.errorMessage,
    this.part125,
    this.part3467,
  });
  late final ToeicHistoryStatus? status;
  late final String? errorMessage;
  late final List<ToeicHistory>? histories;
  late final List<ToeicQuestion>? part125;
  late final List<ToeicGroupQuestion>? part3467;

  ToeicHistoryState.initial() {
    status = ToeicHistoryStatus.initial;
    errorMessage = "";
    histories = [];
    part125 = null;
    part3467 = null;
  }

  ToeicHistoryState copyWith({
    ToeicHistoryStatus? status,
    String? errorMessage,
    List<ToeicHistory>? histories,
    List<ToeicQuestion>? part125,
    List<ToeicGroupQuestion>? part3467,
  }) {
    return ToeicHistoryState(
      status: status ?? this.status,
      histories: histories ?? this.histories,
      errorMessage: errorMessage ?? this.errorMessage,
      part125: part125 ?? this.part125,
      part3467: part3467 ?? this.part3467,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        histories,
        part125,
        part3467,
      ];
}
