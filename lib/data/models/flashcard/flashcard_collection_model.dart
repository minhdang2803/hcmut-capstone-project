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
  final List<LocalVocabInfo> flashcards;

  FlashcardCollectionModel({
    required this.imgUrl,
    required this.title,
    required this.flashcards,
  });

  FlashcardCollectionModel copyWith(
      {String? imgUrl, String? title, List<LocalVocabInfo>? flashcards}) {
    return FlashcardCollectionModel(
      imgUrl: imgUrl ?? this.imgUrl,
      title: title ?? this.title,
      flashcards: flashcards ?? this.flashcards,
    );
  }

  factory FlashcardCollectionModel.fromJson(Map<String, dynamic> json) {
    return FlashcardCollectionModel(
      imgUrl: json["imgUrl"],
      title: json["title"],
      flashcards: (json["flashcards"] as List<dynamic>)
          .map((e) => LocalVocabInfo.fromJson(e))
          .toList(),
    );
  }

  static FlashcardCollectionModel fromServer(Map<String, dynamic> json) {
    final localInstance =
        GetIt.I.get<VocabLocalSourceImpl>(); //instance VocabLocal
    final remoteInstance =
        GetIt.I.get<VocabSourceImpl>(); //instance VocabRemote
    late List<LocalVocabInfo> flashcards;
    if (json["flashcards"] != null) {
      flashcards = (json["flashcards"] as List<dynamic>).map((e) async {
        final LocalVocabInfo? vocab =
            localInstance.getVocabFromLocalbyId(e as int);
        if (vocab != null) {
          // search vocab local
          return vocab;
        } else {
          // Xu li goi api de tim vocab dua tren ID
          final response = await remoteInstance.getVocabById(e);
          final vocab = response.data!;
          return LocalVocabInfo(
              vocab: vocab.vocab,
              vocabType: vocab.vocabType,
              id: vocab.id,
              pronounce: vocab.pronounce,
              translate: vocab.translate);
        }
      }).toList();
    } //fnd by ID
    else {
      flashcards = [];
    }

    return FlashcardCollectionModel(
      imgUrl: json["imgUrl"],
      title: json["title"],
      flashcards: flashcards,
    );
  }

  Map<String, dynamic> toJson() {
    final listId = flashcards.map((e) => e.id).toList();
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

  static FlashcardCollectionResponseModel fromJson(Map<String, dynamic> json) {
    return FlashcardCollectionResponseModel(
      userId: json['userId'],
      flashcardsData: (json["listFlashCard"] as List<dynamic>)
          .map((e) => FlashcardCollectionModel.fromServer(e))
          .toList(),
    );
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
