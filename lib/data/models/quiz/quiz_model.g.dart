// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizModelAdapter extends TypeAdapter<QuizModel> {
  @override
  final int typeId = 11;

  @override
  QuizModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizModel(
      id: fields[0] as String?,
      topic: fields[1] as String?,
      level: fields[2] as String?,
      imgUrl: fields[3] as String?,
      sentence: fields[4] as String?,
      vocabAns: (fields[5] as List?)?.cast<String>(),
      answer: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.topic)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.imgUrl)
      ..writeByte(4)
      ..write(obj.sentence)
      ..writeByte(5)
      ..write(obj.vocabAns)
      ..writeByte(6)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
