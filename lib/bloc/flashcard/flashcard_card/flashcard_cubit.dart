import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/repositories/flashcard_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit() : super(FlashcardState.initial());

  final instance = FlashcardRepository.instance();

  void increaseIndex() {
    emit(state.copyWith(status: FlashcardStatus.loading));
    int currentIndex = state.index;
    currentIndex =
        currentIndex + 1 < state.flashcards.length ? currentIndex + 1 : 0;
    emit(state.copyWith(status: FlashcardStatus.done, index: currentIndex));
  }

  void decreaseIndex() {
    emit(state.copyWith(status: FlashcardStatus.loading));
    int currentIndex = state.index;
    currentIndex =
        currentIndex > 0 ? currentIndex - 1 : state.flashcards.length - 1;
    emit(state.copyWith(status: FlashcardStatus.done, index: currentIndex));
  }

  void getFlashcard(int currentCollection) {
    try {
      emit(state.copyWith(status: FlashcardStatus.loading));
      final flashcard = instance.getFlashcards(currentCollection);
      emit(state.copyWith(status: FlashcardStatus.done, flashcards: flashcard));
    } on RemoteException catch (error) {
      emit(
        state.copyWith(
            status: FlashcardStatus.fail,
            flashcards: [],
            errorMessage: error.errorMessage),
      );
    }
  }

  void addFlashcard(LocalVocabInfo vocabInfo, int currentCollection) {
    try {
      emit(state.copyWith(status: FlashcardStatus.loading));
      final flashcards = instance.addFlashcard(vocabInfo, currentCollection);
      emit(
          state.copyWith(status: FlashcardStatus.done, flashcards: flashcards));
    } on RemoteException catch (error) {
      emit(
        state.copyWith(
            status: FlashcardStatus.fail,
            flashcards: [],
            errorMessage: error.errorMessage),
      );
    }
  }

  void deleteFlashcard(int currentCollection, int currentFlashcard) {
    try {
      emit(state.copyWith(status: FlashcardStatus.loading));
      final flashcards =
          instance.deleteFlashcard(currentCollection, currentFlashcard);
      int index = state.index;
      if (state.index > 0) {
        index = index - 1;
      }
      emit(state.copyWith(
          status: FlashcardStatus.done, flashcards: flashcards, index: index));
    } on RemoteException catch (error) {
      emit(
        state.copyWith(
            status: FlashcardStatus.fail,
            flashcards: [],
            errorMessage: error.errorMessage),
      );
    }
  }
}
