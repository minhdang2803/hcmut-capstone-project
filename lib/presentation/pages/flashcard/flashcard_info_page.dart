import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_typography.dart';

class FlashcardInfoScreen extends StatefulWidget {
  const FlashcardInfoScreen({super.key, required this.vocab});
  final LocalVocabInfo vocab;

  @override
  State<FlashcardInfoScreen> createState() => _FlashcardInfoScreenState();
}

class _FlashcardInfoScreenState extends State<FlashcardInfoScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _animationController2;
  late final AudioService _voiceUK;
  late final AudioService _voiceUS;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _voiceUK = AudioService();
    _voiceUK.player.isPlaying.listen((isPlaying) {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
    _voiceUS = AudioService();
    _voiceUS.player.isPlaying.listen((isPlaying) {
      isPlaying
          ? _animationController2.forward()
          : _animationController2.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: widget.vocab.vocab.toCapitalize(),
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildVocabInfoComponent(context)
          ],
        ),
      ),
    );
  }

  Widget _buildVocabInfoComponent(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVocabTitle(context),
            10.verticalSpace,
            _buildVocabContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabContent(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.minPositive,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            width: 2,
            color: AppColor.defaultBorder,
          ),
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "- UK: ",
                        style: AppTypography.title.copyWith(
                            color: AppColor.mainPink,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: widget.vocab.pronounce.uk.toCapitalize(),
                      style: AppTypography.title,
                    ),
                  ]),
                ),
                _buildAudioController(
                  _voiceUK,
                  widget.vocab.pronounce.ukmp3,
                  _animationController,
                  context,
                )
              ],
            ),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "- US: ",
                        style: AppTypography.title.copyWith(
                            color: AppColor.mainPink,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: widget.vocab.pronounce.us.toCapitalize(),
                      style: AppTypography.title,
                    ),
                  ]),
                ),
                _buildAudioController(
                  _voiceUS,
                  widget.vocab.pronounce.usmp3,
                  _animationController2,
                  context,
                )
              ],
            ),
            10.verticalSpace,
            ...widget.vocab.translate.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppColor.mainPink,
                    thickness: 2,
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- English: ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.mainPink,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.en.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                  5.verticalSpace,
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- Tiếng Việt: ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.mainPink,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.vi.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                  5.verticalSpace,
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- Example(ví dụ): ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.mainPink,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.example.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  Widget _buildVocabTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.vocab.vocab.toCapitalize(),
              style: AppTypography.headline,
            ),
            10.horizontalSpace,
            Text(
              "(${widget.vocab.vocabType.isEmpty ? "Function word" : widget.vocab.vocabType})",
              style:
                  AppTypography.subHeadline.copyWith(color: AppColor.mainPink),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAudioController(
    AudioService audio,
    String audioUrl,
    AnimationController controller,
    BuildContext context,
  ) {
    audio.setAudioInternet(audioUrl);

    return PlayPauseButton(
      controller: controller,
      onItemClick: () {
        if (!audio.player.isPlaying.value) {
          audio.play();
        } else {
          audio.stop();
        }
      },
    );
  }

  bool get wantKeepAlive => false;
}
