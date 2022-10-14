// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/vocab/vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DictionaryAdapter extends TypeAdapter<Dictionary> {
  @override
  final int typeId = 3;

  @override
  Dictionary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dictionary()..dictionary = (fields[0] as List).cast<VocabInfos>();
  }

  @override
  void write(BinaryWriter writer, Dictionary obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dictionary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DictionaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
