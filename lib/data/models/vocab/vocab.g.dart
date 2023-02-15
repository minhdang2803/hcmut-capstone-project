// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalVocabInfoListAdapter extends TypeAdapter<LocalVocabInfoList> {
  @override
  final int typeId = 7;

  @override
  LocalVocabInfoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalVocabInfoList(
      (fields[0] as List).cast<LocalVocabInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalVocabInfoList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.vocabList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalVocabInfoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalVocabInfoAdapter extends TypeAdapter<LocalVocabInfo> {
  @override
  final int typeId = 3;

  @override
  LocalVocabInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalVocabInfo(
      vocab: fields[0] as String,
      vocabType: fields[2] as String,
      id: fields[1] as int,
      pronounce: fields[3] as Pronounce,
      translate: (fields[4] as List).cast<TranslateInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalVocabInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.vocab)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.vocabType)
      ..writeByte(3)
      ..write(obj.pronounce)
      ..writeByte(4)
      ..write(obj.translate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalVocabInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PronounceAdapter extends TypeAdapter<Pronounce> {
  @override
  final int typeId = 4;

  @override
  Pronounce read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pronounce(
      uk: fields[0] as String,
      ukmp3: fields[1] as String,
      us: fields[2] as String,
      usmp3: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Pronounce obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uk)
      ..writeByte(1)
      ..write(obj.ukmp3)
      ..writeByte(2)
      ..write(obj.us)
      ..writeByte(3)
      ..write(obj.usmp3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PronounceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslateInfoAdapter extends TypeAdapter<TranslateInfo> {
  @override
  final int typeId = 5;

  @override
  TranslateInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateInfo(
      en: fields[0] as String,
      vi: fields[1] as String,
      example: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TranslateInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.en)
      ..writeByte(1)
      ..write(obj.vi)
      ..writeByte(2)
      ..write(obj.example);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
