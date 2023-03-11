import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/calendar_activities/calendar_response.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../services/api_service.dart';

abstract class CalendarActivitiesRemoteSource {
  Future<BaseResponse<CalendarResponse>> getHistoryActivities({
    required String yearMonth,
  });
}

class CalendarActivitiesRemoteSourceImpl
    extends CalendarActivitiesRemoteSource {
  final APIService _api = APIService.instance();

  @override
  Future<BaseResponse<CalendarResponse>> getHistoryActivities({
    required String yearMonth,
  }) async {
    const path = EndPoint.getHistoryActivities;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> body = {
      'yearMonth': yearMonth,
    };
    LogUtil.debug(yearMonth);

    final request = APIServiceRequest(
      path,
      dataBody: body,
      (response) => BaseResponse<CalendarResponse>.fromJson(
        json: response,
        dataBuilder: CalendarResponse.fromJson,
      ),
      header: header,
    );
    return _api.post(request);
  }
}
