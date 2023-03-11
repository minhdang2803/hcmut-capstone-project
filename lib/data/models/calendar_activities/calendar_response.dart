import 'calendar_event.dart';

class CalendarResponse {
  List<CalendarEvent> list = [];

  CalendarResponse({
    required this.list,
  });

  CalendarResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      for (var e in (json['data'] as List)) {
        list.add(CalendarEvent.fromJson(e));
      }
    }
  }
}
