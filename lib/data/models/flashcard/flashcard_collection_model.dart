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

  static Future<FlashcardCollectionModel> fromServer(
      Map<String, dynamic> json) async {
    final localInstance = GetIt.I.get<VocabLocalSourceImpl>(); // VocabLocal
    final remoteInstance = GetIt.I.get<VocabSourceImpl>(); // VocabRemote
    List<LocalVocabInfo> flashCards = [];
    if (json["flashCards"] != null) {
      for (var e in (json["flashCards"] as List)) {
        final LocalVocabInfo? vocab =
            localInstance.getVocabFromLocalbyId(e as int);
        if (vocab != null) {
          // search vocab local
          continue;
        } else {
          // Xu li goi api de tim vocab dua tren ID
          final response = await remoteInstance.getVocabById(e);
          final vocab = response.data!;
          final tempVocabInfo = LocalVocabInfo(
            vocab: vocab.vocab,
            vocabType: vocab.vocabType,
            id: vocab.id,
            pronounce: vocab.pronounce,
            translate: vocab.translate,
          );

          flashCards.add(tempVocabInfo);
        }
      }
    } //fnd by ID

    return FlashcardCollectionModel(
      imgUrl: json["imgUrl"],
      title: json["title"],
      flashCards: flashCards,
    );
  }

  Map<String, dynamic> toJson() {
    final listId = flashCards.map((e) => e.id).toList();
    return {"imgUrl": imgUrl, "title": title, "flashcards": listId};
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

  static Future<FlashcardCollectionResponseModel> fromJson(
      Map<String, dynamic> json) async {
    List<FlashcardCollectionModel> flashcardsData = [];
    if (json['listFlashCard'] != null) {
      for (var e in (json['listFlashCard'] as List)) {
        FlashcardCollectionModel tempFlashCard =
            await FlashcardCollectionModel.fromServer(e);
        flashcardsData.add(tempFlashCard);
      }
    }

    return FlashcardCollectionResponseModel(
        userId: json['userId'], flashcardsData: flashcardsData);
  }
}

// class FlashcardDataResponseModel {
//   final String title;
//   final String imgUrl;
//   final List<int> flashCardId;
//   FlashcardDataResponseModel(this.title, this.imgUrl, this.flashCardId);
//   factory FlashcardDataResponseModel.fromJson(Map<String, dynamic> json) {
//     return FlashcardDataResponseModel(
//       json['title'],
//       json['imgUrl'],
//       (json['flashcards'] as List<dynamic>).map((e) => (e as int)).toList(),
//     );
//   }
// }
