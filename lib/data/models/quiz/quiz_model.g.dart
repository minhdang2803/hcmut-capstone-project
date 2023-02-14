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
      id: fields[3] as int,
      typeOfQuestion: fields[1] as GameType,
      numOfQuestions: fields[2] as int,
      tests: (fields[0] as List).cast<QuizMultipleChoiceLocalModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizMCTests obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tests)
      ..writeByte(1)
      ..write(obj.typeOfQuestion)
      ..writeByte(2)
      ..write(obj.numOfQuestions)
      ..writeByte(3)
      ..write(obj.id);
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

class QuizMultipleChoiceLocalModelAdapter
    extends TypeAdapter<QuizMultipleChoiceLocalModel> {
  @override
  final int typeId = 15;

  @override
  QuizMultipleChoiceLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizMultipleChoiceLocalModel(
      id: fields[0] as String?,
      topic: fields[1] as String?,
      level: fields[2] as String?,
      imgUrl: fields[3] as Uint8List?,
      sentence: fields[4] as String?,
      vocabAns: (fields[5] as List?)?.cast<String>(),
      answer: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizMultipleChoiceLocalModel obj) {
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
      other is QuizMultipleChoiceLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameTypeAdapter extends TypeAdapter<GameType> {
  @override
  final int typeId = 14;

  @override
  GameType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameType.type1;
      case 1:
        return GameType.type2;
      default:
        return GameType.type1;
    }
  }

  @override
  void write(BinaryWriter writer, GameType obj) {
    switch (obj) {
      case GameType.type1:
        writer.writeByte(0);
        break;
      case GameType.type2:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
