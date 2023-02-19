import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'map_object.g.dart';

@HiveType(typeId: 17)
class ListMapObject extends HiveObject {
  @HiveField(0)
  List<MapObjectLocal> list;
  ListMapObject(this.list);
}

// @HiveType(typeId: 16)
class MapObject extends HiveObject {
  // @HiveField(0)
  final Offset? offset;
  // @HiveField(1)
  final Size? size;
  // @HiveField(2)
  final String id;
  // @HiveField(3)
  final int? total;
  // @HiveField(4)
  final GameType? type;
  // @HiveField(5)
  bool isDone;

  MapObject copyWith({
    Offset? offset,
    Size? size,
    String? id,
    int? total,
    GameType? type,
    bool? isDone,
  }) {
    return MapObject(
      id: id ?? this.id,
      isDone: isDone ?? this.isDone,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      type: type ?? this.type,
      size: size ?? this.size,
    );
  }

  MapObject({
    required this.id,
    this.offset,
    this.size,
    this.isDone = true,
    this.total,
    this.type,
  });
}

@HiveType(typeId: 16)
class MapObjectLocal extends HiveObject {
  @HiveField(0)
  final double? dx;
  @HiveField(1)
  final double? sizeDx;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final int? total;
  @HiveField(4)
  final GameType? type;
  @HiveField(5)
  bool isDone;
  @HiveField(6)
  final double? dy;
  @HiveField(7)
  final double? sizeDy;

  MapObjectLocal copyWith({
    double? dx,
    double? dy,
    Size? size,
    String? id,
    int? total,
    GameType? type,
    bool? isDone,
    final double? sizeDy,
    final double? sizeDx,
  }) {
    return MapObjectLocal(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      id: id ?? this.id,
      isDone: isDone ?? this.isDone,
      total: total ?? this.total,
      type: type ?? this.type,
      sizeDx: dx ?? this.sizeDx,
      sizeDy: dy ?? this.sizeDy,
    );
  }

  MapObjectLocal({
    required this.id,
    this.dx,
    this.dy,
    this.sizeDx,
    this.sizeDy,
    this.isDone = true,
    this.total,
    this.type,
  });
}
