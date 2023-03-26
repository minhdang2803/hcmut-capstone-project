import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_color.dart';
import 'components/auth_content_card.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabIndex = ModalRoute.of(context)?.settings.arguments as int?;
    return Scaffold(
      backgroundColor: AppColor.primary,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        SvgPicture.asset(
          'assets/authentication/welcome_screen.svg',
          width: 1.sw,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Center(
                child: AuthContentCard(initialTabIndex: tabIndex ?? 0),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
