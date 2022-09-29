import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';
import '../../widgets/cvn_app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: Stack(
        children: [
          _buildBody(context),
          const CVNAppBar(label: 'About Us'),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 63.r + topPadding,
        ),
        child: Column(
          children: const [
            Text('Đang làm, không được hối'),
          ],
        ));
  }
}