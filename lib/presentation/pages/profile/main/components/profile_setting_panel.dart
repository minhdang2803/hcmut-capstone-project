import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/configs/hive_config.dart';
import '../../../../../utils/widget_util.dart';
import '../../../../routes/route_name.dart';

import '../../../../theme/app_color.dart';
import '../../../../theme/app_typography.dart';
import '../widgets/profile_setting_item.dart';

class ProfileSettingPanel extends StatelessWidget {
  const ProfileSettingPanel({Key? key}) : super(key: key);

  void _showConfirmDialog(BuildContext context) async {
    WidgetUtil.showDialog(
      context: context,
      title: 'Logout',
      message: 'Do you want to logout? See you again',
      onAccepted: () => _doLogOut(context),
    );
  }

  void _doLogOut(BuildContext context) async {
    final userBox = Hive.box(HiveConfig.userBox);
    userBox.clear();
    await const FlutterSecureStorage()
        .delete(key: HiveConfig.currentUserTokenKey)
        .then(
          (_) => Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.welcome,
            (Route<dynamic> route) => false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.r),
            child: Container(
              width: 300.r,
              height: 300.r,
              padding: EdgeInsets.symmetric(vertical: 20.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColor.primary),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ProfileSettingItem(
                            asset: 'assets/icons/ic_setting.svg',
                            label: 'Cài đặt',
                            onPress: () {
                              WidgetUtil.showDialog(
                                context: context,
                                title: 'Coming soon',
                                message: 'Feature is being updated',
                              );
                            },
                          ),
                          SizedBox(height: 20.r),
                          ProfileSettingItem(
                            asset: 'assets/icons/ic_quiz.svg',
                            label: 'Từ vựng yêu thích',
                            onPress: () => Navigator.of(context)
                                .pushNamed(RouteName.myDictionary),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const ProfileSettingItem(
                            asset: 'assets/icons/ic_user.svg',
                            label: 'User',
                            iconColor: AppColor.secondary,
                            // onPress: () => Navigator.of(context)
                            //     .pushNamed(RouteName.updateProfile),
                          ),
                          SizedBox(height: 20.r),
                          ProfileSettingItem(
                            asset: 'assets/icons/contact.svg',
                            label: "Contact us",
                            onPress: () async {
                              String url = 'myenglisk.vercel.app';
                              if (await canLaunchUrl(
                                  Uri.https(url, "/contact"))) {
                                // Launch the url in the Chrome browser
                                await launchUrl(Uri.https(url, "/contact"),
                                    mode: LaunchMode.externalApplication,
                                    webViewConfiguration:
                                        const WebViewConfiguration());
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ProfileSettingItem(
                            asset: 'assets/icons/ic_info.svg',
                            label: 'About us',
                            onPress: () async {
                              String url = 'myenglisk.vercel.app';
                              if (await canLaunchUrl(Uri.https(url))) {
                                // Launch the url in the Chrome browser
                                await launchUrl(
                                  Uri.https(url),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmDialog(context),
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng xuất',
              style: AppTypography.title.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 24.r,
              color: AppColor.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
