part of 'flashcard_collection_random_cubit.dart';

enum FlashcardCollectionRandomStatus { initial, loading, success, fail }

class FlashcardCollectionRandomState extends Equatable {
  late final List<FlashCardCollectionRandomModel>? listOfFlashcardColection;
  late final String? errorMessage;
  late final FlashcardCollectionRandomStatus? status;

  FlashcardCollectionRandomState({
    this.listOfFlashcardColection,
    this.status,
    this.errorMessage,
  });

  FlashcardCollectionRandomState.initial() {
    listOfFlashcardColection = [];
    errorMessage = "";
    status = FlashcardCollectionRandomStatus.initial;
  }
  FlashcardCollectionRandomState copyWith({
    List<FlashCardCollectionRandomModel>? listOfFlashcardColection,
    String? errorMessage,
    FlashcardCollectionRandomStatus? status,
  }) {
    return FlashcardCollectionRandomState(
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
