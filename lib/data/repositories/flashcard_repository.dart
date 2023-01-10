import 'package:bke/data/data_source/local/flashcard_local_soucre.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/vocab/vocab.dart';

class FlashcardRepository {
  //Fields and Constructor
  late FCLocalSource _fcLocalSource;
  FlashcardRepository._privateConstructor() {
    _fcLocalSource = FCLocalSourceImpl();
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

  void addFlashcard(LocalVocabInfo vocabInfo, int currentCollection) =>
      _fcLocalSource.addFlashcard(vocabInfo, currentCollection);

  void deleteFlashcard(int currentCollection, int currentFlashcard) =>
      _fcLocalSource.deleteFlashcard(currentCollection, currentFlashcard);

  List<FlashcardCollectionModel> getFCCollection() =>
      _fcLocalSource.getListOfLCCollections();
}
