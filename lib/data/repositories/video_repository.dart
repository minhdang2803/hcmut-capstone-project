import 'package:bke/data/data_source/local/video_local_source.dart';

import '../data_source/remote/video/video_source.dart';
import '../models/network/base_response.dart';
import '../models/video/sub_video_model.dart';
import '../models/video/video_youtube_info_model.dart';

class VideoRepository {
  late final VideoSource _videoSource;
  late final VideoLocalSource _videoLocalSource;
  VideoRepository._internal() {
    _videoSource = VideoSourceImpl();
    _videoLocalSource = VideoLocalSourceImpl();
  }
  static final _instance = VideoRepository._internal();

  factory VideoRepository.instance() => _instance;

  void saveProcess(String videoId, int second) {
    _videoLocalSource.saveLastWatchVideo(videoId, second);
  }

  int getProcess(String videoId) {
    return _videoLocalSource.getLastWatchAt(videoId);
  }

  Future<BaseResponse<SubVideo>> getSubVideo(String videoId) async {
    return _videoSource.getSubVideo(videoId);
  }

  Future<BaseResponse<VideoYoutubeInfos>> getAllVideos({
    required int pageKey,
    required int pageSize,
    required String category,
    int? level,
    String? title,
  }) {
    return _videoSource.getAllVideos(
      pageKey: pageKey,
      pageSize: pageSize,
      level: level,
      title: title,
      category: category,
    );
  }
}
