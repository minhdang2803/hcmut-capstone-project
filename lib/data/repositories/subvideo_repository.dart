import '../data_source/remote/video/video_source.dart';
import '../models/network/base_response.dart';
import '../models/video/sub_video.dart';
import '../models/video/video_youtube_info.dart';

class VideoRepository {
  late final VideoSource _videoSource;
  VideoRepository._internal() {
    _videoSource = VideoSourceImpl();
  }
  static final _instance = VideoRepository._internal();

  factory VideoRepository.instance() => _instance;
  Future<BaseResponse<SubVideo>> getSubVideo(String videoId) async {
    return _videoSource.getSubVideo(videoId);
  }

  Future<BaseResponse<VideoYoutubeInfos>> getCategory1({
    required int pageKey,
    required int pageSize,
  }) {
    return _videoSource.getCategory1(
      pageKey: pageKey,
      pageSize: pageSize,
    );
  }
}
