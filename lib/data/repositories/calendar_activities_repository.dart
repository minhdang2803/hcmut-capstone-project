import '../data_source/remote/calendar_activities/calendar_activities_remote_source.dart';
import '../models/calendar_activities/calendar_response.dart';
import '../models/network/base_response.dart';

class CalendarActivitiesRepository {
  late final CalendarActivitiesRemoteSource _calendarAcvitiviesDataSource;

  CalendarActivitiesRepository._internal() {
    _calendarAcvitiviesDataSource = CalendarActivitiesRemoteSourceImpl();
  }

  static final _instance = CalendarActivitiesRepository._internal();

  factory CalendarActivitiesRepository.instance() => _instance;

  Future<BaseResponse<CalendarResponse>> getHistoryActivities({
    required String yearMonth,
  }) {
    return _calendarAcvitiviesDataSource.getHistoryActivities(
        yearMonth: yearMonth);
  }
}
