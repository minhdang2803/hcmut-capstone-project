import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';

class ToeicPage extends StatelessWidget {
  const ToeicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            Navigator.of(context).pushReplacementNamed(RouteName.startToeic)
          },
          child: Container(
            width: 200.r,
            height: 100.r,
            color: Colors.red,
            child: const Text("abcd"),
          ),
        )
      ],
    );
  }
}
