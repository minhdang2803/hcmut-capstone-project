import 'package:bke/presentation/pages/calendar/calendar_page.dart';
import 'package:bke/presentation/pages/home/navigation_page.dart';
import 'package:bke/presentation/routes/route_name.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../lookup/lookup.dart';
import '../profile/main/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const NavigationPage(),
    const LookUpPage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  void _onPageSelected(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.appBackground,
      body: _buildMainScreen(topPadding),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloattingButton(context),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: BottomAppBar(
        color: AppColor.primary,
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColor.primary,
            currentIndex: _pageIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: _onPageSelected,
            unselectedItemColor: AppColor.textSecondary,
            selectedItemColor: AppColor.textPrimary,
            selectedLabelStyle: AppTypography.bodySmall,
            unselectedLabelStyle: AppTypography.bodySmall,
            elevation: 2,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_home.svg',
                    color: AppColor.inactiveIconColor,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_home.svg',
                    color: AppColor.secondary,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                label: 'Trang chính',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_search.svg',
                    color: AppColor.inactiveIconColor,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_search.svg',
                    color: AppColor.secondary,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                label: 'Tra từ',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic-leaderboard.svg',
                    color: AppColor.inactiveIconColor,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic-leaderboard.svg',
                    color: AppColor.secondary,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                label: 'Thống kê',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_user.svg',
                    color: AppColor.inactiveIconColor,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: SvgPicture.asset(
                    'assets/icons/ic_user.svg',
                    color: AppColor.secondary,
                    width: 20.r,
                    height: 20.r,
                  ),
                ),
                label: 'Tài khoản',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen(double topPadding) {
    return Container(
      padding: _pageIndex != 3 ? EdgeInsets.only(top: topPadding) : null,
      child: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
    );
  }

  Widget _buildFloattingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteName.chatPage);
      },
      backgroundColor: AppColor.secondary,
      elevation: 2,
      isExtended: false,
      child: Icon(
        Icons.chat,
        color: AppColor.primary,
        size: 20.r,
      ),
    );
  }
}
