import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/video/sub_video_model.dart';
import '../../../models/video/video_youtube_info_model.dart';
import '../../../services/api_service.dart';

abstract class VideoSource {
  Future<BaseResponse<SubVideo>> getSubVideo(String videoId);
  Future<BaseResponse<VideoYoutubeInfos>> getAllVideos({
    required int pageKey,
    required int pageSize,
    required String category,
    int? level,
    String? title,
  });
  Future<BaseResponse<VideoYoutubeInfo>> getVideo(String videoId);
  Future<BaseResponse<VideoYoutubeInfos>> getContinueWatching();
  Future<BaseResponse> updateCkpt(String videoId, int ckpt);
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
  Future<BaseResponse<VideoYoutubeInfos>> getAllVideos({
    required int pageKey,
    required int pageSize,
    required String category,
    int? level,
    String? title,
  }) async {
    const path = EndPoint.getYoutubeVideoInfos;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'limit': Constants.defaultPageSize,
      'page': pageKey,
      'category': category,
      'level': level,
      'title': title
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

  @override
  Future<BaseResponse<VideoYoutubeInfo>> getVideo(String videoId) async {
    const path = EndPoint.getYoutubeVideoInfo;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {'videoId': videoId};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<VideoYoutubeInfo>.fromJson(
        json: response,
        dataBuilder: VideoYoutubeInfo.fromJson,
      ),
    );
    return _api.get(request);
  }

  @override
  Future<BaseResponse<VideoYoutubeInfos>> getContinueWatching() async {
    const path = EndPoint.getContinueWatching;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};

    final request = APIServiceRequest(
      path,
      (response) => BaseResponse<VideoYoutubeInfos>.fromJson(
        json: response,
        dataBuilder: VideoYoutubeInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }

  @override
  Future<BaseResponse<void>> updateCkpt(String videoId, int ckpt) async {
    const path = EndPoint.updateVideoCkpt;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final bodyRequest = {'videoId': videoId, 'checkpoint': ckpt};
    final request = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );
    LogUtil.debug('$bodyRequest');
    return _api.post(request);
  }
}
