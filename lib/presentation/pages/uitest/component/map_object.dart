import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'map_object.g.dart';

@HiveType(typeId: 17)
class ListMapObject extends HiveObject {
  @HiveField(0)
  List<MapObject> list;
  ListMapObject(this.list);
}

@HiveType(typeId: 16)
class MapObject extends HiveObject {
  @HiveField(0)
  final Offset offset;
  @HiveField(1)
  final Size? size;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final int? total;
  @HiveField(4)
  final GameType? type;

  bool isDone;

  MapObject({
    required this.id,
    required this.offset,
    required this.size,
    this.isDone = true,
    this.total,
    this.type,
  });
}
