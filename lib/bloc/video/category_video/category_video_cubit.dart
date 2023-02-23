import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/video/video_models.dart';
import 'package:bke/data/repositories/video_repository.dart';
import 'package:bke/utils/log_util.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/connection_util.dart';

part 'category_video_state.dart';

class CategoryVideoCubit extends Cubit<CategoryVideoState> {
  CategoryVideoCubit() : super(CategoryVideoState.initial());
  final _videoRepository = VideoRepository.instance();
  Future<void> getMainActivities() async {
    try {
      emit(state.copyWith(status: CategoryVideoStatus.loading));
      final hasInternet = await ConnectionUtil.hasInternetConnection();
      if (!hasInternet) {
        emit(state.copyWith(errorMessage: 'Không có kết nối internet!'));
        return;
      }
      Map<String, List<VideoYoutubeInfo>> data = {};
      final results = await Future.wait([
        getVideo(pageKey: 1, pageSize: 5, category: "english ted-talk"),
        getVideo(pageKey: 1, pageSize: 5, category: "english ted-ed"),
        getVideo(pageKey: 1, pageSize: 5, category: "english in-a-nutshell")
      ]);

      if (results[0].isNotEmpty) {
        data['category1'] = results[0];
      }

      if (results[1].isNotEmpty) {
        data['category2'] = results[1];
      }
      if (results[2].isNotEmpty) {
        data['category3'] = results[2];
      }
      final lastWatch = await _videoRepository.getRecentlyWatchList();
      emit(
        state.copyWith(
            data: data, status: CategoryVideoStatus.done, videos: lastWatch),
      );
      LogUtil.debug('get main video activities OK');
    } on RemoteException catch (e, s) {
      emit(
        state.copyWith(
          errorMessage: e.errorMessage,
          status: CategoryVideoStatus.fail,
        ),
      );
      LogUtil.error('Get video error', error: e, stackTrace: s);
    }
  }

  Future<void> getRecentlyWatch() async {
    try {
      emit(state.copyWith(status: CategoryVideoStatus.loading));
      final response = await _videoRepository.getRecentlyWatchList();
      emit(state.copyWith(status: CategoryVideoStatus.done, videos: response));
    } on RemoteException catch (error) {
      emit(
        state.copyWith(
          errorMessage: error.errorMessage,
          status: CategoryVideoStatus.fail,
        ),
      );
    }
  }

  Future<List<VideoYoutubeInfo>> getVideo({
    required int pageKey,
    required int pageSize,
    required String category,
    int? level,
    String? title,
  }) async {
    try {
      final response = await _videoRepository.getAllVideos(
        pageKey: pageKey,
        pageSize: pageSize,
        category: category,
        level: level,
        title: title,
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

  void exit() {
    emit(CategoryVideoState.initial());
  }
}
