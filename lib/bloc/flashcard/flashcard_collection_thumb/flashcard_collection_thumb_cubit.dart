// import 'package:bke/bloc/flashcard/flashcard_collection_random/flashcard_collection_random_state.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/network/cvn_exception.dart';
import '../../../data/repositories/flashcard_repository.dart';

part 'flashcard_collection_thumb_state.dart';

class FlashcardCollectionThumbCubit
    extends Cubit<FlashcardCollectionThumbState> {
  FlashcardCollectionThumbCubit()
      : super(FlashcardCollectionThumbState.initial());
  final instance = FlashcardRepository.instance();

  void getFlashcardCollections({int? currentCollection}) async {
    try {
      late FlashcardCollectionFromServer? result;
      emit(state.copyWith(status: FlashcardCollectionThumbStatus.loading));
      result = await instance.getRandomCollecionThumbnail();
      emit(state.copyWith(
        listOfFlashcardColection: result!.list,
        status: FlashcardCollectionThumbStatus.success,
      ));
    } on RemoteException catch (error) {
      emit(state.copyWith(
        listOfFlashcardColection: [],
        status: FlashcardCollectionThumbStatus.fail,
        errorMessage: error.errorMessage,
      ));
    }
  }
}
