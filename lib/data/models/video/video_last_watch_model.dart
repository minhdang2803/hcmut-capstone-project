import 'package:hive/hive.dart';
part 'video_last_watch_model.g.dart';

@HiveType(typeId: 9)
class VideoLastWatchLists extends HiveObject {
  @HiveField(0)
  final List<Map<String,int>> lastWatchList;
  VideoLastWatchLists(this.lastWatchList);
}

class VideoLastWatchModel {
  final int second;
  final String videoId;
  VideoLastWatchModel({required this.second, required this.videoId});
  factory VideoLastWatchModel.fromJson(Map<String, dynamic> json) {
    return VideoLastWatchModel(
      second: json['second'],
      videoId: json['videoId'],
    );
  }
}
