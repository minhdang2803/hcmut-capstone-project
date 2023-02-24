import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/data/repositories/video_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'last_watch_video_state.dart';

class LastWatchVideoCubit extends Cubit<LastWatchVideoState> {
  LastWatchVideoCubit() : super(LastWatchVideoState.initial());

  final instance = VideoRepository.instance();
  int getProcess(String videoId) {
    return instance.getProcess(videoId);
  }

  void saveProcess({
    required String mongoID,
    required int second,
  }) {
    instance.saveProcess(mongoID, second);
  }
}
