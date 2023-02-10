part of 'last_watch_video_cubit.dart';

enum LastWatchVideoStatus { done, fail, initial, loading }

class LastWatchVideoState extends Equatable {
  LastWatchVideoState({this.videos, this.status});

  late final List<VideoYoutubeInfo>? videos;
  late final LastWatchVideoStatus? status;
  LastWatchVideoState.initial() {
    videos = [];
    status = LastWatchVideoStatus.initial;
  }
  LastWatchVideoState copyWith(
      List<VideoYoutubeInfo>? videos, LastWatchVideoStatus? status) {
    return LastWatchVideoState(
      videos: videos ?? this.videos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [];
}
