import 'package:bke/data/data_source/local/auth_local_source.dart';
import 'package:bke/data/data_source/remote/chat/chat_local_source.dart';
import 'package:bke/data/data_source/local/flashcard_local_source.dart';
import 'package:bke/data/data_source/local/vocab_local_source.dart';
import 'package:bke/data/data_source/remote/vocab/vocab_source.dart';
import 'package:bke/data/notification_manager/noti_manager.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.instance;

Future<void> initServices() async {
  getItInstance.registerSingleton<AuthLocalSourceImpl>(AuthLocalSourceImpl());
  getItInstance.registerSingleton<ChatSourceImpl>(ChatSourceImpl());

  getItInstance.registerLazySingleton<VocabLocalSourceImpl>(
      () => VocabLocalSourceImpl());
  getItInstance.registerLazySingleton<VocabSourceImpl>(() => VocabSourceImpl());
  getItInstance.registerLazySingleton(() => FCLocalSourceImpl());
  getItInstance.registerLazySingleton(() => NotificationManager());
}
