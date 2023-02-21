import 'dart:math';

import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/repositories/quiz_repository.dart';
import 'package:bke/presentation/pages/uitest/component/map_object.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapState.initial());
  final instance = QuizRepository.instance();
  void getMapObject() {
    try {
      emit(state.copyWith(status: MapStatus.loading));
      final response = instance.getListMapObject();
      emit(state.copyWith(status: MapStatus.done, listMapObject: response));
    } on RemoteException catch (error) {
      emit(MapState.initial());
      emit(state.copyWith(
          status: MapStatus.fail, errorMessage: error.errorMessage));
    }
  }
}