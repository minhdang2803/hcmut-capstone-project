import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cvn_app_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  late final Map<String, dynamic> _aboutUsMap;

  @override
  void initState() {
    super.initState();
    _initialData();
  }

  void _initialData() async {
    final data = await rootBundle.loadString('assets/raw/about_us.json');
    _aboutUsMap = json.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.tertiary,
      body: Stack(
        children: [
          _buildBody(context),
          const CVNAppBar(
            label: 'Về chúng tôi',
            hasBackButton: true,
            hasTrailing: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final title = _aboutUsMap['title'] as String?;
    final target = _aboutUsMap['target'] as String?;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 63.r + topPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                foregroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3B3B3B),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 0.7],
                  ),
                ),
                child: Image.asset(
                  'assets/images/about_us.png',
                  width: 1.sw,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 5.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VỀ CHÚNG TÔI",
                      style: AppTypography.headline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.onPrimary),
                    ),
                    Text(
                      "CHÙA VIỆT NAM",
                      style: AppTypography.superHeadline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            color: const Color(0xFF3B3B3B),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 5.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 3.r,
                    width: 40.r,
                    color: AppColor.onPrimary,
                  ),
                  10.verticalSpace,
                  Text(
                    title ?? '',
                    style: AppTypography.body.copyWith(
                      color: AppColor.onPrimary,
                    ),
                  ),
                  10.verticalSpace,
                ],
              ),
            ),
          ),
          Container(
            color: AppColor.secondary,
            width: 1.sw,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.r),
                child: Text(
                  "chua viet nam chua viet namchua ",
                  style: AppTypography.body.copyWith(
                    color: AppColor.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.r),
              child: Text(
                "MỤC TIÊU HOẠT ĐỘNG",
                style: AppTypography.title.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.r),
            child: Text(
              target ?? '',
              style: AppTypography.body.copyWith(
                color: AppColor.textPrimary,
              ),
            ),
          ),
          10.verticalSpace,
          Container(
            color: AppColor.secondary,
            width: 1.sw,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.r),
                child: Text(
                  "LIÊN HỆ VỚI CHÚNG TÔI",
                  style: AppTypography.title.copyWith(
                    color: AppColor.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          2.verticalSpace,
          Container(
            color: AppColor.secondary,
            width: 1.sw,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildInfoRowItem(
                      'assets/icons/ic_about_us_location.svg',
                      "chua vn chua vn chua vn chua vn chua vn chua vn chua vn chua vn ",
                    ),
                    _buildInfoRowItem(
                      'assets/icons/ic_about_us_phone.svg',
                      "0123.456.789",
                    ),
                    _buildInfoRowItem(
                      'assets/icons/ic_about_us_mail.svg',
                      "abc@gmail.com",
                    ),
                    _buildInfoRowItem(
                      'assets/icons/ic_about_us_time.svg',
                      "8h - 18h từ thứ hai đến thứ bảy",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowItem(String iconUrl, String data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.r,
            width: 30.r,
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconUrl,
                fit: BoxFit.contain,
                color: AppColor.onPrimary,
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              data,
              style: AppTypography.title.copyWith(
                color: AppColor.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
