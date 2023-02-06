part of 'video_cubit.dart';

// abstract class VideoState extends Equatable {
//   const VideoState();
// }

// class VideoInitial extends VideoState {
//   @override
//   List<Object> get props => [];
// }

// class VideoLoading extends VideoState {
//   @override
//   List<Object> get props => [];
// }

// class SubVideoSuccess extends VideoState {
//   const SubVideoSuccess(this.subVideo);

//   final SubVideo? subVideo;

//   @override
//   List<Object?> get props => [subVideo];
// }

// class SubVideoFailure extends VideoState {
//   const SubVideoFailure(this.errorMessage, {this.errorCode});

//   final int? errorCode;
//   final String errorMessage;
//   @override
//   List<Object?> get props => [errorCode, errorMessage];
// }

// class VideoYoutubeInfoSuccess extends VideoState {
//   const VideoYoutubeInfoSuccess(this.data);

//   final Map<String, List<VideoYoutubeInfo>> data;

//   @override
//   List<Object?> get props => [data];
// }

// class VideoYoutubeInfoFailure extends VideoState {
//   const VideoYoutubeInfoFailure(this.errorMessage, {this.errorCode});

//   final int? errorCode;
//   final String errorMessage;
//   @override
//   List<Object?> get props => [errorCode, errorMessage];
// }

enum VideoStatus { loading, done, fail, initial }

class VideoState extends Equatable {
  late final SubVideo? subVideo;
  late final String? errorMessage;
  late final VideoStatus? status;
  late final Map<String, List<VideoYoutubeInfo>>? data;
  late final int? duration;
  late final int? currentIndex;
  VideoState.initial() {
    subVideo = null;
    errorMessage = '';
    status = VideoStatus.initial;
    data = {};
    duration = 0;
    currentIndex = 0;
  }
  VideoState({
    this.subVideo,
    this.errorMessage,
    this.status,
    this.data,
    this.duration,
    this.currentIndex,
  });

  VideoState copyWith({
    SubVideo? subVideo,
    String? errorMessage,
    VideoStatus? status,
    Map<String, List<VideoYoutubeInfo>>? data,
    int? duration,
    int? currentIndex,
  }) {
    return VideoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      subVideo: subVideo ?? this.subVideo,
      data: data ?? this.data,
      duration: duration ?? this.duration,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [
        subVideo,
        errorMessage,
        status,
        data,
        currentIndex,
        duration,
      ];
}
