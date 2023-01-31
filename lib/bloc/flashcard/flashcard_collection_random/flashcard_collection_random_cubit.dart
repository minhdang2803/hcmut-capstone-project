// import 'package:bke/bloc/flashcard/flashcard_collection_random/flashcard_collection_random_state.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/network/cvn_exception.dart';
import '../../../data/repositories/flashcard_repository.dart';

part 'flashcard_collection_random_state.dart';

class FlashcardCollectionRandomCubit
    extends Cubit<FlashcardCollectionRandomState> {
  FlashcardCollectionRandomCubit()
      : super(FlashcardCollectionRandomState.initial());
  final instance = FlashcardRepository.instance();

  void getFlashcardCollections({int? currentCollection}) async {
    try {
      late FlashCardCollectionFromServer? result;
      emit(state.copyWith(status: FlashcardCollectionRandomStatus.loading));
      result = await instance.getRandomCollecion();
      emit(state.copyWith(
        listOfFlashcardColection: result!.list,
        status: FlashcardCollectionRandomStatus.success,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionRandomStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }
}
