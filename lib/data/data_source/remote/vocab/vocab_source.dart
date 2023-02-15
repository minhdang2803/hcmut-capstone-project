import 'package:bke/data/models/vocab/vocab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../services/api_service.dart';

abstract class VocabSource {
  Future<BaseResponse<VocabInfos>> getVocabInfos(String vocab);
  Future<BaseResponse<VocabInfo>> getVocabById(int id);
  Future<BaseResponse<List<VocabInfo>>> getVocabsByIdList(List<int> ids);
}

class VocabSourceImpl extends VocabSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<VocabInfos>> getVocabInfos(String vocab) async {
    const path = EndPoint.getVocabInfos;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final params = {'vocab': vocab};

    final getVocabInfos = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<VocabInfos>.fromJson(
          json: response, dataBuilder: VocabInfos.fromJson),
    );
    LogUtil.debug('get vocab infos: $path $params');
    return _api.get(getVocabInfos);
  }

  @override
  Future<BaseResponse<VocabInfo>> getVocabById(int id) async {
    const String path = EndPoint.findVocabById;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final params = {'vocabId': id};
    final getVocabById = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<VocabInfo>.fromJson(
          json: response, dataBuilder: VocabInfo.fromJson),
    );
    LogUtil.debug('Vocab id: $path $id');
    return _api.get(getVocabById);
  }

  @override
  Future<BaseResponse<List<VocabInfo>>> getVocabsByIdList(List<int> ids) async {
    const String path = EndPoint.findVocabsByListId;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final bodyRequest = {'listVocab': ids};
    final getVocabById = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) {
        return BaseResponse<List<VocabInfo>>.fromJson(
            json: response, dataBuilder: VocabInfo.fromJsonList);
      },
    );
    LogUtil.debug('Vocab id List: $path $ids');
    return _api.post(getVocabById);
  }
}
