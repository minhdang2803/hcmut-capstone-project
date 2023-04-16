import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/video/video_models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/authentication/user.dart';

abstract class VideoLocalSource {
  Box getVideoLastWatchBox();
  int? getLastWatchAt(String videoId);
  void saveLastWatchVideoCheckpoint(String videoId, int second);
  Map<String, dynamic> getDictRecentlyWatchCheckpoint();
  void saveRecentlyWatchVideos(VideoYoutubeInfo video);
  VideoYoutubeInfo? getVideoYoutubeInfoLocalByVideoId(String videoId);
  List<VideoYoutubeInfo> getListRecentlyVideos();
}

class VideoLocalSourceImpl implements VideoLocalSource {
  @override
  Box getVideoLastWatchBox() {
    final box = Hive.box(HiveConfig.videoLastWatchByUser);
    return box;
  }

  String getUserId() {
    final userBox = Hive.box(HiveConfig.userBox);
    final AppUser user = userBox.get(HiveConfig.currentUserKey);
    return user.id!;
  }

  @override
  int? getLastWatchAt(String videoId) {
    final box = getVideoLastWatchBox();
    final userId = getUserId();
    final Map<dynamic, dynamic>? map = box.get(userId);
    if (map == null) return null;
    final result = map[videoId];
    if (result != null) return result;
    return -1;
  }

  @override
  void saveLastWatchVideoCheckpoint(String videoId, int second) {
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
  Map<String, dynamic> getDictRecentlyWatchCheckpoint() {
    Map<String, int> result = {};
    final box = getVideoLastWatchBox();
    final user = getUserId();
    final response = box.get(user, defaultValue: {});
    for (final element in response.entries.toList()) {
      result.addAll({element.key: element.value});
    }
    return result;
  }

  //videos
  @override
  void saveRecentlyWatchVideos(VideoYoutubeInfo video) {
    List<VideoYoutubeInfo> list = [];
    final box = Hive.box(HiveConfig.recentlyDictionary);
    final user = getUserId();
    final List<dynamic> response = box.get(user, defaultValue: []);
    list.addAll(response.cast<VideoYoutubeInfo>());
    list.add(video);
    box.put(user, list);
  }

  @override
  VideoYoutubeInfo? getVideoYoutubeInfoLocalByVideoId(String videoId) {
    List<VideoYoutubeInfo> list = [];
    final box = Hive.box(HiveConfig.recentlyDictionary);
    final user = getUserId();
    final List<dynamic> response = box.get(user, defaultValue: []);
    list.addAll(response.cast<VideoYoutubeInfo>());
    for (final element in list) {
      if (element.videoId == videoId) {
        return element;
      }
    }
    return null;
  }

  @override
  List<VideoYoutubeInfo> getListRecentlyVideos() {
    List<VideoYoutubeInfo> list = [];
    final box = Hive.box(HiveConfig.recentlyDictionary);
    final user = getUserId();
    final List<dynamic> response = box.get(user, defaultValue: []);
    list.addAll(response.cast<VideoYoutubeInfo>());
    return list;
  }
}
