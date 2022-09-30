import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/game/game_cubit.dart';
import '../../../../data/models/quiz/game.dart';
import '../../../../data/models/quiz/quiz.dart';
import '../../../routes/route_name.dart';
import '../../../widgets/rounded_elevated_button.dart';

class StartGame02 extends StatefulWidget {
  const StartGame02({Key? key}) : super(key: key);

  @override
  State<StartGame02> createState() => _StartComponent();
}

class _StartComponent extends State<StartGame02> {
  List<Quiz>? quizs;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    context.read<GameCubit>().getGame();
  }

  void _onStartClick() {
    if (quizs != null) {
      Navigator.of(context)
          .pushReplacementNamed(RouteName.game, arguments: quizs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40.r),
        child: _buildStartButton(),
      ),
    );
  }

  Widget _buildStartButton() {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameSuccess) {
          final game = state.props.first as Game;
          quizs = game.quizs;
        } else if (state is GameFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        return RoundedElevatedButton(
          backgroundColor: Colors.orange.shade400,
          label: 'Start',
          width: 125.w,
          height: 44.h,
          radius: 22.r,
          onPressed: _onStartClick,
        );
      },
    );
  }
}
