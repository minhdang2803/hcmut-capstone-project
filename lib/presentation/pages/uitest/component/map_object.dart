import 'package:flutter/material.dart';

enum GameType { type1, type2 }

class MapObject {
  final Offset offset;
  final Size? size;
  final String id;
  final int? total;
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
