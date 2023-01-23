import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/authentication/user.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FCLocalSource {
  void saveCollectionFromServer(List<FlashcardCollectionModel> data);
  void addCollection(FlashcardCollectionModel flashcardCollectionModel);
  List<FlashcardCollectionModel> getListOfLCCollections();
  void deleteCollection(int index);
  void updateCollectionTitle(String title, int index);
  void updateCollectionImg(String imgUrl, int index);
  List<LocalVocabInfo> addFlashcard(LocalVocabInfo vocabInfo, int current);
  List<LocalVocabInfo> deleteFlashcard(
      int currentColection, int currentFlashcard);
  List<LocalVocabInfo> getFlashcards(int currentCollection);
  Box getFCCollectionBoxByUser();
}

class FCLocalSourceImpl extends FCLocalSource {
  @override
  List<FlashcardCollectionModel> getListOfLCCollections() {
    List<FlashcardCollectionModel> result = [];
    final box = getFCCollectionBoxByUser();
    final userId = getUserId();
    final List<dynamic> listOfFCC = box.get(userId, defaultValue: []);
    for (var element in listOfFCC) {
      result.add(element);
    }
    return result;
  }

  @override
  List<LocalVocabInfo> getFlashcards(int currentCollection) {
    final collection = getListOfLCCollections();
    return collection[currentCollection].flashCards;
  }

  @override
  void deleteCollection(int index) {
    final box = getFCCollectionBoxByUser();
    final userId = getUserId();
    final listOfCollection = getListOfLCCollections();
    listOfCollection.removeAt(index);
    box.put(userId, listOfCollection);
  }

  @override
  void addCollection(FlashcardCollectionModel flashcardCollectionModel) {
    final listOfCollection = getListOfLCCollections();
    listOfCollection.add(flashcardCollectionModel);
    final box = getFCCollectionBoxByUser();
    final userId = getUserId();
    box.put(userId, listOfCollection);
  }

  @override
  void updateCollectionImg(String imgUrl, int index) {
    final box = getFCCollectionBoxByUser();
    final userid = getUserId();
    final listOfCollection = getListOfLCCollections();
    listOfCollection[index] = listOfCollection[index].copyWith(imgUrl: imgUrl);
    box.put(userid, listOfCollection);
  }

  @override
  void updateCollectionTitle(String title, int index) {
    final box = getFCCollectionBoxByUser();
    final userid = getUserId();
    final listOfCollection = getListOfLCCollections();
    listOfCollection[index] = listOfCollection[index].copyWith(title: title);
    box.put(userid, listOfCollection);
  }

  @override
  List<LocalVocabInfo> addFlashcard(LocalVocabInfo vocabInfo, int current) {
    final box = getFCCollectionBoxByUser();
    final userid = getUserId();
    final listOfCollection = getListOfLCCollections();
    listOfCollection[current].flashCards.add(vocabInfo);
    box.put(userid, listOfCollection);
    return listOfCollection[current].flashCards;
  }

  @override
  List<LocalVocabInfo> deleteFlashcard(
      int currentColection, int currentFlashcard) {
    final box = getFCCollectionBoxByUser();
    final userid = getUserId();
    final listOfCollection = getListOfLCCollections();
    listOfCollection[currentColection].flashCards.removeAt(currentFlashcard);
    box.put(userid, listOfCollection);
    return listOfCollection[currentColection].flashCards;
  }

  @override
  Box getFCCollectionBoxByUser() {
    final box = Hive.box(HiveConfig.fcByUser);
    return box;
  }

  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  void saveCollectionFromServer(List<FlashcardCollectionModel> data) {
    final box = getFCCollectionBoxByUser();
    final userId = getUserId();
    box.put(userId, data);
    print("clmdasd");
  }
}
