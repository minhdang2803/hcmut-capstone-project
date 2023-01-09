import 'package:bke/data/data_source/local/flashcard_local_soucre.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';


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
    _fcLocalSource.add(flashcardCollection);
  }

  void deleteCollection(int index) => _fcLocalSource.delete(index);

  void updateTitle(String title, int index) =>
      _fcLocalSource.updateTitle(title, index);

  void updateImg(String imgUrl, int index) =>
      _fcLocalSource.updateImg(imgUrl, index);

  List<FlashcardCollectionModel> getFCCollection() =>
      _fcLocalSource.getListOfLCCollections();
}
