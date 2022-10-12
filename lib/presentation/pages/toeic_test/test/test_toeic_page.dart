import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../bloc/toeic/toeic_cubit.dart';
import '../../../../data/models/toeic/toeic_part1/toeic_part1_qna.dart';
import '../../../../data/services/audio_service.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/audio_seek_bar.dart';
import '../../../widgets/play_pause_button.dart';
import '../../../widgets/rounded_elevated_button.dart';
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
  int _finalScore = 0;
  final _scrollController = ScrollController();
  final _indicatorScrollController = AutoScrollController();

  final List<String> _isClickedBtn = ['', '', ''];
  final List<bool> _isChosen = [false, false, false];

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

  void _calculateScore(List<ToeicP1QandA> quiz) {
    for (int i = 0; i < _isClickedBtn.length; i++) {
      if (_isClickedBtn[i] == quiz[i].answer) {
        _finalScore += 10;
      }
    }
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

  void _onSubmitClick(List<ToeicP1QandA> quizs) {
    _toeicP1AudioService.stop();
    var listQid = quizs.map((e) => e.qid).toList();
    context.read<ToeicCubit>().saveScoreToeicP1(listQid, _isClickedBtn);
    _calculateScore(quizs);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentUser = BlocProvider.of<AuthCubit>(context).getCurrentUser();
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          // add appbar here
        ],
      ),
    );
  }

  Widget _buildBody() {
    final topPadding = MediaQuery.of(context).padding.top;
    final quizs =
        ModalRoute.of(context)?.settings.arguments as List<ToeicP1QandA>;

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
          _buildButtonSubmit(quizs)
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
              step: index + 1,
              isSolved: _isChosen[index],
              isSelected: index == _selectedIndex,
              isLastItem: _isLastStep(index, quizs),
              onItemClick: () => _onItemSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioController(String audioUrl, int index) {
    _toeicP1AudioService.setAudio(audioUrl);
    return Container(
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
            controller: _animationController,
            onItemClick: () {
              if (_isChosen[index] == false) _toeicP1AudioService.play();
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
      padding: EdgeInsets.symmetric(horizontal: 30.r),
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
            _buildAudioController(quizs[_selectedIndex].mp3URL, _selectedIndex),
            SizedBox(height: 20.r),
            CachedNetworkImage(
              imageUrl: quizs[_selectedIndex].imgURL,
              fadeInDuration: const Duration(milliseconds: 350),
              fit: BoxFit.cover,
              errorWidget: (ctx, url, error) => Image.asset(
                'assets/images/error_profile_image_holder.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.r),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAnswerButton("A", _selectedIndex),
                _buildAnswerButton("B", _selectedIndex),
                _buildAnswerButton("C", _selectedIndex),
                _buildAnswerButton("D", _selectedIndex),
              ],
            ),
            Row(
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSubmit(List<ToeicP1QandA> quizs) {
    return BlocConsumer<ToeicCubit, ToeicState>(
      listener: (context, state) {
        if (state is SaveScoreToeicP1Success) {
          Navigator.of(context).pushReplacementNamed(
            RouteName.resultToeic,
            arguments: _finalScore,
          );
        } else if (state is SaveScoreToeicP1Failure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is ToeicLoading) {
          return SizedBox(
            height: 44.h,
            child: FittedBox(
              child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: const CircularProgressIndicator()),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: RoundedElevatedButton(
              backgroundColor: AppColor.primary,
              label: 'Submit',
              width: 150.w,
              height: 44.h,
              radius: 22.r,
              onPressed: () => _onSubmitClick(quizs),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isChosen[index] = true;
          _isClickedBtn[index] = text;
        });
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        )),
        textStyle: MaterialStateProperty.all(AppTypography.body),
        elevation: MaterialStateProperty.all<double>(10.0.r),
        backgroundColor: _isClickedBtn[index] == text
            ? MaterialStateProperty.all<Color>(AppColor.primary)
            : MaterialStateProperty.all<Color>(AppColor.onPrimary),
        shadowColor: MaterialStateProperty.all<Color>(AppColor.secondary),
      ),
      child: Text(text),
    );
  }
}
