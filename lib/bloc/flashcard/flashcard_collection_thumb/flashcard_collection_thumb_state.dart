part of 'flashcard_collection_thumb_cubit.dart';

enum FlashcardCollectionThumbStatus { initial, loading, success, fail }

class FlashcardCollectionThumbState extends Equatable {
  late final List<FlashcardCollectionThumbnail>? listOfFlashcardColection;
  late final String? errorMessage;
  late final FlashcardCollectionThumbStatus? status;

  FlashcardCollectionThumbState({
    this.listOfFlashcardColection,
    this.status,
    this.errorMessage,
  });

  FlashcardCollectionThumbState.initial() {
    listOfFlashcardColection = [];
    errorMessage = "";
    status = FlashcardCollectionThumbStatus.initial;
  }
  FlashcardCollectionThumbState copyWith({
    List<FlashcardCollectionThumbnail>? listOfFlashcardColection,
    String? errorMessage,
    FlashcardCollectionThumbStatus? status,
  }) {
    return FlashcardCollectionThumbState(
      listOfFlashcardColection:
          listOfFlashcardColection ?? this.listOfFlashcardColection,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        listOfFlashcardColection,
        status,
        errorMessage,
      ];
}
