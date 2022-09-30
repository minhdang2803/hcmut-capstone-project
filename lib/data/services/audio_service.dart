import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';

class AudioService {
  late final AssetsAudioPlayer player;
  Playlist _playlist = Playlist();
  var _timeout = const Duration(minutes: 15); // default timeout

  AudioService() {
    player = AssetsAudioPlayer();
    player.setLoopMode(LoopMode.playlist);

    player.setVolume(0.5);
  }

  void setAudioList(List<String> audioFiles) {
    if (audioFiles.isEmpty) {
      return;
    }
    const defaultTitle = "my music";
    _playlist = Playlist(
      startIndex: 0,
      audios: audioFiles
          .map((audio) => Audio.network(
                audio,
                metas: Metas(
                  title: defaultTitle,
                  image: const MetasImage.asset('assets/images/thien_bg.png'),
                ),
              ))
          .toList(),
    );
    player.open(
      _playlist,
      autoStart: false,
      playInBackground: PlayInBackground.enabled,
      showNotification: true,
      loopMode: LoopMode.playlist,
      audioFocusStrategy: const AudioFocusStrategy.request(
        resumeAfterInterruption: true,
        resumeOthersPlayersAfterDone: true,
      ),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      respectSilentMode: false,
    );
  }

  void playOrPause() {
    if (_playlist.audios.isEmpty) {
      return;
    }
    if (player.isPlaying.value) {
      player.pause();

      return;
    }
    player.play();
  }

  void setTimeOut(Duration timeout) {
    _timeout = timeout;
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

  void dispose() {
    player.dispose();
  }
}
