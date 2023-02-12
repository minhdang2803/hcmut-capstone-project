import 'package:flutter/material.dart';

class MapObject {
  final Offset offset;
  final Size? size;
  final String id;

  bool isDone;

  MapObject({
    required this.id,
    required this.offset,
    required this.size,
    this.isDone = true,
  });
}
