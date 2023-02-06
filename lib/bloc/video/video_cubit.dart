import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/models/video/sub_video.dart';
import '../../data/models/video/video_youtube_info.dart';
import '../../data/repositories/subvideo_repository.dart';
import '../../utils/connection_util.dart';
import '../../utils/log_util.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  final _videoRepository = VideoRepository.instance();

  Future<void> getMainActivities() async {
    try {
      emit(VideoLoading());
      final hasInternet = await ConnectionUtil.hasInternetConnection();
      if (!hasInternet) {
        emit(const VideoYoutubeInfoFailure('Không có kết nối internet!'));
        return;
      }
      Map<String, List<VideoYoutubeInfo>> data = {};
      final results = await Future.wait([
        getCategory1(pageKey: 1, pageSize: 5),
        getCategory1(pageKey: 1, pageSize: 5),
        getCategory1(pageKey: 1, pageSize: 5)
      ]);

      if (results[0].isNotEmpty) {
        data['category1'] = results[0];
      }

      if (results[1].isNotEmpty) {
        data['category2'] = results[1];
      }

      emit(VideoYoutubeInfoSuccess(data));
      LogUtil.debug('get main video activities OK');
    } catch (e, s) {
      emit(
          const VideoYoutubeInfoFailure('Đã xảy ra lỗi, vui lòng thử lại sau'));
      LogUtil.error('Get video error', error: e, stackTrace: s);
    }
  }

  Future<List<VideoYoutubeInfo>> getCategory1({
    required int pageKey,
    required pageSize,
  }) async {
    try {
      final response = await _videoRepository.getAllVideos(
        pageKey: pageKey,
        pageSize: pageSize,
      );
      final list = response.data?.list;
      return list ?? [];
    } on RemoteException catch (e, s) {
      LogUtil.error(
        'Get video list error: ${e.message}',
        error: e,
        stackTrace: s,
      );
    } catch (e, s) {
      LogUtil.error(
        'Get vide list error',
        error: e,
        stackTrace: s,
      );
    }
    return [];
  }

  Future<List<VideoYoutubeInfo>> getCategory2({
    required int pageKey,
    required pageSize,
  }) async {
    try {
      final response = await _videoRepository.getAllVideos(
        pageKey: pageKey,
        pageSize: pageSize,
      );
      final list = response.data?.list;
      return list ?? [];
    } on RemoteException catch (e, s) {
      LogUtil.error(
        'Get video list error: ${e.message}',
        error: e,
        stackTrace: s,
      );
    } catch (e, s) {
      LogUtil.error(
        'Get vide list error',
        error: e,
        stackTrace: s,
      );
    }
    return [];
  }

  void getSubVideo(String videoId) async {
    try {
      emit(VideoLoading());
      final BaseResponse<SubVideo> response =
          await _videoRepository.getSubVideo(videoId);

      final data = response.data;
      emit(SubVideoSuccess(data));
      LogUtil.debug('Get SubVideo success');
    } on RemoteException catch (e, s) {
      LogUtil.error('Get SubVideo error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(const SubVideoFailure('No internet connection!'));
          break;
        case RemoteException.responseError:
          emit(SubVideoFailure(e.message));
          break;
        default:
          emit(const SubVideoFailure('Please try again later!'));
          break;
      }
    } catch (e, s) {
      emit(const SubVideoFailure('Please try again later!'));
      LogUtil.error('Get SubVideo error ', error: e, stackTrace: s);
    }
  }

  // void getYoutubeVideoList({required int pageKey}) async {
  //   try {
  //     emit(VideoLoading());
  //     final response = await _videoRepository.getYoutubeVideoList(
  //       pageKey: pageKey,
  //     );
  //     final dataList = response.data?.list ?? [];
  //     emit(VideoYoutubeInfoSuccess(dataList));
  //   } on RemoteException catch (e, s) {
  //     if (e.code == RemoteException.noInternet) {
  //       emit(const VideoYoutubeInfoFailure('No internet connection!'));
  //     } else if (e.httpStatusCode == 404) {
  //       emit(const VideoYoutubeInfoSuccess([]));
  //     } else {
  //       emit(const VideoYoutubeInfoFailure('Please try again later!'));
  //       LogUtil.error('Get list video error ${e.message}',
  //           error: e, stackTrace: s);
  //     }
  //   } catch (e, s) {
  //     emit(VideoYoutubeInfoFailure(e.toString()));
  //     LogUtil.error('Get list video error', error: e, stackTrace: s);
  //   }
  // }
}
