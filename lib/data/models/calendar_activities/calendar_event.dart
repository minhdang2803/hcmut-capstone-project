import 'package:hive_flutter/hive_flutter.dart';
part "calendar_event.g.dart";

@HiveType(typeId: 23)
class CalendarEvent {
  @HiveField(0)
  String? title;

  @HiveField(1)
  late final String date;

  CalendarEvent({
    this.title,
    required this.date,
  });

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
  }
}

@HiveType(typeId: 22)
class DataCalendar {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<Event> listEvent;

  const DataCalendar(this.date, this.listEvent);
}

class Event {
  final String title;
  const Event(this.title);
}
