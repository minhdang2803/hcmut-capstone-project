import 'package:bke/data/models/vocab/vocab.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
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
}

@HiveType(typeId: 0)
class FCCollectionByUser extends HiveObject {
  @HiveField(0)
  final List<FlashcardCollectionModel> flashcardCollectionList;

  FCCollectionByUser(this.flashcardCollectionList);
}
