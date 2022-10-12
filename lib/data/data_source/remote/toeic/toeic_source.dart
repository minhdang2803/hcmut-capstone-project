import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/toeic/toeic_test.dart';
import '../../../services/api_service.dart';

abstract class ToeicSource {
  Future<BaseResponse<ToeicTest>> getToeicP1QandA();
  Future<BaseResponse> saveScoreToeicP1(
    List<int> listQid,
    List<String> listUserAnswer,
  );
}

class ToeicSourceImpl extends ToeicSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<ToeicTest>> getToeicP1QandA() async {
    const path = EndPoint.getToeicP1Path;
    final getToeicP1Request = APIServiceRequest(
      path,
      (response) => BaseResponse<ToeicTest>.fromJson(
          json: response, dataBuilder: ToeicTest.fromJson),
    );
    LogUtil.debug('Get toeic test: $path');
    return _api.get(getToeicP1Request);
  }

  @override
  Future<BaseResponse> saveScoreToeicP1(
    List<int> listQid,
    List<String> listUserAnswer,
  ) async {
    const path = EndPoint.saveScoreToeicP1Path;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final bodyRequest = {'listQid': listQid, 'listUserAnswer': listUserAnswer};

    final getToeicP1Request = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );
    LogUtil.debug('save score toeic test: $path');
    return _api.post(getToeicP1Request);
  }
}
