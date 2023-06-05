import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/presentation/widgets/play_pause_button.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/vocab/vocab_cubit.dart';

class VocabFullInfoPage extends StatefulWidget {
  const VocabFullInfoPage({super.key, required this.vocabInfo});
  final LocalVocabInfo vocabInfo;

  @override
  State<VocabFullInfoPage> createState() => _VocabFullInfoPageState();
}

class _VocabFullInfoPageState extends State<VocabFullInfoPage>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: widget.vocabInfo.vocab.toCapitalize(),
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildVocabInfoComponent(context)
          ],
        ),
      ),
    );
  }

  Expanded _buildVocabInfoComponent(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
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
                      text: widget.vocabInfo.pronounce.uk.toCapitalize(),
                      style: AppTypography.title,
                    ),
                  ]),
                ),
                _buildAudioController(
                  _voiceUS,
                  widget.vocabInfo.pronounce.usmp3,
                  _animationController2,
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
                      text: widget.vocabInfo.pronounce.us.toCapitalize(),
                      style: AppTypography.title,
                    ),
                  ]),
                ),
                _buildAudioController(
                  _voiceUK,
                  widget.vocabInfo.pronounce.ukmp3,
                  _animationController,
                  context,
                )
              ],
            ),
            5.verticalSpace,
            ...widget.vocabInfo.translate.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppColor.defaultBorder,
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

  String functionalWord = "Functional word";
  Widget _buildVocabTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.vocabInfo.vocab.toCapitalize(),
              style:
                  AppTypography.headline.copyWith(fontWeight: FontWeight.bold),
            ),
            10.horizontalSpace,
            Text(
              "(${widget.vocabInfo.vocabType.isNotEmpty ? widget.vocabInfo.vocabType.toCapitalize() : functionalWord})",
              style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.bold, color: AppColor.mainPink),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context
                .read<VocabCubit>()
                .deleteFromMyDictionary(widget.vocabInfo.id);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.delete,
            size: 25.r,
          ),
        )
      ],
    );
  }
}
