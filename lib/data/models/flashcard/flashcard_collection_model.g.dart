// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_collection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardCollectionModelAdapter
    extends TypeAdapter<FlashcardCollectionModel> {
  @override
  final int typeId = 6;

  @override
  FlashcardCollectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardCollectionModel(
      imgUrl: fields[0] as String,
      title: fields[1] as String,
      flashCards: (fields[2] as List).cast<LocalVocabInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardCollectionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imgUrl)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.flashCards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardCollectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FCCollectionByUserAdapter extends TypeAdapter<FCCollectionByUser> {
  @override
  final int typeId = 0;

  @override
  FCCollectionByUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FCCollectionByUser(
      (fields[0] as List).cast<FlashcardCollectionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FCCollectionByUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.flashcardCollectionList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FCCollectionByUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
