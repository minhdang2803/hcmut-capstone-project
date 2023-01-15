part of 'video_cubit.dart';

abstract class VideoState extends Equatable {
  const VideoState();
}

class VideoInitial extends VideoState {
  @override
  List<Object> get props => [];
}

class VideoLoading extends VideoState {
  @override
  List<Object> get props => [];
}

class SubVideoSuccess extends VideoState {
  const SubVideoSuccess(this.subVideo);

  final SubVideo? subVideo;

  @override
  List<Object?> get props => [subVideo];
}

class SubVideoFailure extends VideoState {
  const SubVideoFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;
  @override
  List<Object?> get props => [errorCode, errorMessage];
}

class VideoYoutubeInfoSuccess extends VideoState {
  const VideoYoutubeInfoSuccess(this.data);

  final Map<String, List<VideoYoutubeInfo>> data;

  @override
  List<Object?> get props => [data];
}

class VideoYoutubeInfoFailure extends VideoState {
  const VideoYoutubeInfoFailure(this.errorMessage, {this.errorCode});

  final int? errorCode;
  final String errorMessage;
  @override
  List<Object?> get props => [errorCode, errorMessage];
}
