part of 'calendar_activities_cubit.dart';

abstract class CalendarActivitiesState extends Equatable {
  const CalendarActivitiesState();
}

class CalendarActivitiesInitial extends CalendarActivitiesState {
  @override
  List<Object> get props => [];
}

class CalendarActivitiesLoading extends CalendarActivitiesState {
  @override
  List<Object> get props => [];
}

class CalendarActivitiesSuccess extends CalendarActivitiesState {
  const CalendarActivitiesSuccess(this.data);

  final List<CalendarEvent> data;

  @override
  List<Object> get props => [data];
}

class CalendarActivitiesError extends CalendarActivitiesState {
  const CalendarActivitiesError(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class MyHistoricalActivitiesLoading extends CalendarActivitiesState {
  @override
  List<Object> get props => [];
}

class MyHistoricalActivitiesSuccess extends CalendarActivitiesState {
  const MyHistoricalActivitiesSuccess(this.data);

  final List<CalendarEvent> data;
  @override
  List<Object> get props => [data];
}

class MyHistoricalActivitiesError extends CalendarActivitiesState {
  const MyHistoricalActivitiesError(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;

  @override
  List<Object?> get props => [errorCode, errorMessage];
}
