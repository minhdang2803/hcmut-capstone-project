import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../data/configs/hive_config.dart';
import '../../../../routes/route_name.dart';
import '../../../../theme/app_color.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/cvn_restart_widget.dart';
import '../widgets/profile_setting_item.dart';

class ProfileSettingPanel extends StatelessWidget {
  const ProfileSettingPanel({Key? key}) : super(key: key);

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận bạn muốn thoát'),
        content: const Text('Bạn có chắc muốn thoát tài khoản này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  void _doLogOut(BuildContext context) async {
    final userBox = Hive.box(HiveConfig.userBox);
    userBox.clear();
    await const FlutterSecureStorage()
        .delete(key: HiveConfig.currentUserTokenKey)
        .then((_) => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(
                    RouteName.authentication,
                    (Route<dynamic> route) => false,
                  )
                  .then((value) => CVNRestartWidget.restartApp(context))
            });
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ProfileSettingItem(
                          asset:
                              'assets/icons/profile_settings/ic_thiet_lap.svg',
                          label: 'Thiết lập',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_hoi_nhom.svg',
                          label: 'Hội nhóm',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_lop_hoc.svg',
                          label: 'Lớp học',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_cau_an.svg',
                          label: 'Cầu an',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_thong_tin.svg',
                          label: 'Thông tin',
                          onPress: () {
                            Navigator.of(context).pushNamed(RouteName.updateProfile);
                          },
                        ),
                        // const ProfileSettingItem(
                        //   asset:
                        //   'assets/icons/profile_settings/ic_hoat_dong.svg',
                        //   label: 'Hoạt động',
                        // ),
                        // const ProfileSettingItem(
                        //   asset:
                        //   'assets/icons/profile_settings/ic_chua_mac_dinh.svg',
                        //   label: 'Chùa mặc định',
                        // ),
                        // const ProfileSettingItem(
                        //   asset:
                        //   'assets/icons/profile_settings/ic_chua_yeu_thich.svg',
                        //   label: 'Chùa yêu thích',
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_huong_dan.svg',
                          label: 'Hướng dẫn',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_khoa_tu.svg',
                          label: 'Khóa tu',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_phap_bao.svg',
                          label: 'Pháp bảo',
                        ),
                        ProfileSettingItem(
                          asset:
                          'assets/icons/profile_settings/ic_cau_sieu.svg',
                          label: 'Cầu siêu',
                        ),
                      ],
                    ),
                  ),
                ],
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
      onTap: () async {
        if (await _showConfirmDialog(context)) {
          _doLogOut(context);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Thoát tài khoản',
                  style: AppTypography.body
                      .copyWith(color: AppColor.textSecondary),
                ),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 24.r,
                ),
              ],
            ),
          ),
    );
  }
}
