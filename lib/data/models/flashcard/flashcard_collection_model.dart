import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/data_source/local/vocab_local_source.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../data_source/remote/vocab/vocab_source.dart';
part "flashcard_collection_model.g.dart";

@HiveType(typeId: 6)
class FlashcardCollectionModel extends HiveObject {
  @HiveField(0)
  final String imgUrl;
  @HiveField(1)
  final String title;
  @HiveField(2)
  List<LocalVocabInfo> flashCards = [];

  FlashcardCollectionModel({
    required this.imgUrl,
    required this.title,
    required this.flashCards,
  });

  FlashcardCollectionModel copyWith(
      {String? imgUrl, String? title, List<LocalVocabInfo>? flashCards}) {
    return FlashcardCollectionModel(
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      flashCards: flashCards ?? this.flashCards,
    );
  }

  factory FlashcardCollectionModel.fromJson(Map<String, dynamic> json) {
    return FlashcardCollectionModel(
      imgUrl: json["imgUrl"],
      title: json["title"],
      flashCards: (json["flashCards"] as List<dynamic>)
          .map((e) => LocalVocabInfo.fromJson(e))
          .toList(),
    );
  }

  factory FlashcardCollectionModel.fromServer(Map<String, dynamic> json) {
    final localInstance = GetIt.I.get<VocabLocalSourceImpl>(); // VocabLocal
    final remoteInstance = GetIt.I.get<VocabSourceImpl>(); // VocabRemote
    List<LocalVocabInfo> flashCards = [];
    if (json["flashcards"] != null) {
      final List<int> list =
          (json['flashcards'] as List<dynamic>).map((e) => e as int).toList();
      final List<LocalVocabInfo?> localVocabList =
          localInstance.getVocabsByListId(list);
      if (localVocabList.isEmpty) {
        //Not found anything from local
        Stream.fromIterable([1]).asyncMap((event) async {
          final response = await remoteInstance.getVocabsByIdList(list);
          final List<VocabInfo>? data = response.data;
          return data;
        }).listen((event) {
          if (event != null) {
            final temp = event.map((e) {
              final vocab = LocalVocabInfo(
                  vocab: e.vocab,
                  vocabType: e.vocabType,
                  id: e.id,
                  pronounce: e.pronounce,
                  translate: e.translate);
              final box = Hive.box(HiveConfig.localVocabs);
              if (!box.containsKey(vocab.id)) {
                localInstance.addVocabToLocal(vocab);
              }
              return vocab;
            }).toList();
            flashCards.addAll(temp);
          }
        });
      } else if (localVocabList.length != list.length) {
        //Found some from local
        Stream.fromIterable(json["flashcards"]).asyncMap(
          (event) async {
            final LocalVocabInfo? vocab =
                localInstance.getVocabFromLocalbyId(event as int);
            if (vocab != null) {
              // search vocab local
              return vocab;
            } else {
              // Xu li goi api de tim vocab dua tren ID
              final response = await remoteInstance.getVocabById(event);
              final vocab = response.data!;
              final tempVocabInfo = LocalVocabInfo(
                vocab: vocab.vocab,
                vocabType: vocab.vocabType,
                id: vocab.id,
                pronounce: vocab.pronounce,
                translate: vocab.translate,
              );
              //store local vocab
              final box = Hive.box(HiveConfig.localVocabs);
              if (!box.containsKey(vocab.id)) {
                localInstance.addVocabToLocal(tempVocabInfo);
              }
              return tempVocabInfo;
            }
          },
        ).listen((event) {
          flashCards.add(event);
        });
      } else {
        //Found everythings from local
        for (final element in localVocabList) {
          if (element != null) {
            flashCards.add(element);
          }
        }
      }
    }

    return FlashcardCollectionModel(
      imgUrl: json["imgUrl"],
      title: json["title"],
      flashCards: flashCards,
    );
  }

  Map<String, dynamic> toJson() {
    final listId = flashCards.map((e) => e.id).toList();
    return {
      "imgUrl": imgUrl,
      "title": title,
      "flashcards": listId,
    };
  }
}

@HiveType(typeId: 0)
class FCCollectionByUser extends HiveObject {
  @HiveField(0)
  final List<FlashcardCollectionModel> flashcardCollectionList;

  FCCollectionByUser(this.flashcardCollectionList);
}

class FlashcardCollectionResponseModel {
  final String userId;
  final List<FlashcardCollectionModel> flashcardsData;

  FlashcardCollectionResponseModel(
      {required this.userId, required this.flashcardsData});

  factory FlashcardCollectionResponseModel.fromJson(Map<String, dynamic> json) {
    List<FlashcardCollectionModel> flashcardsData = [];
    if (json['listFlashCard'] != null) {
      for (var e in (json['listFlashCard'] as List)) {
        FlashcardCollectionModel tempFlashCard =
            FlashcardCollectionModel.fromServer(e);
        flashcardsData.add(tempFlashCard);
      }
    }

    return FlashcardCollectionResponseModel(
      userId: json['userId'],
      flashcardsData: flashcardsData,
    );
  }
}

class FlashcardCollectionFromServer {
  final List<FlashcardCollectionThumbnail> list;
  FlashcardCollectionFromServer(this.list);
  factory FlashcardCollectionFromServer.fromJson(Map<String, dynamic> json) {
    List<FlashcardCollectionThumbnail> flashcardsData = [];
    if (json['listCollection'] != null) {
      for (var e in (json['listCollection'] as List)) {
        FlashcardCollectionThumbnail tempFlashCard =
            FlashcardCollectionThumbnail.fromJson(e);
        flashcardsData.add(tempFlashCard);
      }
    }
    return FlashcardCollectionFromServer(flashcardsData);
  }
}

class FlashcardCollectionThumbnail {
  final String category;
  final String imgUrl;
  final int numberOfWord;

  FlashcardCollectionThumbnail({
    required this.category,
    required this.imgUrl,
    required this.numberOfWord,
  });

  factory FlashcardCollectionThumbnail.fromJson(Map<String, dynamic> json) {
    return FlashcardCollectionThumbnail(
      category: json["category"],
      imgUrl: json["imgUrl"],
      numberOfWord: json['numOfWords'] as int,
    );
  }
}

class FlashcardCollectionRandomModel {
  final String category;
  final String imgUrl;
  final List<LocalVocabInfo> flashcards;

  FlashcardCollectionRandomModel({
    required this.category,
    required this.imgUrl,
    required this.flashcards,
  });

  factory FlashcardCollectionRandomModel.fromJson(Map<String, dynamic> json) {
    final localInstance = GetIt.I.get<VocabLocalSourceImpl>(); // VocabLocal
    final remoteInstance = GetIt.I.get<VocabSourceImpl>(); // VocabRemote

    List<LocalVocabInfo> flashCards = [];
    if (json["flashCards"] != null) {
      final List<int> list =
          (json['flashCards'] as List<dynamic>).map((e) => e as int).toList();
      final List<LocalVocabInfo?> localVocabList =
          localInstance.getVocabsByListId(list);
      if (localVocabList.isEmpty) {
        print("goto case1");
        //Not found anything from local
        Stream.fromIterable([1]).asyncMap((event) async {
          final response = await remoteInstance.getVocabsByIdList(list);
          final List<VocabInfo>? data = response.data;
          return data;
        }).listen((event) {
          if (event != null) {
            final temp = event.map((e) {
              final vocab = LocalVocabInfo(
                  vocab: e.vocab,
                  vocabType: e.vocabType,
                  id: e.id,
                  pronounce: e.pronounce,
                  translate: e.translate);
              final box = Hive.box(HiveConfig.localVocabs);
              if (!box.containsKey(vocab.id)) {
                localInstance.addVocabToLocal(vocab);
              }
              return vocab;
            }).toList();
            flashCards.addAll(temp);
          }
        });
      } else if (localVocabList.length != list.length) {
        print("goto case2");
        //Found some from local
        Stream.fromIterable(json["flashCards"]).asyncMap(
          (event) async {
            final LocalVocabInfo? vocab =
                localInstance.getVocabFromLocalbyId(event as int);
            if (vocab != null) {
              // search vocab local
              return vocab;
            } else {
              // Xu li goi api de tim vocab dua tren ID
              final response = await remoteInstance.getVocabById(event);
              final vocab = response.data!;
              final tempVocabInfo = LocalVocabInfo(
                vocab: vocab.vocab,
                vocabType: vocab.vocabType,
                id: vocab.id,
                pronounce: vocab.pronounce,
                translate: vocab.translate,
              );
              //store local vocab
              final box = Hive.box(HiveConfig.localVocabs);
              if (!box.containsKey(vocab.id)) {
                localInstance.addVocabToLocal(tempVocabInfo);
              }
              return tempVocabInfo;
            }
          },
        ).listen((event) {
          flashCards.add(event);
        });
      } else {
        print("goto case3");
        //Found everythings from local
        for (final element in localVocabList) {
          if (element != null) {
            flashCards.add(element);
          }
        }
      }
    }
    print(flashCards);
    return FlashcardCollectionRandomModel(
      category: json["category"],
      imgUrl: json["imgUrl"] + ".png",
      flashcards: flashCards,
    );
  }
}
