import 'package:bke/data/models/vocab/vocab.dart';

class FlashcardCollectionModel {
  final String imgUrl;
  final String title;
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
}
