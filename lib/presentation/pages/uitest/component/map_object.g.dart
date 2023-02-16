// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListMapObjectAdapter extends TypeAdapter<ListMapObject> {
  @override
  final int typeId = 17;

  @override
  ListMapObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListMapObject(
      (fields[0] as List).cast<MapObject>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListMapObject obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListMapObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MapObjectAdapter extends TypeAdapter<MapObject> {
  @override
  final int typeId = 16;

  @override
  MapObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapObject(
      id: fields[2] as String,
      offset: fields[0] as Offset,
      size: fields[1] as Size?,
      total: fields[3] as int?,
      type: fields[4] as GameType?,
    );
  }

  @override
  void write(BinaryWriter writer, MapObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.offset)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
