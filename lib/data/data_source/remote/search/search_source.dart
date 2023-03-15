import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/search/search_model.dart';
import '../../../services/api_service.dart';

abstract class SearchSource {
  Future<BaseResponse<SearchResponse>> searchAll(String query);
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

}
