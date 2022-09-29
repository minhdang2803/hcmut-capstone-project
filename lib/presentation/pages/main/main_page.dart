import 'package:bke/presentation/pages/game_quiz/main/gamequiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/cvn_app_bar.dart';
import '../home/home_page.dart';
import '../profile/main/profile_page.dart';
import 'components/monastery_search_delegate.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const GameQuizPage(),
    const HomePage(),
    const ProfilePage(),
  ];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageSelected(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  String _getAppBarTitle() {
    var title = '';
    switch (_pageIndex) {
      case 0:
        title = 'HOME';
        break;
      case 1:
        title = 'QUIZ GAME';
        break;
      case 2:
        title = 'TOEIC';
        break;
      case 3:
        title = 'USER';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 63.r + topPadding),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _pages,
              ),
            ),
          ),
          _buildAppBar(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Builder(
      builder: (ctx) => CVNAppBar(
        label: _getAppBarTitle(),
        leading: _pageIndex == 0 ? const SizedBox() : null,
        showNotificationAction: false,
        onBackButtonPress: () => _onPageSelected(0),
        onSearchButtonPress: _pageIndex != 1
            ? null
            : () {
                showSearch(
                  context: context,
                  delegate: MonasterySearchDelegate(),
                );
              },
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _pageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: _onPageSelected,
      unselectedItemColor: AppColor.textPrimary,
      selectedItemColor: AppColor.textPrimary,
      selectedLabelStyle: AppTypography.bodySmall,
      unselectedLabelStyle: AppTypography.bodySmall,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_home.svg',
              color: AppColor.inactiveIconColor,
              width: 24.r,
              height: 24.r,
            ),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_home.svg',
              color: AppColor.primary,
              width: 24.r,
              height: 24.r,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_quiz.svg',
              color: AppColor.inactiveIconColor,
              width: 24.r,
              height: 24.r,
            ),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_quiz.svg',
              color: AppColor.primary,
              width: 24.r,
              height: 24.r,
            ),
          ),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_toeic.svg',
              color: AppColor.inactiveIconColor,
              width: 24.r,
              height: 24.r,
            ),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_toeic.svg',
              color: AppColor.primary,
              width: 24.r,
              height: 24.r,
            ),
          ),
          label: 'Toeic',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_user.svg',
              color: AppColor.inactiveIconColor,
              width: 24.r,
              height: 24.r,
            ),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 4.r),
            child: SvgPicture.asset(
              'assets/icons/ic_user.svg',
              color: AppColor.primary,
              width: 24.r,
              height: 24.r,
            ),
          ),
          label: 'User',
        ),
      ],
    );
  }
}
