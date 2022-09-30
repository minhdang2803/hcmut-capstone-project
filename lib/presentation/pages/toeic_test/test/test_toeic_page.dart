import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../data/models/toeic/toeic_part1/toeic_part1_qna.dart';
import '../../../../data/services/audio_service.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/audio_seek_bar.dart';
import '../../../widgets/cvn_app_bar.dart';
import '../../../widgets/play_pause_button.dart';
import '../../../widgets/step_indicator_item.dart';

class TestToeicPage extends StatefulWidget {
  const TestToeicPage({Key? key}) : super(key: key);

  @override
  State<TestToeicPage> createState() => _TestToeicPageState();
}

class _TestToeicPageState extends State<TestToeicPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _animationController;
  late final AudioService _toeicP1AudioService;

  int _selectedIndex = 0;
  final _scrollController = ScrollController();
  final _indicatorScrollController = AutoScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _toeicP1AudioService = AudioService();
    _toeicP1AudioService.player.isPlaying.listen((isPlaying) {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _onAudioItemSelected(int index) {
    _toeicP1AudioService.playIndex(index);
    Navigator.of(context).pop();
  }

  void _onItemSelected(int index) {
    _toeicP1AudioService.stop();
    _indicatorScrollController.scrollToIndex(
      index,
      duration: const Duration(milliseconds: 350),
    );
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isLastStep(int index, List<ToeicP1QandA> quizs) {
    return index == quizs.length - 1;
  }

  bool _isFirstStep(int index) {
    return index == 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          const CVNAppBar(label: 'Toeic'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final topPadding = MediaQuery.of(context).padding.top;
    final quizs =
        ModalRoute.of(context)?.settings.arguments as List<ToeicP1QandA>;
    final audioList = quizs.map((e) => e.mp3URL).toList();
    _toeicP1AudioService.setAudioList(audioList);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: false,
      interactive: true,
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: 63.r + topPadding,
          bottom: 30.r,
        ),
        children: [
          _buildStepsIndicator(quizs),
          _buildStepsContent(quizs),
        ],
      ),
    );
  }

  Widget _buildStepsIndicator(List<ToeicP1QandA> quizs) {
    return Container(
      height: 90.r,
      alignment: Alignment.center,
      child: ListView.builder(
        controller: _indicatorScrollController,
        padding: EdgeInsets.symmetric(horizontal: 30.r),
        scrollDirection: Axis.horizontal,
        itemCount: quizs.length,
        itemBuilder: (context, index) => AutoScrollTag(
          key: ValueKey(index),
          controller: _indicatorScrollController,
          index: index,
          child: UnconstrainedBox(
            child: StepIndicatorItem(
              step: quizs[index].qid,
              isSelected: index == _selectedIndex,
              isLastItem: _isLastStep(index, quizs),
              onItemClick: () => _onItemSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioController() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.r, 10.r, 20.r, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PlayPauseButton(
            controller: _animationController,
            onItemClick: () {
              if (_toeicP1AudioService.player.isPlaying.value) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
              _toeicP1AudioService.playOrPause();
            },
          ),
          16.horizontalSpace,
          Expanded(
            child: AudioSeekBar(
              audioPlayer: _toeicP1AudioService.player,
            ),
          ),
          10.horizontalSpace,
        ],
      ),
    );
  }

  Widget _buildStepsContent(List<ToeicP1QandA> quizs) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.r, 0, 30.r, 30.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.primary,
              width: 1.5.r,
            ),
            borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildAudioController(),
            Text(
              quizs.isEmpty ? '' : quizs[_selectedIndex].mp3URL,
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            SizedBox(height: 20.r),
            Text(
              quizs.isEmpty ? '' : quizs[_selectedIndex].pngURL,
              style: AppTypography.body,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _isFirstStep(_selectedIndex)
                        ? null
                        : () => _onItemSelected(_selectedIndex - 1),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 24.r,
                      color: _isFirstStep(_selectedIndex)
                          ? AppColor.textSecondary
                          : AppColor.primary,
                    ),
                  ),
                  Text(
                    '${_selectedIndex + 1}',
                    style: AppTypography.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _isLastStep(_selectedIndex, quizs)
                        ? null
                        : () => _onItemSelected(_selectedIndex + 1),
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      size: 24.r,
                      color: _isLastStep(_selectedIndex, quizs)
                          ? AppColor.textSecondary
                          : AppColor.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
