import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColor.appBackground,
      body: Stack(
        children: [
          _buildBody(context),
          const BkEAppBar(label: 'About Us'),
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
