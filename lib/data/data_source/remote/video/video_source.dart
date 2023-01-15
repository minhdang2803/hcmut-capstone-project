import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/video/sub_video.dart';
import '../../../models/video/video_youtube_info.dart';
import '../../../services/api_service.dart';

abstract class VideoSource {
  Future<BaseResponse<SubVideo>> getSubVideo(String videoId);

  Future<BaseResponse<VideoYoutubeInfos>> getCategory1({
    required int pageKey,
    required int pageSize,
  });
}

class VideoSourceImpl extends VideoSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<SubVideo>> getSubVideo(String videoId) async {
    const path = EndPoint.getSubVideo;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final params = {'videoId': videoId};

    final getSubVideo = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<SubVideo>.fromJson(
          json: response, dataBuilder: SubVideo.fromJson),
    );
    LogUtil.debug('get sub video: $path');
    return _api.get(getSubVideo);
  }

  @override
  Future<BaseResponse<VideoYoutubeInfos>> getCategory1({
    required int pageKey,
    required int pageSize,
  }) async {
    const path = EndPoint.getYoutubeVideoInfos;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'limit': Constants.defaultPageSize,
      'page': pageKey,
    };

    final request = APIServiceRequest(
      path,
      queryParams: params,
      (response) => BaseResponse<VideoYoutubeInfos>.fromJson(
        json: response,
        dataBuilder: VideoYoutubeInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }
}
