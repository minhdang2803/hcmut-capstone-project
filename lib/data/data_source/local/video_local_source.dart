import 'package:bke/data/configs/hive_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/authentication/user.dart';

abstract class VideoLocalSource {
  Box getVideoLastWatchBox();
  int getLastWatchAt(String videoId);
  void saveLastWatchVideo(String videoId, int second);
}

class VideoLocalSourceImpl implements VideoLocalSource {
  @override
  int getLastWatchAt(String videoId) {
    final box = getVideoLastWatchBox();
    final userId = getUserId();
    final list = box.get(userId, defaultValue: []);
    for (final element in list) {
      final value = element as Map<String, int>;
      if (value.containsKey(videoId)) {
        return value[videoId]!;
      }
    }
    return -1;
  }

  @override
  void saveLastWatchVideo(String videoId, int second) {
    final box = getVideoLastWatchBox();
    final user = getUserId();
    final result = box.get(user, defaultValue: []) as List<dynamic>;
    result.add({videoId, second});
    box.put(user, result);
  }

  @override
  Box getVideoLastWatchBox() {
    final box = Hive.box(HiveConfig.videoLastWatchByUser);
    return box;
  }

  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final User user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }
}
