import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/models/toeic/toeic_test.dart';
import '../../data/repositories/toeicp1_repository.dart';
import '../../utils/log_util.dart';

part 'toeic_state.dart';

class ToeicCubit extends Cubit<ToeicState> {
  ToeicCubit() : super(ToeicInitial());

  final _toeicRepository = ToeicP1Repository.instance();

  void getToeicP1QandA() async {
    try {
      emit(ToeicLoading());
      final BaseResponse<ToeicTest> response =
          await _toeicRepository.getToeicP1QandA();
      final data = response.data!;
      emit(ToeicSuccess(data));
      LogUtil.debug(
          'Get toeic success: ${response.data?.toJson() ?? 'empty toeic'}');
    } on RemoteException catch (e, s) {
      LogUtil.error('Login error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const ToeicFailure('Không có kết nối internet!'));
          break;
        case RemoteException.responseError:
          emit(ToeicFailure(e.message));
          break;
        default:
          emit(const ToeicFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
          break;
      }
    } catch (e, s) {
      emit(const ToeicFailure('Đã xảy ra lỗi, vui lòng thử lại sau!'));
      LogUtil.error('Login error ', error: e, stackTrace: s);
    }
  }
}
