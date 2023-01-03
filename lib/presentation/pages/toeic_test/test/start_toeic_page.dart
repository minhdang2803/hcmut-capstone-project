import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/toeic/toeic_cubit.dart';
import '../../../../data/models/toeic/toeic_part1/toeic_part1_qna.dart';
import '../../../../data/models/toeic/toeic_test.dart';
import '../../../routes/route_name.dart';
import '../../../widgets/rounded_elevated_button.dart';

class StartToeic extends StatefulWidget {
  const StartToeic({Key? key}) : super(key: key);

  @override
  State<StartToeic> createState() => _StartToeic();
}

class _StartToeic extends State<StartToeic> {
  List<ToeicP1QandA>? toeicP1QandA;
  @override
  void initState() {
    super.initState();
    context.read<ToeicCubit>().getToeicP1QandA();
  }

  void _onStartClick() {
    if (toeicP1QandA != null) {
      Navigator.of(context)
          .pushReplacementNamed(RouteName.testToeic, arguments: toeicP1QandA);
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
    return BlocConsumer<ToeicCubit, ToeicState>(
      listener: (context, state) {
        if (state is ToeicSuccess) {
          final toeicTest = state.props.first as ToeicTest;
          toeicP1QandA = toeicTest.tests;
        } else if (state is ToeicFailure) {
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
