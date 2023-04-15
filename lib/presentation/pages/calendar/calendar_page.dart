import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../bloc/calendar_activities/calendar_activities_cubit.dart';
import '../../../../data/models/calendar_activities/calendar_event.dart';
import '../../../../utils/widget_util.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/custom_app_bar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  LinkedHashMap<DateTime, List<Event>>? _events;

  @override
  bool get wantKeepAlive => true;

  void _onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    if (isSameDay(_selectedDay, selectedDay)) return;
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    if (isSameDay(_focusedDay, focusedDay)) return;
    _focusedDay = focusedDay;
    context.read<CalendarActivitiesCubit>().getCalendarActivitiesList(
        yearMonth: DateFormat('yyyy-MM').format(_focusedDay));
  }

  void _parseEventData(List<CalendarEvent> events) {
    List<DataCalendar> listDataCalendar = [];
    List<String> listDate = [];
    for (var event in events) {
      listDate = listDataCalendar.map((e) => e.date).toList();
      if (listDate.contains(event.date)) {
        int getIndex = listDate.indexOf(event.date);
        listDataCalendar[getIndex].listEvent.add(Event(event.title ?? ''));
      } else {
        listDataCalendar
            .add(DataCalendar(event.date, [Event(event.title ?? '')]));
      }
    }
    final eventSource = {
      for (var i in listDataCalendar) DateTime.parse(i.date): i.listEvent
    };
    setState(() {
      _events = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: _getHashCode,
      )..addAll(eventSource);
    });
  }

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColor.lightGray,
      body: Container(
        // padding: EdgeInsets.only(top: topPadding),
        decoration: const BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            // topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            const BkEAppBar(label: 'Lịch sử'
                // onBackButtonPress: () => Navigator.pop(context),
                ),
            Expanded(
              child: _buildBody(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocListener<CalendarActivitiesCubit, CalendarActivitiesState>(
      listener: (context, state) {
        if (state is CalendarActivitiesLoading) {
          showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              // return const Center(
              //   child: CircularProgressIndicator(color: AppColor.secondary),
              // );
              return const SizedBox.shrink();
            },
          );
        }
        if (state is CalendarActivitiesSuccess) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          _parseEventData(state.data);
        }
        if (state is CalendarActivitiesError) {
          if (ModalRoute.of(context)?.isCurrent != true) {
            Navigator.of(context).pop();
          }
          WidgetUtil.showSnackBar(context, state.errorMessage);
        }
      },
      child: RefreshIndicator(
        color: AppColor.secondary,
        onRefresh: () async => await context
            .read<CalendarActivitiesCubit>()
            .getCalendarActivitiesList(
                yearMonth: DateFormat('yyyy-MM').format(_focusedDay)),
        child: ListView(
          padding: EdgeInsets.only(bottom: 30.r),
          children: [
            _buildCalendar(),
            10.verticalSpace,
            _buildEvents(),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: AppColor.primary,
      child: TableCalendar(
        //calendar's configurations
        locale: 'vi_VI',
        focusedDay: _focusedDay,
        firstDay: DateTime(2022),
        lastDay: DateTime(2050),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekVisible: true,

        //calendar callbacks
        onDaySelected: _onDateSelected,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onPageChanged: _onPageChanged,
        eventLoader: (day) => _events?[day] ?? [],
        onCalendarCreated: (pageController) {
          context.read<CalendarActivitiesCubit>().getCalendarActivitiesList(
              yearMonth: DateFormat('yyyy-MM').format(_focusedDay));
        },

        //styling calendar
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, events) => Container(
            //  margin: EdgeInsets.all(2.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.secondary,
              border: Border.all(color: AppColor.primary),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              day.day.toString(),
              style: const TextStyle(color: AppColor.textPrimary),
            ),
          ),
          selectedBuilder: (context, day, events) => Container(
            margin: EdgeInsets.all(2.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: AppColor.defaultBorder),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              day.day.toString(),
              style: const TextStyle(color: AppColor.textPrimary),
            ),
          ),
          singleMarkerBuilder: (context, day, event) => Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: day == _selectedDay
                    ? AppColor.primary
                    : AppColor.secondary), //Change color
            width: 5.r,
            height: 5.r,
            margin: EdgeInsets.symmetric(horizontal: 1.5.r),
          ),
        ),
        rowHeight: 52.r,
        daysOfWeekHeight: 16.r,
        headerStyle: HeaderStyle(
          titleCentered: true,
          headerPadding: EdgeInsets.symmetric(vertical: 16.r),
          formatButtonVisible: false,
          titleTextFormatter: (date, locale) {
            return 'Tháng ${date.month}, ${date.year}';
          },
          titleTextStyle: AppTypography.title.copyWith(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEvents() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 8.r),
      padding: EdgeInsets.symmetric(
        horizontal: 16.r,
        vertical: 16.r,
      ),
      shrinkWrap: true,
      itemCount: _events?[_selectedDay]?.length ?? 0,
      itemBuilder: (context, index) => Card(
        elevation: 2,
        color: AppColor.appBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListTile(
          title: Text(
            _events?[_selectedDay]?[index].title ?? '',
            style: AppTypography.body,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 4.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
