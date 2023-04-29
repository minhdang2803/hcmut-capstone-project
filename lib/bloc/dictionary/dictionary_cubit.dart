
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/repositories/dictionary_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  DictionaryCubit() : super(DictionaryState.initial());

  final instance = DictionaryRepository.instance();

  Future<void> getDictionaryData() async {
    try {
      emit(state.copyWith(status: DictionaryStatus.loading));
      final response = await instance.getDictionary();
      emit(state.copyWith(status: DictionaryStatus.done, vocabList: response));
    } on RemoteException catch (error) {
      emit(DictionaryState.initial());
      emit(
        state.copyWith(
            status: DictionaryStatus.fail, errorMessage: error.errorMessage),
      );
    }
  }

  Future<void> findWord(String word) async {
    try {
      emit(state.copyWith(status: DictionaryStatus.loading));
      final response = await instance.findWord(word);
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(status: DictionaryStatus.done, vocabList: response));
    } on RemoteException catch (error) {
      emit(DictionaryState.initial());
      emit(
        state.copyWith(
            status: DictionaryStatus.fail, errorMessage: error.errorMessage),
      );
    }
  }
}
