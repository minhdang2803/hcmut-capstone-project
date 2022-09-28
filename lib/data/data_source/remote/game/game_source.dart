import 'package:bke/data/models/network/base_response.dart';

import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/quiz/game.dart';
import '../../../services/api_service.dart';

abstract class GameSource {
  Future<BaseResponse<Game>> getGame();
}

class GameSourceImpl extends GameSource {
  final APIService _api = APIService.instance();
  @override
  Future<BaseResponse<Game>> getGame() async {
    const path = EndPoint.gamePath;
    final getGameRequest = APIServiceRequest(
      path,
      (response) => BaseResponse<Game>.fromJson(
          json: response, dataBuilder: Game.fromJson),
    );
    LogUtil.debug('Get game: $path');
    return _api.get(getGameRequest);
  }
}
