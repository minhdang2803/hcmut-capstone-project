import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/components/toeic_part1.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToeicDoTestPageParam {
  final BuildContext context;
  final int part;
  final String title;
  ToeicDoTestPageParam({
    required this.context,
    required this.part,
    required this.title,
  });
}

class ToeicDoTestPage extends StatefulWidget {
  const ToeicDoTestPage({super.key, required this.part, required this.title});
  final int part;
  final String title;
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
    _audio.player.isPlaying.listen((isPlaying) {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
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
                context.read<ToeicCubitPartOne>().exit();
                Navigator.pop(context);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  ToeicPartOneComponent(
                    questions: state.part125!,
                    audioService: _audio,
                    animationController: _animationController,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

