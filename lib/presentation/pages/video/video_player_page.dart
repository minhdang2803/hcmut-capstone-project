import 'package:bke/bloc/video/category_video/category_video_cubit.dart';
import 'package:bke/bloc/video/last_watch_video/last_watch_video_cubit.dart';
import 'package:bke/data/models/video/video_youtube_info_model.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/sub_video_model.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';
import 'component/bottom_vocabulary.dart';

class VideoPlayerPageModel {
  final BuildContext context;
  final VideoYoutubeInfo video;
  VideoPlayerPageModel({required this.context, required this.video});
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required this.video});
  final VideoYoutubeInfo video;
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  final itemController = ItemScrollController();
  SubVideo? _subVideo;
  bool isCaptionOn = false;
  int _currentIndex = 0;
  int _currentDuration = 0;

  final _keys = List<GlobalKey>.generate(1000000, (_) => GlobalKey());

  void _onDictionarySearch(String text) {
    // pause video
    _controller.pause();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomVocab(text: text),
    );
  }

  List<String> splitWord(String subText) {
    final eachCharList = subText.split(" ");
    List<String> result = [];
    String tempWord = '';
    for (final element in eachCharList) {
      if (element.contains("[") && element.contains("]")) {
        result.add(element);
      } else if (element.contains('[') && !element.contains(']')) {
        tempWord = "$tempWord$element ";
      } else if (!element.contains('[') && element.contains(']')) {
        tempWord = tempWord + element;
        result.add(tempWord);
        tempWord = "";
      } else if (!element.contains('[') && !element.contains(']')) {
        result.add(element);
      }
    }
    return result;
  }

  List<TextSpan> createTextSpans(String subText, TextStyle style) {
    final arrayStrings = splitWord(subText);
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      var text = arrayStrings[index];
      TextSpan span = const TextSpan();
      // first is the word highlight recommended by admin [example] and ending with , or .
      if (text.contains('[') && text.contains(']')) {
        text = text.trim().substring(1, text.length - 1);
        span = TextSpan(
          text: '$text ',
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _onDictionarySearch(text.toLowerCase());
            },
        );
      } else {
        // the normalword
        span = TextSpan(
          text: "$text ",
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _onDictionarySearch(text.toLowerCase());
            },
        );
      }

      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

  @override
  void initState() {
    super.initState();
    int lastWatch = widget.video.checkpoint ?? 0;
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.videoId,
      flags: YoutubePlayerFlags(
        startAt: lastWatch,
        autoPlay: true,
        enableCaption: false,
      ),
    );

    context.read<VideoCubit>().getSubVideo(widget.video.videoId);
  }

  void _goToSpan(int spanIndex) {
    if (_keys[spanIndex].currentContext != null) {
      Scrollable.ensureVisible(
        _keys[spanIndex].currentContext!,
        alignment: 0.2,
        duration: const Duration(milliseconds: 300),
      );
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: orientation == Orientation.portrait
          ? AppBar(
              leading: BackButton(
                color: AppColor.textPrimary,
                onPressed: () {
                  context.read<VideoCubit>().exit();
                  widget.video.id != null
                      ? context.read<LastWatchVideoCubit>().saveProcess(
                            mongoID: widget.video.id!,
                            second: _currentDuration ~/ 1000,
                          )
                      : null;

                  Navigator.pop(context, true);
                },
              ),
              title: Text(
                widget.video.title,
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          : null,
      body: Column(
        children: [
          GestureDetector(
            onTap: () => _controller.play(),
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                bottomActions: [
                  CurrentPosition(),
                  5.horizontalSpace,
                  ProgressBar(isExpanded: true),
                  PlaybackSpeedButton(controller: _controller),
                  FullScreenButton(),
                ],
                controller: _controller,
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    orientation == Orientation.landscape
                        ? SizedBox(
                            width: size.width,
                            height: size.height,
                            child: Listener(
                              onPointerUp: _resetCurrentIndex,
                              child: player,
                            ),
                          )
                        : Listener(
                            onPointerUp: _resetCurrentIndex,
                            child: player,
                          ),
                  ],
                );
              },
            ),
          ),
          Visibility(
            visible: orientation == Orientation.portrait,
            child: Expanded(
              child: BlocConsumer<VideoCubit, VideoState>(
                listener: (context, state) {
                  if (state.status == VideoStatus.done) {
                    _subVideo = state.subVideo;
                  }
                },
                builder: (context, state) {
                  if (state.status == VideoStatus.fail) {
                    return const HolderWidget(
                      asset: 'assets/images/error.png',
                      message: 'Fail to load video script!',
                    );
                  } else if (state.status == VideoStatus.done) {
                    return _subVideo?.subs == null
                        ? _buildLoadingSkeleton()
                        : ValueListenableBuilder(
                            valueListenable: _controller,
                            builder:
                                (context, YoutubePlayerValue value, child) {
                              _currentDuration = value.position.inMilliseconds;
                              return _buildSub();
                            },
                          );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.accentBlue,
                      ),
                    );
                  }
                },
              ),
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
                                ? AppColor.mainPink
                                : AppColor.textPrimary,
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
                minLength: 100.r,
                maxLength: 200.r,
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
