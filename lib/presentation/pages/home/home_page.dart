import 'package:flutter/material.dart';

import 'navigation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    return const NavigationPage();
  }

  // String _getAppBarTitle() {
  //   var title = '';
  //   switch (_pageIndex) {
  //     case 0:
  //       title = 'Nhà';
  //       break;
  //     case 1:
  //       title = 'Video';
  //       break;
  //     case 2:
  //       title = 'Thư viện';
  //       break;
  //     case 3:
  //       title = 'Từ vựng';
  //       break;
  //     case 4:
  //       title = 'TOEIC';
  //       break;
  //     case 5:
  //       title = 'GAME';
  //       break;
  //     case 6:
  //       title = 'CHAT';
  //       break;
  //   }
  //   return title;
  // }

  // Widget _buildAppBar() {
  //   return Builder(
  //     builder: (ctx) => BkEAppBar(
  //       label: _getAppBarTitle(),
  //       leading: _pageIndex == 0 ? const SizedBox() : null,
  //       showNotificationAction: false,
  //       onBackButtonPress: () => Navigator.pop(context),
  //       onSearchButtonPress: _pageIndex == 0
  //           ? null
  //           : () {
  //               showSearch(
  //                 context: context,
  //                 delegate: MonasterySearchDelegate(),
  //               );
  //             },
  //     ),
  //   );
  // }
}
