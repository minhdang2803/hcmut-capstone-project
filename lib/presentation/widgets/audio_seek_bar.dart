import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class AudioSeekBar extends StatefulWidget {
  const AudioSeekBar({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AssetsAudioPlayer audioPlayer;

  @override
  State<AudioSeekBar> createState() => _AudioSeekBarState();
}

class _AudioSeekBarState extends State<AudioSeekBar> {
  int _totalDuration = 1;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.onReadyToPlay.listen((audio) {
      if (!mounted) return;
      setState(() {
        _totalDuration = audio?.duration.inSeconds ?? 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.r,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: AppColor.defaultBorder,
      ),
      child: StreamBuilder(
        stream: widget.audioPlayer.currentPosition,
        builder: (context, AsyncSnapshot<Duration> snapshot) {
          return FractionallySizedBox(
            widthFactor: _getFactor(snapshot.data),
            child: Container(
              height: 4.r,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: AppColor.primary,
              ),
            ),
          );
        },
      ),
    );
  }

  double _getFactor(Duration? duration) {
    final currentPosition = duration?.inSeconds ?? 1;
    final factor = currentPosition / _totalDuration;
    return factor > 1 ? 1.0 : factor;
  }
}
