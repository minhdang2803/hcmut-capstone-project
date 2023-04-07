import 'package:bke/utils/log_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../utils/constants.dart';

import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/news/news_model.dart';
import '../../../services/api_service.dart';

abstract class NewsSource {
   Future<BaseResponse<NewsInfos>> getTopHeadlines();
   Future<BaseResponse<NewsInfos>> getByCategory(String category);

}

class NewsSourceImpl extends NewsSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<NewsInfos>> getByCategory(String category) async{
   
    const path = EndPoint.getAllNews;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'category': category,
      'page': 1,
      'limit': Constants.defaultPageSize
    };

    final request = APIServiceRequest(
      path,
      queryParams: params,
      (response) => BaseResponse<NewsInfos>.fromJson(
        json: response,
        dataBuilder: NewsInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }

  @override
  Future<BaseResponse<NewsInfos>> getTopHeadlines() async{
    const path = EndPoint.getAllNews;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'page': 1,
      'limit': 5,
      'isTopHeadline': true,
    };

    final request = APIServiceRequest(
      path,
      queryParams: params,
      (response) => BaseResponse<NewsInfos>.fromJson(
        json: response,
        dataBuilder: NewsInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }

}