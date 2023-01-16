import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/repositories/flashcard_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flashcard_collection_state.dart';

class FlashcardCollectionCubit extends Cubit<FlashcardCollectionState> {
  FlashcardCollectionCubit() : super(FlashcardCollectionState.initial());

  final instance = FlashcardRepository.instance();
  void getFlashcardCollections({int? currentCollection}) {
    try {
      emit(state.copyWith(status: FlashcardCollectionStatus.loading));
      final result = instance.getFCCollection();
      emit(state.copyWith(
        flashcards: currentCollection != null
            ? result[currentCollection].flashcards
            : [],
        listOfFlashcardColection: result,
        status: FlashcardCollectionStatus.success,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void addFlashcardCollection(FlashcardCollectionModel flashcardCollection) {
    try {
      instance.addToCollection(flashcardCollection);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result,
          status: FlashcardCollectionStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void deleteFlashCardCollection(int index) {
    try {
      instance.deleteCollection(index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result,
          status: FlashcardCollectionStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void updateImg(String imgUrl, int index) {
    try {
      instance.updateCollectionImg(imgUrl, index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result,
          status: FlashcardCollectionStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void updateTitle(String title, int index) {
    try {
      instance.updateCollectionTitle(title, index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result,
          status: FlashcardCollectionStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void addFlashcard(
    LocalVocabInfo vocabInfo,
    int index,
  ) {
    try {
      instance.addFlashcard(vocabInfo, index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
        flashcards: result[index].flashcards,
        listOfFlashcardColection: result,
        status: FlashcardCollectionStatus.success,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void deleteFlashcard(int currentCollection, int currentcard) {
    try {
      instance.deleteFlashcard(currentCollection, currentcard);
      final result = instance.getFCCollection();
      emit(state.copyWith(
        flashcards: result[currentCollection].flashcards,
        listOfFlashcardColection: result,
        status: FlashcardCollectionStatus.success,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  List<String> pictures = [
    "assets/images/hi.png",
    "assets/images/full.png",
    "assets/images/proud.png",
    "assets/images/peace.png",
    "assets/images/mocking.png",
    "assets/images/run.png",
    "assets/images/sad.png",
    "assets/images/eat.png",
    "assets/images/love.png",
    "assets/images/yoga.png",
    "assets/images/yawn.png",
    "assets/images/birthday.png",
    "assets/images/relaxed.png",
    "assets/images/no.png",
  ];
}
