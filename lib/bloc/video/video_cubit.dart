import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/models/video/sub_video.dart';
import '../../data/models/video/video_youtube_info.dart';
import '../../data/repositories/subvideo_repository.dart';
import '../../utils/log_util.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoInitial());

  final _videoRepository = VideoRepository.instance();

  void getSubVideo(String videoId) async {
    try {
      emit(VideoLoading());
      final BaseResponse<SubVideo> response =
          await _videoRepository.getSubVideo(videoId);

      final data = response.data!;
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

  void getYoutubeVideoList({required int pageKey}) async {
    try {
      emit(VideoLoading());
      final response = await _videoRepository.getYoutubeVideoList(
        pageKey: pageKey,
      );
      final dataList = response.data?.list ?? [];
      emit(VideoYoutubeInfoSuccess(dataList));
    } on RemoteException catch (e, s) {
      if (e.code == RemoteException.noInternet) {
        emit(const VideoYoutubeInfoFailure('No internet connection!'));
      } else if (e.httpStatusCode == 404) {
        emit(const VideoYoutubeInfoSuccess([]));
      } else {
        emit(const VideoYoutubeInfoFailure('Please try again later!'));
        LogUtil.error('Get list video error ${e.message}',
            error: e, stackTrace: s);
      }
    } catch (e, s) {
      emit(VideoYoutubeInfoFailure(e.toString()));
      LogUtil.error('Get list video error', error: e, stackTrace: s);
    }
  }
}
