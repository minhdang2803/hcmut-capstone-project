import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/network/base_response.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/models/video/sub_video_model.dart';
import '../../data/models/video/video_youtube_info_model.dart';
import '../../data/repositories/video_repository.dart';
import '../../utils/connection_util.dart';
import '../../utils/log_util.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit() : super(VideoState.initial());

  final _videoRepository = VideoRepository.instance();

  // Future<void> getMainActivities() async {
  //   try {
  //     emit(state.copyWith(status: VideoStatus.loading));
  //     final hasInternet = await ConnectionUtil.hasInternetConnection();
  //     if (!hasInternet) {
  //       emit(state.copyWith(errorMessage: 'Không có kết nối internet!'));
  //       return;
  //     }
  //     Map<String, List<VideoYoutubeInfo>> data = {};
  //     final results = await Future.wait([
  //       getVideo(pageKey: 1, pageSize: 5, category: "english ted-talk"),
  //       getVideo(pageKey: 1, pageSize: 5, category: "english ted-talk"),
  //       getVideo(pageKey: 1, pageSize: 5, category: "english ted-talk")
  //     ]);

  //     if (results[0].isNotEmpty) {
  //       data['category1'] = results[0];
  //     }

  //     if (results[1].isNotEmpty) {
  //       data['category2'] = results[1];
  //     }

  //     emit(state.copyWith(data: data, status: VideoStatus.done));
  //     LogUtil.debug('get main video activities OK');
  //   } catch (e, s) {
  //     emit(state.copyWith(
  //         errorMessage: 'Đã xảy ra lỗi, vui lòng thử lại sau',
  //         status: VideoStatus.fail));
  //     LogUtil.error('Get video error', error: e, stackTrace: s);
  //   }
  // }

  // Future<List<VideoYoutubeInfo>> getCategory2({
  //   required int pageKey,
  //   required int pageSize,
  //   required String category,
  //   int? level,
  //   String? title,
  // }) async {
  //   try {
  //     final response = await _videoRepository.getAllVideos(
  //       pageKey: pageKey,
  //       pageSize: pageSize,
  //       category: category,
  //       level: level,
  //       title: title,
  //     );
  //     final list = response.data?.list;
  //     return list ?? [];
  //   } on RemoteException catch (e, s) {
  //     LogUtil.error(
  //       'Get video list error: ${e.message}',
  //       error: e,
  //       stackTrace: s,
  //     );
  //   } catch (e, s) {
  //     LogUtil.error(
  //       'Get vide list error',
  //       error: e,
  //       stackTrace: s,
  //     );
  //   }
  //   return [];
  // }

  void getSubVideo(String videoId) async {
    try {
      emit(state.copyWith(status: VideoStatus.loading));
      final BaseResponse<SubVideo> response =
          await _videoRepository.getSubVideo(videoId);

      final data = response.data;
      emit(state.copyWith(subVideo: data, status: VideoStatus.done));
      LogUtil.debug('Get SubVideo success');
    } on RemoteException catch (e, s) {
      LogUtil.error('Get SubVideo error: ${e.httpStatusCode}',
          error: e, stackTrace: s);
      switch (e.code) {
        case RemoteException.noInternet:
          emit(state.copyWith(
              errorMessage: 'No internet connection!',
              status: VideoStatus.fail));
          break;
        case RemoteException.responseError:
          emit(state.copyWith(
              errorMessage: e.message, status: VideoStatus.fail));
          break;
        default:
          emit(state.copyWith(
              errorMessage: 'Please try again later!',
              status: VideoStatus.fail));
          break;
      }
    } catch (e, s) {
      emit(state.copyWith(
          errorMessage: 'Please try again later!', status: VideoStatus.fail));
      LogUtil.error('Get SubVideo error ', error: e, stackTrace: s);
    }
  }

  void exit() {
    emit(VideoState.initial());
  }
}
