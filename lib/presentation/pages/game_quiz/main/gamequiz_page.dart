import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';

class GameQuizPage extends StatelessWidget {
  const GameQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              BkEAppBar(
                label: "Giải câu đố",
                onBackButtonPress: () => Navigator.pop(context),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context)
                      .pushReplacementNamed(RouteName.startQuiz)
                },
                child: Container(
                  width: 200.r,
                  height: 100.r,
                  color: Colors.red,
                  child: const Text("abcd"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
