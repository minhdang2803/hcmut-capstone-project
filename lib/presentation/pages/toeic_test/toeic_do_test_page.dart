import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/toeics.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/widget_util.dart';

class ToeicDoTestPageParam {
  final BuildContext context;
  final int part;
  final String title;
  final bool isReal;
  ToeicDoTestPageParam({
    required this.isReal,
    required this.context,
    required this.part,
    required this.title,
  });
}

class ToeicDoTestPage extends StatefulWidget {
  const ToeicDoTestPage({
    super.key,
    required this.part,
    required this.title,
    required this.isReal,
  });
  final int part;
  final String title;
  final bool isReal;
  @override
  State<ToeicDoTestPage> createState() => _ToeicDoTestPageState();
}

class _ToeicDoTestPageState extends State<ToeicDoTestPage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AudioService _audio;

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _audio = AudioService();
    _audio.player.isPlaying.listen((event) {
      if (event) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButton(
              onPressed: () {
                context.read<ToeicCubitPartOne>().stopCountDown(_audio);
                WidgetUtil.showDialog(
                  context: context,
                  title: 'Thoát khỏi màn chơi',
                  message: 'Quá trình sẽ bị huỷ bỏ!',
                  onAccepted: () {
                    context.read<ToeicCubitPartOne>().exit();
                    Navigator.pop(context);
                  },
                  onDismissed: () =>
                      context.read<ToeicCubitPartOne>().resumeCountDown(_audio),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: AppTypography.subHeadline
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 35.r)
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: ListView(
                children: [
                  10.verticalSpace,
                  _getPart(widget.part, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getPart(int part, ToeicStatePartOne state) {
    Widget widgetReturn;
    switch (part) {
      case 1:
        widgetReturn = ToeicPartOneComponent(
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 2:
        widgetReturn = ToeicPartTwoComponent(
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 5:
        widgetReturn = ToeicPartFiveComponent(
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 3:
        widgetReturn = ToeicPartThreeComponent(
          part: 3,
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 4:
        widgetReturn = ToeicPartThreeComponent(
          part: 4,
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 6:
        widgetReturn = ToeicPartSixComponent(
          part: 6,
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      case 7:
        widgetReturn = ToeicPartSixComponent(
          part: 6,
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
      default:
        widgetReturn = ToeicPartTwoComponent(
          audioService: _audio,
          animationController: _animationController,
          isReal: widget.isReal,
        );
        break;
    }
    return widgetReturn;
  }
}
