import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/data/data_source/local/auth_local_source.dart';
import 'package:bke/presentation/pages/book/books_screen.dart';
import 'package:bke/presentation/pages/chat/chat.dart';
import 'package:bke/presentation/pages/flashcard/flashcard_collection_page.dart';
import 'package:bke/presentation/pages/game_quiz/main/gamequiz_page.dart';
import 'package:bke/presentation/pages/home/components/continue_card.dart';
import 'package:bke/presentation/pages/home/components/join_quiz_card.dart';
import 'package:bke/presentation/pages/my_dictionary/my_dictionary.dart';
import 'package:bke/presentation/pages/toeic_test/main/toeictest_page.dart';
import 'package:bke/presentation/pages/video/video_page.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';
import '../main/components/monastery_search_delegate.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final List<Widget> _pages;
  late int _pageIndex;
  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _pages = [
      const VideoPage(),
      const BookPage(),
      const FlashcardCollectionScreen(),
      const ToeicPage(),
      const GameQuizPage(),
      const ChatPage(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> menuList = <String>[
      'video',
      'book',
      'flashcard',
      'test',
      'puzzle',
      'chat',
    ];
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/texture/hoatiet.svg',
              fit: BoxFit.contain,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUserBanner(context),
              Visibility(
                visible: true,
                child: SizedBox(
                  height: size.height * 0.12,
                  width: size.width * 0.8,
                  child:
                      ContinueCard(recentAction: RecentAction.readBook.index),
                ),
              ),
              SizedBox(
                  height: size.height * 0.25,
                  width: size.width,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 30, bottom: 30, left: 50, right: 50),
                        child: JoinQuizCard(),
                      ),
                      Image.asset(
                        'assets/images/proud.png',
                        height: size.height * 0.2,
                        width: size.height * 0.12,
                      ),
                    ],
                  )),
              _buildFeaturesList(size, context, menuList),
              SizedBox(height: size.height * 0.03),
              _buildSearchBar(context, size),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildFeaturesList(
      Size size, BuildContext context, List<String> menuList) {
    return SizedBox(
        height: size.height * 0.08,
        child: ListView.builder(
          itemBuilder: (ctx, index) => GestureDetector(
            onTap: () {
              setState(() {
                _pageIndex = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return _pages[index];
                }),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
              ),
              width: size.height * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      color: AppColor.accentBlue,
                    ),
                    Image.asset(
                      'assets/icons/${menuList[index]}.png',
                      height: size.height * 0.05,
                      width: size.height * 0.05,
                    ),
                  ],
                ),
                // Image.network(
                //   bookList[i].coverUrl,
                //   height: size.height*0.25
                // ),
              ),
            ),
          ),
          itemCount: 6,
          scrollDirection: Axis.horizontal,
        ));
  }

  Widget _buildUserBanner(BuildContext context) {
    final authLocal = GetIt.I.get<AuthLocalSourceImpl>();
    final user = authLocal.getCurrentUser();
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'buổi sáng ☀️ !';
      }
      if (hour < 17) {
        return 'buổi chiều ☀️ ! ';
      }
      return 'buổi tối 🌙 ';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào ${greeting()}!",
                style: AppTypography.title.copyWith(
                    color: AppColor.pastelPink,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.r),
              ),
              Text(
                user?.fullName ?? "clm",
                style: AppTypography.subHeadline
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          // user.photoUrl == null
          Image.asset(
            'assets/images/relaxed.png',
            width: 80.w,
            height: 80.h,
          )
          // : Image.network(
          //     user.photoUrl!,
          //     width: 80.w,
          //     height: 80.h,
          //   )
        ],
      ),
    );
  }

  Padding _buildSearchBar(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextButton(
        onPressed: () {
          showSearch(context: context, delegate: MonasterySearchDelegate());
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: size.height * 0.05,
            width: size.width * 0.95,
            color: AppColor.secondary,
            padding: EdgeInsets.symmetric(vertical: 0.8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: size.width * 0.04),
                SvgPicture.asset(
                  'assets/icons/ic_search.svg',
                  color: AppColor.lightGray,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: size.width * 0.02),
                AutoSizeText(
                  'Tra từ vựng, video, sách,...',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightGray,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
