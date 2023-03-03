// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import '../../data/models/network/base_response.dart';
// import '../../data/models/network/cvn_exception.dart';
// import '../../data/models/toeic/toeic_test.dart';
// import '../../data/repositories/toeic_repository.dart';
// import '../../utils/log_util.dart';

// part 'toeic_state.dart';

// class ToeicCubit extends Cubit<ToeicState> {
//   ToeicCubit() : super(ToeicInitial());

//   final _toeicRepository = ToeicRepository.instance();

//   void getToeicP1QandA() async {
//     try {
//       emit(ToeicLoading());
//       final BaseResponse<ToeicTest> response =
//           await _toeicRepository.getToeicP1QandA();

//       final data = response.data!;
//       emit(ToeicSuccess(data));
//       LogUtil.debug(
//           'Get toeic success: ${response.data?.toJson() ?? 'empty toeic'}');
//     } on RemoteException catch (e, s) {
//       LogUtil.error('Get toeicP1 error: ${e.httpStatusCode}',
//           error: e, stackTrace: s);
//       switch (e.code) {
//         case RemoteException.noInternet:
//           emit(const ToeicFailure('No internet connection!'));
//           break;
//         case RemoteException.responseError:
//           emit(ToeicFailure(e.message));
//           break;
//         default:
//           emit(const ToeicFailure('Please try again later!'));
//           break;
//       }
//     } catch (e, s) {
//       emit(const ToeicFailure('Please try again later!'));
//       LogUtil.error('Get toeicP1 error ', error: e, stackTrace: s);
//     }
//   }

//   void saveScoreToeicP1(
//     List<int> listQid,
//     List<String> listUserAnswer,
//   ) async {
//     try {
//       emit(ToeicLoading());
//       await _toeicRepository.saveScoreToeicP1(listQid, listUserAnswer);

//       emit(const SaveScoreToeicP1Success('Save score toeic P1 successfully'));
//       LogUtil.debug('Save score toeicP1 successfully.');
//     } on RemoteException catch (e, s) {
//       LogUtil.error('Save score toeicP1 error: ${e.httpStatusCode}',
//           error: e, stackTrace: s);
//       switch (e.code) {
//         case RemoteException.noInternet:
//           emit(const SaveScoreToeicP1Failure('No internet connection!'));
//           break;
//         case RemoteException.responseError:
//           emit(SaveScoreToeicP1Failure(e.message));
//           break;
//         default:
//           emit(const SaveScoreToeicP1Failure('Please try again later!'));
//           break;
//       }
//     } catch (e, s) {
//       emit(const SaveScoreToeicP1Failure('Please try again later!'));
//       LogUtil.error('Save score toeicP1 error ', error: e, stackTrace: s);
//     }
//   }
// }
