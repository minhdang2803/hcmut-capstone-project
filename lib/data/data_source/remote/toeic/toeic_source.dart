import 'package:bke/data/models/toeic/toeic_model_server.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../services/api_service.dart';

abstract class ToeicSource {
  Future<BaseResponse<ToeicQuestionResponse>> getPart125(int part, int limit);
  Future<BaseResponse<ToeicGroupQuestionResponse>> getPart3467(
      int part, int limit);
}

class ToeicSourceImpl extends ToeicSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<ToeicQuestionResponse>> getPart125(
      int part, int limit) async {
    const path = EndPoint.getPart;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'part': part, 'limit': limit};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<ToeicQuestionResponse>.fromJson(
          json: response, dataBuilder: ToeicQuestionResponse.fromJson),
    );

    LogUtil.debug('Get toeic test: $part');
    return _api.get(request);
  }

  @override
  Future<BaseResponse<ToeicGroupQuestionResponse>> getPart3467(
      int part, int limit) async {
    const path = EndPoint.getPart;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'part': part, 'limit': limit};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<ToeicGroupQuestionResponse>.fromJson(
          json: response, dataBuilder: ToeicGroupQuestionResponse.fromJson),
    );

    LogUtil.debug('Get toeic test: $part');
    return _api.get(request);
  }

  // @override
  // Future<BaseResponse> saveScoreToeicP1(
  //   List<int> listQid,
  //   List<String> listUserAnswer,
  // ) async {
  //   const path = EndPoint.saveScoreToeicP1Path;
  //   final token = await const FlutterSecureStorage()
  //       .read(key: HiveConfig.currentUserTokenKey);
  //   final header = {'Authorization': 'Bearer $token'};
  //   final bodyRequest = {'listQid': listQid, 'listUserAnswer': listUserAnswer};

  //   final getToeicP1Request = APIServiceRequest(
  //     path,
  //     header: header,
  //     dataBody: bodyRequest,
  //     (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
  //   );
  //   LogUtil.debug('save score toeic test: $path');
  //   return _api.post(getToeicP1Request);
  // }
}
