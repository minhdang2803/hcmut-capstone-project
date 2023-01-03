import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/log_util.dart';
import '../../configs/hive_config.dart';
import '../../models/authentication/user.dart';
import '../../models/network/cvn_exception.dart';

abstract class AuthLocalSource {
  void saveCurrentUser(User user, String token);

  User? getCurrentUser();

  Box getUserBox();
}

class AuthLocalSourceImpl extends AuthLocalSource {
  @override
  void saveCurrentUser(User user, String token) async {
    try {
      final userBox = Hive.box(HiveConfig.userBox);
      const storage = FlutterSecureStorage();
      userBox.put(HiveConfig.currentUserKey, user);
      await storage.write(key: HiveConfig.currentUserTokenKey, value: token);
      LogUtil.debug('Saved user: ${user.id} - token: $token');
    } catch (e, s) {
      LogUtil.error('Save user error: $e', error: e, stackTrace: s);
      throw LocalException(
          LocalException.unableSaveUser, 'Unable Save User: $e');
    }
  }

  @override
  User? getCurrentUser() {
    final userBox = Hive.box(HiveConfig.userBox);
    return userBox.get(HiveConfig.currentUserKey);
  }

  @override
  Box getUserBox() => Hive.box(HiveConfig.userBox);
}
