import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/toeic/toeic_model_local.dart';
import 'package:bke/data/repositories/toeic_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

part 'toeic_state.dart';

Future<LocalToeicPart> getPartFromLocal(Tuple2<int, int> data) {
  final instance = ToeicRepository.instance();
  return instance.getPartFromLocal(data.item1, limit: data.item2);
}

class ToeicCubit extends Cubit<ToeicState> {
  ToeicCubit() : super(ToeicState.initial());

  final instance = ToeicRepository.instance();
  // final ReceivePort receivePort = ReceivePort();

  void getPart(int part, {int limit = 30}) async {
    try {
      emit(state.copyWith(status: ToeicStatus.loading));
      if ([1, 2, 5].contains(part)) {
        await instance.getPart125(part, limit: limit);
      } else {
        await instance.getPart3467(part, limit: limit);
      }

      emit(state.copyWith(status: ToeicStatus.downloadDone));
    } on RemoteException catch (error) {
      emit(
        state.copyWith(status: ToeicStatus.fail, errorMessage: error.message),
      );
    }
  }
}
