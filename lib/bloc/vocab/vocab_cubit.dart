import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/models/vocab/vocab.dart';
import '../../data/repositories/vocab_repository.dart';
import '../../utils/log_util.dart';

part 'vocab_state.dart';

class VocabCubit extends Cubit<VocabState> {
  VocabCubit() : super(VocabInitial());

  final _vocabRepository = VocabRepository.instance();

  void getVocab(String vocab) async {
    try {
      emit(VocabLoading());
      final BaseResponse<VocabInfos> response =
          await _vocabRepository.getVocabInfos(vocab);

      final data = response.data!;
      for (final element in data.list) {
        _vocabRepository.addVocabToLocal(
          LocalVocabInfo(
              vocab: element.vocab,
              vocabType: element.vocabType,
              id: element.id,
              pronounce: element.pronounce,
              translate: element.translate),
        );
      }
      emit(VocabSuccess(data));
      LogUtil.debug('Get vocabulary success ${data.list}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Get vocabulary error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const VocabFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(VocabFailure(e.message));
          break;
        default:
          emit(const VocabFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const VocabFailure('Please try again later!'));
      LogUtil.error('Get vocabulary error ', error: e, stackTrace: s);
    }
  }

  void saveToMyDictionary(LocalVocabInfo vocabInfo) {
    _vocabRepository.addToMyDictionary(vocabInfo);
  }

  void deleteFromMyDictionary(int id) {
    _vocabRepository.deleteAtKey(id);
  }

  void addVocabToLocal(LocalVocabInfo vocab) {
    _vocabRepository.addVocabToLocal(vocab);
  }

  LocalVocabInfo? getVocabFromLocalById(int id) {
    return _vocabRepository.getVocabFromLocal(id);
  }

  List<LocalVocabInfo> getAll() => _vocabRepository.getAll();

  // List<LocalVocabInfo> getAll() => _vocabRepository.getAll();

  Box getUserBox() => _vocabRepository.getMyDictionaryBox();
}
