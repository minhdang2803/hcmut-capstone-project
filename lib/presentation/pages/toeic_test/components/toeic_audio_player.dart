import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToeicAudioPlayer extends StatelessWidget {
  const ToeicAudioPlayer({
    super.key,
    required this.isReal,
    required this.animationController,
    required this.audioService,
  });

  final bool isReal;
  final AudioService audioService;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isReal == false ? MediaQuery.of(context).size.width * 0.9 : null,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlayPauseButton(
            controller: animationController,
            onItemClick: () async {
              if (!audioService.player.isPlaying.value) {
                audioService.play();
              } else {
                audioService.stop();
              }
            },
          ),
          10.horizontalSpace,
          isReal == false
              ? Expanded(
                  child: AudioSeekBar(
                  audioPlayer: audioService.player,
                ))
              : AudioSeekBar(audioPlayer: audioService.player),
          10.horizontalSpace,
        ],
      ),
    );
  }
}
