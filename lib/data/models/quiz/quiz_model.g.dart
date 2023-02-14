// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizMCAnswerModelAdapter extends TypeAdapter<QuizMCAnswerModel> {
  @override
  final int typeId = 12;

  @override
  QuizMCAnswerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizMCAnswerModel(
      answers: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toSet(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizMCAnswerModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.answers.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizMCAnswerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizMCTestsAdapter extends TypeAdapter<QuizMCTests> {
  @override
  final int typeId = 13;

  @override
  QuizMCTests read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizMCTests(
      tests: (fields[0] as List).cast<QuizMultipleChoiceModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizMCTests obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizMCTestsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizMultipleChoiceModelAdapter
    extends TypeAdapter<QuizMultipleChoiceModel> {
  @override
  final int typeId = 11;

  @override
  QuizMultipleChoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizMultipleChoiceModel(
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
  void write(BinaryWriter writer, QuizMultipleChoiceModel obj) {
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
      other is QuizMultipleChoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizChoseWordModelAdapter extends TypeAdapter<QuizChoseWordModel> {
  @override
  final int typeId = 14;

  @override
  QuizChoseWordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizChoseWordModel(
      id: fields[0] as String?,
      topic: fields[1] as String?,
      level: fields[2] as String?,
      imgUrl: fields[3] as String?,
      sentence: fields[4] as String?,
      vocabAns: (fields[5] as List?)?.cast<String>(),
      answer: (fields[6] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizChoseWordModel obj) {
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
      other is QuizChoseWordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
