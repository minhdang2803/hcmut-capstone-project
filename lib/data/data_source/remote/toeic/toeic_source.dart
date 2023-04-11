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
  Future<BaseResponse<void>> updateScore(
      {required Map<String, dynamic> data, required int part});
  Future<BaseResponse<ToeicHistoryResponse>> getHistory();
  Future<BaseResponse<ToeicQuestionResponse>> getReviewPart125(String id);
  Future<BaseResponse<ToeicGroupQuestionResponse>> getReviewPart3467(String id);
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

  @override
  Future<BaseResponse<void>> updateScore({
    required Map<String, dynamic> data,
    required int part,
  }) async {
    const path = EndPoint.submitToeicScore;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final bodyRequest = {'part$part': data};
    final request = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) =>
          BaseResponse<void>.fromJson(json: response, dataBuilder: null),
    );
    LogUtil.debug("Get toeic test: ${{'part$part': data}}");
    return _api.post(request);
  }

  @override
  Future<BaseResponse<ToeicHistoryResponse>> getHistory() async {
    const path = EndPoint.toeicHistory;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final request = APIServiceRequest(
      path,
      header: header,
      (response) => BaseResponse<ToeicHistoryResponse>.fromJson(
        json: response,
        dataBuilder: ToeicHistoryResponse.fromJson,
      ),
    );
    return _api.get(request);
  }

  @override
  Future<BaseResponse<ToeicQuestionResponse>> getReviewPart125(
      String id) async {
    const path = EndPoint.toeicHistoryReview;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {"attemptId": id};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<ToeicQuestionResponse>.fromJson(
        json: response,
        dataBuilder: ToeicQuestionResponse.fromJson,
      ),
    );
    return _api.get(request);
  }

  @override
  Future<BaseResponse<ToeicGroupQuestionResponse>> getReviewPart3467(
      String id) async {
    const path = EndPoint.toeicHistoryReview;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {"attemptId": id};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse<ToeicGroupQuestionResponse>.fromJson(
        json: response,
        dataBuilder: ToeicGroupQuestionResponse.fromJson,
      ),
    );
    return _api.get(request);
  }
}
