part of 'flashcard_collection_random_cubit.dart';

enum FlashcardRandomStatus { initial, loading, success, fail }

class FlashcardRandomState extends Equatable {
  FlashcardRandomState({
    this.index,
    this.category,
    this.imgUrl,
    this.errorMessage,
    this.flashcards,
    this.status,
  });

  FlashcardRandomState.initial() {
    index = 0;
    category = "";
    imgUrl = "";
    errorMessage = "";
    flashcards = [];
    status = FlashcardRandomStatus.initial;
  }
  late final int? index;
  late final String? category;
  late final String? imgUrl;
  late final List<LocalVocabInfo>? flashcards;
  late final String? errorMessage;
  late final FlashcardRandomStatus? status;

  FlashcardRandomState copyWith({
    int? index,
    String? category,
    String? imgUrl,
    List<LocalVocabInfo>? flashcards,
    String? errorMessage,
    FlashcardRandomStatus? status,
  }) {
    return FlashcardRandomState(
      index: index ?? this.index,
      category: category ?? this.category,
      imgUrl: imgUrl ?? this.imgUrl,
      flashcards: flashcards ?? this.flashcards,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        category,
        imgUrl,
        flashcards,
        status,
        errorMessage,
      ];
}
