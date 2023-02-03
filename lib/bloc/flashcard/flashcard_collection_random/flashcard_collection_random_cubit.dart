import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/repositories/flashcard_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flashcard_collection_random_state.dart';

class FlashcardRandomCubit extends Cubit<FlashcardRandomState> {
  FlashcardRandomCubit() : super(FlashcardRandomState.initial());

  final instance = FlashcardRepository.instance();
  void increaseIndex() {
    emit(state.copyWith(status: FlashcardRandomStatus.loading));
    int currentIndex = state.index!;
    currentIndex =
        currentIndex + 1 < state.flashcards!.length ? currentIndex + 1 : 0;
    emit(state.copyWith(
        status: FlashcardRandomStatus.success, index: currentIndex));
  }

  void decreaseIndex() {
    emit(state.copyWith(status: FlashcardRandomStatus.loading));
    int currentIndex = state.index!;
    currentIndex =
        currentIndex > 0 ? currentIndex - 1 : state.flashcards!.length - 1;
    emit(state.copyWith(
        status: FlashcardRandomStatus.success, index: currentIndex));
  }

  void getRandomFlashcards(String category) async {
    try {
      emit(state.copyWith(status: FlashcardRandomStatus.loading));
      final response = await instance.getRandomCollection(category);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        status: FlashcardRandomStatus.success,
        flashcards: response!.flashcards,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        status: FlashcardRandomStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void exit() {
    emit(FlashcardRandomState.initial());
  }
}
