import 'package:bke/presentation/pages/my_dictionary/my_dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/cvn_app_bar.dart';
import '../book/books_screen.dart';
import '../chat/chat.dart';
import '../game_quiz/main/gamequiz_page.dart';
import '../main/components/monastery_search_delegate.dart';
import '../toeic_test/main/toeictest_page.dart';
import '../video/video_page.dart';
import 'navigation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late int _pageIndex;
  late final List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pageController = PageController(initialPage: _pageIndex);
    _pages = [
      NavigationPage(onPageSelected: _onPageSelected),
      const VideoPage(),
      const BookPage(),
      const MyDictionaryPage(),
      const ToeicPage(),
      const GameQuizPage(),
      // const ChatPage(),
    ];
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top:  topPadding),
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
        _buildAppBar()
      ],
    );
  }

  String _getAppBarTitle() {
    var title = '';
    switch (_pageIndex) {
      case 0:
        title = 'Nhà';
        break;
      case 1:
        title = 'Video';
        break;
      case 2:
        title = 'Thư viện';
        break;
      case 3:
        title = 'Từ vựng';
        break;
      case 4:
        title = 'TOEIC';
        break;
      case 5:
        title = 'GAME';
        break;
      case 6:
        title = 'CHAT';
        break;
    }
    return title;
  }

  Widget _buildAppBar() {
    return Builder(
      builder: (ctx) => CVNAppBar(
        label: _getAppBarTitle(),
        leading: _pageIndex == 0 ? const SizedBox() : null,
        showNotificationAction: false,
        onBackButtonPress: () => _onPageSelected(0),
        onSearchButtonPress: _pageIndex == 0
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
}
