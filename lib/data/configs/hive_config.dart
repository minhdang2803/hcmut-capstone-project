import 'package:hive_flutter/hive_flutter.dart';

import '../models/authentication/user.dart';

class HiveConfig {
  static const userBox = 'USER';
  static const currentUserKey = 'CURRENT_USER';
  static const currentUserTokenKey = 'CURRENT_USER_TOKEN';

  static const dictionary = 'DICTIONARY';
  static const myDictionary = 'MY_DICTIONARY';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());

    await Hive.openBox(userBox);
  }
}
