import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/repositories/flashcard_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardCollectionState> {
  FlashcardCubit() : super(FlashcardCollectionState.initial());

  final instance = FlashcardRepository.instance();
  void getFlashcardCollections() {
    try {
      emit(state.copyWith(status: FlashcardStatus.loading));
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result, status: FlashcardStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void addFlashcardCollection(FlashcardCollectionModel flashcardCollection) {
    try {
      instance.addToCollection(flashcardCollection);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result, status: FlashcardStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void deleteFlashCardCollection(int index) {
    try {
      instance.deleteCollection(index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result, status: FlashcardStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void updateImg(String imgUrl, int index) {
    try {
      instance.updateImg(imgUrl, index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result, status: FlashcardStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }

  void updateTitle(String title, int index) {
    try {
      instance.updateTitle(title, index);
      final result = instance.getFCCollection();
      emit(state.copyWith(
          listOfFlashcardColection: result, status: FlashcardStatus.success));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardStatus.fail,
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
