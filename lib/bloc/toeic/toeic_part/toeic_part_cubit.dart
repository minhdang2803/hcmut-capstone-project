import 'package:bke/data/repositories/toeic_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/network/cvn_exception.dart';

part 'toeic_part_state.dart';

class ToeicPartCubit extends Cubit<ToeicPartState> {
  ToeicPartCubit() : super(ToeicPartState.initial());

  final instance = ToeicRepository.instance();
  Future<void> getPart(int part, {int limit = 30}) async {
    try {
      emit(state.copyWith(status: ToeicPartStatus.loading));
      await instance.getPartFromLocal(part, limit: 30);
      emit(state.copyWith(status: ToeicPartStatus.done));
    } on RemoteException catch (error) {
      emit(ToeicPartState.initial());
      emit(
        state.copyWith(
            status: ToeicPartStatus.fail, errorMessage: error.message),
      );
    }
  }
}
