import 'package:assets_audio_player/assets_audio_player.dart';

class EffectAudioService {
  final moAssetPlayer = AssetsAudioPlayer.newPlayer();
  final chuongAssetPlayer = AssetsAudioPlayer.newPlayer();
  final thapNhangAssetPlayer = AssetsAudioPlayer.newPlayer();
  final thapNhangEffectAssetPlayer = AssetsAudioPlayer.newPlayer();

  void dispose() {
    moAssetPlayer.dispose();
    chuongAssetPlayer.dispose();
    thapNhangAssetPlayer.dispose();
    thapNhangEffectAssetPlayer.dispose();
  }

  void stop() {
    if (moAssetPlayer.isPlaying.value) {
      moAssetPlayer.stop();
    }
    if (chuongAssetPlayer.isPlaying.value) {
      chuongAssetPlayer.stop();
    }
    if (thapNhangAssetPlayer.isPlaying.value) {
      thapNhangAssetPlayer.stop();
    }
    if (thapNhangEffectAssetPlayer.isPlaying.value) {
      thapNhangEffectAssetPlayer.stop();
    }
  }

  void goMo() {
    if (moAssetPlayer.isPlaying.value) {
      moAssetPlayer.stop();
    }
    moAssetPlayer.play();
  }

  void goChuong() {
    if (chuongAssetPlayer.isPlaying.value) {
      chuongAssetPlayer.stop();
    }
    chuongAssetPlayer.play();
  }

  void thapNhang() {
    if (thapNhangAssetPlayer.isPlaying.value) {
      thapNhangAssetPlayer.stop();
    }
    if (thapNhangEffectAssetPlayer.isPlaying.value) {
      thapNhangEffectAssetPlayer.stop();
    }
    thapNhangAssetPlayer.play();
    thapNhangEffectAssetPlayer.play();
  }
}
