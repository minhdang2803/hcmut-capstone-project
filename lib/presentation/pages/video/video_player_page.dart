import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/sub_video.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.videoId});
  final String videoId;
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;

  final itemController = ItemScrollController();
  SubVideo? _subVideo;

  int _currentIndex = 0;
  int _currentDuration = 0;

  final _keys = List<GlobalKey>.generate(1000000, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    context.read<VideoCubit>().getSubVideo(widget.videoId);
  }

  void _goToSpan(int spanIndex) {
    Scrollable.ensureVisible(
      _keys[spanIndex].currentContext!,
      alignment: 0.2,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _resetCurrentIndex(PointerEvent details) {
    for (var element in _subVideo!.subs) {
      if ((_currentDuration > element.from) &&
          (_currentDuration < element.to)) {
        _currentIndex = element.index;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () => _controller.play(),
            child: Column(
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(controller: _controller),
                  builder: (context, player) {
                    return Listener(
                        onPointerUp: _resetCurrentIndex, child: player);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<VideoCubit, VideoState>(
              listener: (context, state) {
                if (state is SubVideoSuccess) {
                  setState(() {
                    _subVideo = state.subVideo;
                  });
                }
              },
              builder: (context, state) {
                if (state is SubVideoFailure) {
                  return const HolderWidget(
                    asset: 'assets/images/default_logo.png',
                    message: 'Fail to load video script!',
                  );
                }
                return _subVideo?.subs == null
                    ? Center(
                        child: Lottie.asset(
                          'assets/lotties/loading.json',
                          fit: BoxFit.contain,
                          width: 0.5.sw,
                        ),
                      )
                    : ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, YoutubePlayerValue value, child) {
                          _currentDuration = value.position.inMilliseconds;
                          return _buildSub();
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSub() {
    if (_currentIndex != 0) _goToSpan(_currentIndex);

    try {
      if (_currentDuration > _subVideo!.subs[_currentIndex].to) {
        _currentIndex++;
      }
    } catch (error) {
      // do nothing handle case currentIndex does not exists
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            children: _subVideo?.subs
                .map(
                  (e) => TextSpan(
                    children: [
                      WidgetSpan(child: SizedBox(key: _keys[e.index + 1])),
                      TextSpan(
                        text: e.text,
                        style: AppTypography.title.copyWith(
                          color: (_currentDuration > e.from) &&
                                  (_currentDuration < e.to)
                              ? AppColor.primary
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
