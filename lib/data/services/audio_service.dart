import 'package:assets_audio_player/assets_audio_player.dart';

class AudioService {
  late final AssetsAudioPlayer player;

  AudioService() {
    player = AssetsAudioPlayer();
    player.setLoopMode(LoopMode.none);
    player.setVolume(0.5);
  }

  Future<void> setAudio(String audioFile) async {
    if (audioFile.isEmpty) {
      player.stop();
      return;
    }
    const defaultTitle = "Funny English";

    await player.open(
      Audio.file(
        audioFile,
        metas: Metas(
          title: defaultTitle,
          image: const MetasImage.asset('assets/images/default_logo.png'),
        ),
      ),
      autoStart: false,
      playInBackground: PlayInBackground.disabledPause,
      showNotification: true,
      loopMode: LoopMode.none,
      audioFocusStrategy: const AudioFocusStrategy.request(
        resumeAfterInterruption: true,
        resumeOthersPlayersAfterDone: true,
      ),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      respectSilentMode: false,
    );
  }

  Future<void> setAudioInternet(String audioFile) async {
    if (audioFile.isEmpty) {
      player.stop();
      return;
    }
    const defaultTitle = "Funny English";

    await player.open(
      Audio.network(
        audioFile,
        metas: Metas(
          title: defaultTitle,
          image: const MetasImage.asset('assets/images/default_logo.png'),
        ),
      ),
      autoStart: false,
      playInBackground: PlayInBackground.disabledPause,
      showNotification: true,
      loopMode: LoopMode.none,
      audioFocusStrategy: const AudioFocusStrategy.request(
        resumeAfterInterruption: true,
        resumeOthersPlayersAfterDone: true,
      ),
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      respectSilentMode: false,
    );
  }

  void playOrPause() {
    if (player.isPlaying.value) {
      player.pause();

      return;
    }
    player.play();
  }

  void play() {
    if (player.isPlaying.value) {
      return;
    }
    player.play();
  }

  void stop() {
    if (player.isPlaying.value) {
      player.stop();
    }
  }

  void dispose() {
    player.dispose();
  }
}
