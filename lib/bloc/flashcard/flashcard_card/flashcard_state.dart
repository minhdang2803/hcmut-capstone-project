part of 'flashcard_cubit.dart';

enum FlashcardStatus { init, loading, done, fail }

class FlashcardState extends Equatable {
  FlashcardState({
    required this.index,
    required this.errorMessage,
    required this.flashcards,
    required this.status,
  });
  late int index;
  late List<LocalVocabInfo> flashcards;
  late FlashcardStatus status;
  late String? errorMessage;

  FlashcardState.initial() {
    index = 0;
    errorMessage = "";
    status = FlashcardStatus.init;
    flashcards = [];
  }

  FlashcardState copyWith({
    int? index,
    List<LocalVocabInfo>? flashcards,
    String? errorMessage,
    FlashcardStatus? status,
  }) {
    return FlashcardState(
      index: index ?? this.index,
      flashcards: flashcards ?? this.flashcards,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [flashcards, status, errorMessage!, index];
}
