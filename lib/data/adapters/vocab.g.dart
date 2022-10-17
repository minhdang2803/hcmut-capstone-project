// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/vocab/vocab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      id: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalVocabInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.vocab)
      ..writeByte(1)
      ..write(obj.id);
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
