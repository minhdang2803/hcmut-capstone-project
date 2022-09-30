import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/toeic/toeic_test.dart';
import '../../../services/api_service.dart';

abstract class ToeicSource {
  Future<BaseResponse<ToeicTest>> getToeicP1QandA();
}

class ToeicSourceImpl extends ToeicSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<ToeicTest>> getToeicP1QandA() async {
    const path = EndPoint.toeicPath;
    final getToeicP1Request = APIServiceRequest(
      path,
      (response) => BaseResponse<ToeicTest>.fromJson(
          json: response, dataBuilder: ToeicTest.fromJson),
    );
    LogUtil.debug('Get toeic test: $path');
    return _api.get(getToeicP1Request);
  }
}
