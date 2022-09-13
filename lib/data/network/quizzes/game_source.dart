import 'package:capstone_project_hcmut/data/client/api_services.dart';
import 'package:capstone_project_hcmut/data/network/api.dart';
import 'package:capstone_project_hcmut/data/network/api_request_model.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/utils/logger.dart';

abstract class GameSource {
  Future<QuizOneResponseModel> getGameLevelOne();
}

class GameSourceImpl extends GameSource {
  final APIService _api = APIService.instance();
  @override
  Future<QuizOneResponseModel> getGameLevelOne() async {
    const path = EndPoint.quizzLevelOne;
    final getGameRequest = APIServiceRequest(
      path,
      (response) => QuizOneResponseModel.fromJson(response),
    );
    LogUtil.debug('Get game: $path');
    return _api.get(getGameRequest);
  }
}
