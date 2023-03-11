import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWrapper {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  AudioPlayer get getAudioPlayer => _audioPlayer;
  AudioPlayerWrapper() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped) {
        _playerState = PlayerState.stopped;
      } else if (state == PlayerState.playing) {
        _playerState = PlayerState.playing;
      } else if (state == PlayerState.paused) {
        _playerState = PlayerState.paused;
      }
    });
  }

  Future<void> play(String url) async {
    await _audioPlayer.play(AssetSource(url));
  }

  Future<void> playFromByte(Uint8List data) async {
    await _audioPlayer.play(BytesSource(data));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  PlayerState get playerState => _playerState;
}
