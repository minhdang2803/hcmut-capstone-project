part of 'flashcard_collection_cubit.dart';

enum FlashcardCollectionStatus { initial, loading, success, fail }

class FlashcardCollectionState extends Equatable {
  late final List<FlashcardCollectionModel>? listOfFlashcardColection;
  late final String? errorMessage;
  late final FlashcardCollectionStatus? status;
  late final List<LocalVocabInfo>? flashcards;

  FlashcardCollectionState({
    this.listOfFlashcardColection,
    this.status,
    this.errorMessage,
    this.flashcards,
  });

  FlashcardCollectionState.initial() {
    listOfFlashcardColection = [];
    flashcards = [];
    errorMessage = "";
    status = FlashcardCollectionStatus.initial;
  }
  FlashcardCollectionState copyWith({
    List<FlashcardCollectionModel>? listOfFlashcardColection,
    String? errorMessage,
    FlashcardCollectionStatus? status,
    List<LocalVocabInfo>? flashcards,
  }) {
    return FlashcardCollectionState(
      listOfFlashcardColection:
          listOfFlashcardColection ?? this.listOfFlashcardColection,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  @override
  List<Object?> get props => [
        listOfFlashcardColection,
        status,
        errorMessage,
      ];
}

// class FlashcardCollectionState extends Equatable {
//   late final String? imgUrl;
//   late final String? title;
//   late final List<LocalVocabInfo>? flashcards;
//   late final FlashcardStatus? status;

//   FlashcardCollectionState({
//     required this.imgUrl,
//     required this.title,
//     required this.flashcards,
//     required this.status,
//   });

//   FlashcardCollectionState.initial() {
//     imgUrl = "";
//     title = "";
//     flashcards = [];
//     status = FlashcardStatus.initial;
//   }
//   FlashcardCollectionState copyWith(String? imgUrl, String? title,
//       List<LocalVocabInfo>? flashcards, FlashcardStatus? status) {
//     return FlashcardCollectionState(
//       imgUrl: imgUrl ?? this.imgUrl,
//       title: title ?? this.title,
//       flashcards: flashcards ?? this.flashcards,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<Object?> get props => [imgUrl, title, flashcards, status];
// }
