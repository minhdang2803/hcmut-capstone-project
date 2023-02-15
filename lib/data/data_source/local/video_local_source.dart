import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/video/video_models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/authentication/user.dart';

abstract class VideoLocalSource {
  Box getVideoLastWatchBox();
  int getLastWatchAt(String videoId);
  void saveLastWatchVideo(String videoId, int second);
  Map<String, int> getListRecentlyWatchInfo();
  void saveRecentlyWatchVideos(VideoYoutubeInfo video);
  // List<VideoYoutubeInfo> getListRecentlyWatchVideo();
}

class VideoLocalSourceImpl implements VideoLocalSource {
  @override
  int getLastWatchAt(String videoId) {
    final box = getVideoLastWatchBox();
    final userId = getUserId();
    final map = box.get(userId, defaultValue: {});

    final result = map[videoId];
    if (result != null) return result;
    return -1;
  }

  @override
  void saveLastWatchVideo(String videoId, int second) {
    Map<String, int> result = {};
    final box = getVideoLastWatchBox();
    final user = getUserId();
    final response = box.get(user, defaultValue: {});
    for (final element in response.entries.toList()) {
      result.addAll({element.key: element.value});
    }
    result.addAll({videoId: second});
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

  @override
  Map<String, int> getListRecentlyWatchInfo() {
    Map<String, int> result = {};
    final box = getVideoLastWatchBox();
    final user = getUserId();
    final response = box.get(user, defaultValue: {});
    for (final element in response.entries.toList()) {
      result.addAll({element.key: element.value});
    }
    return result;
  }

  @override
  void saveRecentlyWatchVideos(VideoYoutubeInfo video) {
    List<VideoYoutubeInfo> list = [];
    final box = Hive.box(HiveConfig.recentlyList);
    final user = getUserId();
    final response = box.get(user, defaultValue: []);
    for (final element in response) {
      list.add(element);
    }
    list.add(video);
    box.put(user, list);
  }

  // @override
  // List<VideoYoutubeInfo> getListRecentlyWatchVideo() {
  //   List<VideoYoutubeInfo> list = [];
  //   final box = Hive.box(HiveConfig.recentlyList);
  //   final user = getUserId();
  //   final response = box.get(user, defaultValue: []);
  //   for (final element in response) {
  //     list.add(element);
  //   }
  //   return list;
  // }
}
