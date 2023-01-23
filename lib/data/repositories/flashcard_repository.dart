import 'package:bke/data/data_source/local/flashcard_local_soucre.dart';
import 'package:bke/data/data_source/remote/flashcard/flashcard_remote_source.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/network/base_response.dart';
import 'package:bke/data/models/vocab/vocab.dart';

class FlashcardRepository {
  //Fields and Constructor
  late FCLocalSource _fcLocalSource;
  late FlashcardRemoteSource _fcRemoteSource;
  FlashcardRepository._privateConstructor() {
    _fcLocalSource = FCLocalSourceImpl();
    _fcRemoteSource = FlashcardRemoteSourceImpl();
  }
  static final _instance = FlashcardRepository._privateConstructor();
  factory FlashcardRepository.instance() => _instance;

  //Methods
  void addToCollection(FlashcardCollectionModel flashcardCollection) {
    _fcLocalSource.addCollection(flashcardCollection);
  }

  void deleteCollection(int index) => _fcLocalSource.deleteCollection(index);

  void updateCollectionTitle(String title, int index) =>
      _fcLocalSource.updateCollectionTitle(title, index);

  void updateCollectionImg(String imgUrl, int index) =>
      _fcLocalSource.updateCollectionImg(imgUrl, index);

  List<LocalVocabInfo> addFlashcard(
          LocalVocabInfo vocabInfo, int currentCollection) =>
      _fcLocalSource.addFlashcard(vocabInfo, currentCollection);

  List<LocalVocabInfo> deleteFlashcard(
          int currentCollection, int currentFlashcard) =>
      _fcLocalSource.deleteFlashcard(currentCollection, currentFlashcard);

  List<FlashcardCollectionModel> getFCCollection() =>
      _fcLocalSource.getListOfLCCollections();

  List<LocalVocabInfo> getFlashcards(int currentCollection) {
    return _fcLocalSource.getFlashcards(currentCollection);
  }

  Future<BaseResponse<FlashcardCollectionResponseModel>>
      getFlashcardFromServer() async {
    return await _fcRemoteSource.getAllFlashcardCollection();
  }

  Future<BaseResponse> updateFlashcardToServer(
      List<Map<String, dynamic>> data) async {
    return await _fcRemoteSource.updateToServer(data);
  }

  void saveCollectionToLocal(List<FlashcardCollectionModel> data) =>
      _fcLocalSource.saveCollectionFromServer(data);
}
