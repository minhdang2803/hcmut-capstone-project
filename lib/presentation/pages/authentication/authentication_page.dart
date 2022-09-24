import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';
import 'components/auth_content_card.dart';
import 'widgets/auth_background.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabIndex = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        const AuthBackground(),
        ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: (30.h)),
              child: Center(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 0.5.sw,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Center(
              child: AuthContentCard(initialTabIndex: tabIndex ?? 0),
            )
          ],
        ),
      ]),
    );
  }
}
