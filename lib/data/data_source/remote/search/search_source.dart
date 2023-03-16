import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/book/book_info.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/search/search_model.dart';
import '../../../models/video/video_youtube_info_model.dart';
import '../../../services/api_service.dart';

abstract class SearchSource {
  Future<BaseResponse<SearchResponse>> searchAll(String query);
  Future<BaseResponse<BookInfos>> searchBooks(String query);
  Future<BaseResponse<VideoYoutubeInfos>> searchVideos(String query);
}

class SearchSourceImpl extends SearchSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<SearchResponse>> searchAll(String query) async {
    const path = EndPoint.searchAll;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'q': query};
  
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<SearchResponse>.fromJson(
          json: response, dataBuilder: SearchResponse.fromJson),
    );

    LogUtil.debug('Get search results');
    return _api.get(request);
  }

  @override
  Future<BaseResponse<BookInfos>> searchBooks(String query) async {
    const path = EndPoint.searchBooks;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'q': query};
  
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<BookInfos>.fromJson(
          json: response, dataBuilder: BookInfos.fromJson),
    );

    LogUtil.debug('Get search results');
    return _api.get(request);
  }
  
  @override
  Future<BaseResponse<VideoYoutubeInfos>> searchVideos(String query) async{
    const path = EndPoint.searchVideos;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'q': query};
  
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<VideoYoutubeInfos>.fromJson(
          json: response, dataBuilder: VideoYoutubeInfos.fromJson),
    );

    LogUtil.debug('Get search results');
    return _api.get(request);
  }


}
