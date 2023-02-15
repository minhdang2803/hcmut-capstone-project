// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_last_watch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoLastWatchListsAdapter extends TypeAdapter<VideoLastWatchLists> {
  @override
  final int typeId = 9;

  @override
  VideoLastWatchLists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoLastWatchLists(
      (fields[0] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoLastWatchLists obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.lastWatchList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoLastWatchListsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoLastWatchInfoListsAdapter
    extends TypeAdapter<VideoLastWatchInfoLists> {
  @override
  final int typeId = 10;

  @override
  VideoLastWatchInfoLists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoLastWatchInfoLists(
      (fields[0] as List).cast<VideoYoutubeInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoLastWatchInfoLists obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.videoList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoLastWatchInfoListsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
