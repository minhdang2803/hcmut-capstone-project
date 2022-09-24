import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';

class AudioService {
  late final AssetsAudioPlayer player;
  final Playlist _playlist = Playlist();
  var _timeout = const Duration(minutes: 15); // default timeout
  Timer? _timer;

  void playOrPause() {
    if (_playlist.audios.isEmpty) {
      return;
    }
    if (player.isPlaying.value) {
      player.pause();
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }
      return;
    }
    player.play();
  }

  void setTimeOut(Duration timeout) {
    _timeout = timeout;
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    if (player.isPlaying.value) {
      _timer = Timer(_timeout, _onTimeOut);
    }
  }

  void playIndex(int index) {
    player.playlistPlayAtIndex(index);
  }

  void stop() {
    if (player.isPlaying.value) {
      player.stop();
    }
  }

  int getCurrentTimeout() => _timeout.inMinutes;

  void _onTimeOut() {
    player.stop();
  }

  void dispose() {
    player.dispose();
  }
}
