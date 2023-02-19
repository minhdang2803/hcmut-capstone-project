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
      (fields[0] as List).cast<MapObjectLocal>(),
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

class MapObjectLocalAdapter extends TypeAdapter<MapObjectLocal> {
  @override
  final int typeId = 16;

  @override
  MapObjectLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapObjectLocal(
      id: fields[2] as String,
      dx: fields[0] as double?,
      dy: fields[6] as double?,
      sizeDx: fields[1] as double?,
      sizeDy: fields[7] as double?,
      isDone: fields[5] as bool,
      total: fields[3] as int?,
      type: fields[4] as GameType?,
    );
  }

  @override
  void write(BinaryWriter writer, MapObjectLocal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dx)
      ..writeByte(1)
      ..write(obj.sizeDx)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isDone)
      ..writeByte(6)
      ..write(obj.dy)
      ..writeByte(7)
      ..write(obj.sizeDy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapObjectLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
