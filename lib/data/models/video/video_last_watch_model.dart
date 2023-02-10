import 'package:bke/data/models/video/video_models.dart';
import 'package:hive/hive.dart';
part 'video_last_watch_model.g.dart';

@HiveType(typeId: 9)
class VideoLastWatchLists extends HiveObject {
  @HiveField(0)
  final Map<String, int> lastWatchList;
  VideoLastWatchLists(this.lastWatchList);
}

@HiveType(typeId: 10)
class VideoLastWatchInfoLists extends HiveObject {
  @HiveField(0)
  final List<VideoYoutubeInfo> videoList;
  VideoLastWatchInfoLists(this.videoList);
}
