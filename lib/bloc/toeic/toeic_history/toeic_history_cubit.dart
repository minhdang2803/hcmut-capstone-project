import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/data/repositories/toeic_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toeic_history_state.dart';

class ToeicHistoryCubit extends Cubit<ToeicHistoryState> {
  ToeicHistoryCubit() : super(ToeicHistoryState.initial());

  final instance = ToeicRepository.instance();
  Future<void> getHistory() async {
    try {
      emit(state.copyWith(status: ToeicHistoryStatus.loading));
      final response = await instance.getHistory();
      final histories = response!.histories;
      emit(state.copyWith(
          histories: histories, status: ToeicHistoryStatus.done));
    } on RemoteException catch (error) {
      emit(ToeicHistoryState.initial());
      emit(state.copyWith(
          errorMessage: error.errorMessage, status: ToeicHistoryStatus.fail));
    }
  }

  Future<void> getReviewResult(int part, String id) async {
    try {
      emit(state.copyWith(status: ToeicHistoryStatus.loading));
      if ([1, 2, 5].contains(part)) {
        ToeicQuestionResponse response = await instance.getReview125(id);
        emit(state.copyWith(
          status: ToeicHistoryStatus.done,
          part125: response.listOfQuestions,
        ));
      } else {
        ToeicGroupQuestionResponse response = await instance.getReview3467(id);
        emit(state.copyWith(
          status: ToeicHistoryStatus.done,
          part3467: response.listOfQuestions,
        ));
      }
    } on RemoteException catch (error) {
      emit(ToeicHistoryState.initial());
      emit(
        state.copyWith(
            errorMessage: error.errorMessage, status: ToeicHistoryStatus.fail),
      );
    }
  }
}
