import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/calendar_activities/calendar_event.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/repositories/calendar_activities_repository.dart';
import '../../utils/log_util.dart';

part 'calendar_activities_state.dart';

class CalendarActivitiesCubit extends Cubit<CalendarActivitiesState> {
  CalendarActivitiesCubit() : super(CalendarActivitiesInitial());

  final _calendarActiviesRepository = CalendarActivitiesRepository.instance();

  Future<void> getCalendarActivitiesList({required String yearMonth}) async {
    try {
      emit(CalendarActivitiesLoading());
      final response = await _calendarActiviesRepository.getHistoryActivities(
          yearMonth: yearMonth);

      final dataList = response.data?.list ?? [];
      LogUtil.debug('Get successs: ${dataList.length}');
      emit(CalendarActivitiesSuccess(dataList));
    } on RemoteException catch (e, s) {
      if (e.code == RemoteException.noInternet) {
        emit(const CalendarActivitiesError('Không có kết nối internet!'));
      } else if (e.httpStatusCode == 404) {
        emit(const CalendarActivitiesSuccess([]));
      } else {
        emit(const CalendarActivitiesError(
            'Đã xảy ra lỗi, vui lòng thử lại sau!'));
        LogUtil.error(
          'Get calendar activities error: ${e.message}',
          error: e,
          stackTrace: s,
        );
      }
    } catch (e, s) {
      emit(CalendarActivitiesError(e.toString()));
      LogUtil.error('Get calendar activities error', error: e, stackTrace: s);
    }
  }
}
