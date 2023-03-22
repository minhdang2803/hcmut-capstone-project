part of 'toeic_history_cubit.dart';

enum ToeicHistoryStatus { initial, loading, done, fail, finish }

class ToeicHistoryState extends Equatable {
  ToeicHistoryState({
    this.status,
    this.histories,
    this.errorMessage,
  });
  late final ToeicHistoryStatus? status;
  late final String? errorMessage;
  late final List<ToeicHistory>? histories;

  ToeicHistoryState.initial() {
    status = ToeicHistoryStatus.initial;
    errorMessage = "";
    histories = [];
  }

  ToeicHistoryState copyWith({
    ToeicHistoryStatus? status,
    String? errorMessage,
    List<ToeicHistory>? histories,
  }) {
    return ToeicHistoryState(
      status: status ?? this.status,
      histories: histories ?? this.histories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        histories,
      ];
}
