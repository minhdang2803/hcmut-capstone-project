import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/sub_video.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';
import 'component/bottom_vocabulary.dart';

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

  void _onDictionarySearch(String text) {
    // pause video
    _controller.pause();

    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomVocab(text: text),
    );
  }

  List<TextSpan> createTextSpans(String subText, TextStyle style) {
    final arrayStrings = subText.split(" ");
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      final text = "${arrayStrings[index]} ";
      final span = (text[0] == '[')
          ? TextSpan(
              text: '${text.substring(1, text.length - 2)} ',
              style: style.copyWith(color: AppColor.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _onDictionarySearch(
                    '${text.substring(1, text.length - 2)}'),
            )
          : TextSpan(
              text: text,
              style: style,
            );
      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

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
                    ? _buildLoadingSkeleton()
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
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
      child: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            children: _subVideo?.subs
                .map(
                  (e) => TextSpan(
                    children: [
                      WidgetSpan(child: SizedBox(key: _keys[e.index + 1])),
                      TextSpan(
                        children: createTextSpans(
                          e.text,
                          AppTypography.title.copyWith(
                            color: (_currentDuration > e.from) &&
                                    (_currentDuration < e.to)
                                ? AppColor.primary
                                : Colors.black,
                          ),
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

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => Column(
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
              ),
            ),
            SizedBox(height: 6.r),
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
              ),
            ),
            SizedBox(height: 6.r),
            SkeletonLine(
              style: SkeletonLineStyle(
                randomLength: true,
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                minLength: MediaQuery.of(context).size.width / 6,
                maxLength: MediaQuery.of(context).size.width / 3,
              ),
            ),
            SizedBox(height: 6.r),
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
              ),
            ),
            SizedBox(height: 6.r),
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
              ),
            ),
            SizedBox(height: 6.r),
            SkeletonLine(
              style: SkeletonLineStyle(
                randomLength: true,
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                minLength: 260.r,
                maxLength: 300.r,
              ),
            ),
          ],
        ),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 20.r);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
