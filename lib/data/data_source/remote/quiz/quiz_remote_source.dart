import 'package:bke/data/models/network/api_service_request.dart';
import 'package:bke/data/models/network/base_response.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/data/services/api_service.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/cvn_exception.dart';

abstract class QuizRemoteSource {
  Future<BaseResponse<QuizMultipleChoiceResponse>> getMultipleChoicesByLevel(
      int id);
}

class QuizRemoteSourceImpl implements QuizRemoteSource {
  final _api = APIService.instance();
  @override
  Future<BaseResponse<QuizMultipleChoiceResponse>> getMultipleChoicesByLevel(
      int id) async {
    try {
      const String path = EndPoint.getMultipleChoiceQuiz;
      final token = await const FlutterSecureStorage()
          .read(key: HiveConfig.currentUserTokenKey);
      final header = {'Authorization': 'Bearer $token'};
      final body = {'id': id};
      final request = APIServiceRequest(
        path,
        header: header,
        dataBody: body,
        (response) => BaseResponse<QuizMultipleChoiceResponse>.fromJson(
          json: response,
          dataBuilder: QuizMultipleChoiceResponse.fromJson,
        ),
      );
      LogUtil.debug('Get multiple choice quiz JSON: $id ');
      return _api.post(request);
    } on RemoteException catch (error) {
      throw RemoteException(RemoteException.responseError, error.errorMessage);
    }
  }
}
