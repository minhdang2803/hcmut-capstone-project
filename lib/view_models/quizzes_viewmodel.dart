import 'package:capstone_project_hcmut/data/repository/quizzes_feature/quizzes_repository.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_provider_model.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';

///Only for Level One of quiz
class QuizzesViewModel extends BaseProvider {
  final BaseProviderModel<GameRepository> _data = BaseProviderModel.init(
    data: GameRepository.instance(),
  );
  BaseProviderModel<GameRepository> get data => _data;
  GameRepository get instance => _data.data!;

  ///List of Game in Level
  Map<String, Object> responseQuizz = {}; //there is 20

  ///Game 1 of Level 1
  Future<void> getQuizOne() async {
    try {
      late QuizOneResponseModel? response;
      setStatus(ViewState.loading, notify: true);
      response = await instance.getGameLevelOne();
      responseQuizz.update(
        'quiz1',
        (value) => response as Object,
        ifAbsent: () => response as Object,
      );
      setStatus(ViewState.done, notify: true);
    } on Exception catch (error) {
      setStatus(ViewState.fail, notify: true);
      print(error);
    } finally {}
  }
}
