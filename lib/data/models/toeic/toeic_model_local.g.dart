// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toeic_model_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToeicQuestionLocalAdapter extends TypeAdapter<ToeicQuestionLocal> {
  @override
  final int typeId = 18;

  @override
  ToeicQuestionLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToeicQuestionLocal(
      qid: fields[0] as int?,
      imgUrl: fields[2] as Uint8List?,
      mp3UrlPro: fields[3] as String?,
      text: fields[1] as String?,
      answers: (fields[7] as List?)?.cast<String>(),
      mp3Url: fields[4] as String?,
      correctAnswer: fields[6] as String?,
      transcript: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ToeicQuestionLocal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.qid)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.imgUrl)
      ..writeByte(3)
      ..write(obj.mp3UrlPro)
      ..writeByte(4)
      ..write(obj.mp3Url)
      ..writeByte(5)
      ..write(obj.transcript)
      ..writeByte(6)
      ..write(obj.correctAnswer)
      ..writeByte(7)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToeicQuestionLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToeicGroupQuestionLocalAdapter
    extends TypeAdapter<ToeicGroupQuestionLocal> {
  @override
  final int typeId = 19;

  @override
  ToeicGroupQuestionLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToeicGroupQuestionLocal(
      gid: fields[0] as int?,
      text: fields[1] as String?,
      imgUrl: fields[2] as Uint8List?,
      mp3Url: fields[4] as String?,
      mp3UrlPro: fields[3] as String?,
      questions: (fields[6] as List?)?.cast<ToeicQuestionLocal>(),
      transcript: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ToeicGroupQuestionLocal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.gid)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.imgUrl)
      ..writeByte(3)
      ..write(obj.mp3UrlPro)
      ..writeByte(4)
      ..write(obj.mp3Url)
      ..writeByte(5)
      ..write(obj.transcript)
      ..writeByte(6)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToeicGroupQuestionLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalToeicPartAdapter extends TypeAdapter<LocalToeicPart> {
  @override
  final int typeId = 20;

  @override
  LocalToeicPart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalToeicPart(
      part: fields[0] as int,
      part125: (fields[1] as List?)?.cast<ToeicQuestionLocal>(),
      part3467: (fields[2] as List?)?.cast<ToeicGroupQuestionLocal>(),
    );
  }

  @override
  void write(BinaryWriter writer, LocalToeicPart obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.part)
      ..writeByte(1)
      ..write(obj.part125)
      ..writeByte(2)
      ..write(obj.part3467);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalToeicPartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
