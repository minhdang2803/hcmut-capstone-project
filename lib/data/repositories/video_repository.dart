import 'package:bke/data/data_source/local/video_local_source.dart';
import 'package:bke/utils/log_util.dart';
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

  ///
  void saveVideoInfoToLocal(VideoYoutubeInfo video) {
    _videoLocalSource.saveRecentlyWatchVideos(video);
  }

  Future<BaseResponse<VideoYoutubeInfos>> getRecentlyWatchList() {
    final response = _videoSource.getContinueWatching();
    return response;
  }

  Future<BaseResponse<void>> saveProcess(
    String mongoId,
    int second,
  ) async {
    _videoLocalSource.saveLastWatchVideoCheckpoint(mongoId, second);
    return await _videoSource.updateCkpt(mongoId, second);
  }

  Future<VideoYoutubeInfo> saveExternalVideo(
    String videoId
  ) async {
    final res = await _videoSource.saveExternalVideo(videoId);
    return res.data!;
  }

  int getProcess(String videoId) {
    final fromLocal = _videoLocalSource.getLastWatchAt(videoId);
    if (fromLocal == null) {
      return 0;
    }
    return fromLocal;
  }

  Future<BaseResponse<SubVideo>> getSubVideo(String videoId) async {
    return _videoSource.getSubVideo(videoId);
  }

  //

  Future<VideoYoutubeInfo?> getVideoById(String videoId) async {
    final response = await _videoSource.getVideo(videoId);
    final data = response.data;
    return data;
  }

  Future<VideoYoutubeInfo> getLatest() async {
    final response = await _videoSource.getLatest();
    final data = response.data!;
    return data;
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

  Future<BaseResponse<RecommendedVideos>> getRecommendedVideos() {
    return _videoSource.getRecommendedVideos();
  }
}
