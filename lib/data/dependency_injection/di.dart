import 'package:bke/data/data_source/local/auth_local_source.dart';
import 'package:bke/data/data_source/local/flashcard_local_soucre.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.instance;

Future<void> initServices() async {
  getItInstance.registerSingleton<AuthLocalSourceImpl>(
    AuthLocalSourceImpl(),
  );

  getItInstance.registerLazySingleton(() => FCLocalSourceImpl());
}
