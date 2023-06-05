import 'package:bke/data/notification_manager/noti_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final instance = GetIt.I.get<NotificationManager>();
  Future<void> pushNoti({String? title, String? message}) {
    return instance.showNotification(title: title, body: message);
  }
}
