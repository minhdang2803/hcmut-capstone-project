import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/news/news_event.dart';
import 'package:bke/data/data_source/local/auth_local_source.dart';
import 'package:bke/data/models/search/search_model.dart';
import 'package:bke/presentation/pages/home/components/continue_card.dart';
import 'package:bke/presentation/pages/home/components/join_quiz_card.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../../bloc/news/news_bloc.dart';
import '../../../bloc/news/news_state.dart';
import '../../../bloc/recent_action/action_bloc.dart';
import '../../../bloc/recent_action/action_event.dart';
import '../../../bloc/recent_action/action_state.dart';
import '../../../data/models/news/news_model.dart';
import '../../theme/app_color.dart';
import '../main/components/monastery_search_delegate.dart';
import '../news/bottom_news_content.dart';
import '../toeic_test/toeic_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final List<String> _pages;
  late final ActionBloc _actionBloc;
  late final NewsListBloc _newsListBloc;
  @override
  void initState() {
    super.initState();
    _pages = [
      RouteName.videoPage,
      RouteName.bookPage,
      RouteName.flashCardCollectionScreen,
      RouteName.startToeic,
      RouteName.quizMapScreen,
      RouteName.chatPage
    ];
    _actionBloc = ActionBloc();
    _actionBloc.add(const GetRecentActionsEvent());

    _newsListBloc = NewsListBloc();
    _newsListBloc.add(LoadTopHeadlinesEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onReadNews(NewsInfo news) {
    // pause video
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.primary,
      builder: (context) => BottomNewsContent(news: news),
    );
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
        backgroundColor: AppColor.appBackground,
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                _buildUserBanner(context),
                BlocProvider(
                    create: (context) => _actionBloc,
                    child: BlocBuilder<ActionBloc, ActionState>(
                        builder: (context, state) {
                      if (state is ActionLoadedState) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: state.book != null,
                                child: ContinueCard(
                                    recentAction: RecentAction.readBook,
                                    item: state.book),
                              ),
                              Visibility(
                                visible: state.video != null,
                                child: ContinueCard(
                                    recentAction: RecentAction.watchVideo,
                                    item: state.video),
                              ),
                            ]);
                      }
                      return SizedBox(height: 0.02.sh);
                    })),
                SizedBox(
                    height: size.height * 0.25,
                    width: size.width,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 50, right: 50),
                          child: JoinQuizCard(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteName.startToeic,
                              );
                            },
                          ),
                        ),
                        Image.asset(
                          'assets/images/proud.png',
                          height: size.height * 0.2,
                          width: size.height * 0.12,
                        ),
                      ],
                    )),
                _buildSearchBar(context, size),
                SizedBox(height: 0.02.sh),
                Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          // topRight: Radius.circular(40),
                        ),
                      ),
                      
                      child: Column(children: [
                        _buildFeaturesList(size, context, menuList),
                        30.verticalSpace,
                        const TextDivider(text: 'Tin tức nổi bật'),
                        SingleChildScrollView(child: _buildNewsTopHeadlines(context)),
                      ]),
                      
                    
                  
                )
              ],
            ),
          ),
        ]));
  }

  Widget _buildNewsTopHeadlines(BuildContext context) {
    return BlocProvider(
    create: (context) => _newsListBloc,
    child: BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        print(state);
        if (state is NewsListLoadedState) {
          final newsList = state.newsList;
          return Container(
            padding: EdgeInsets.only(left: 10.w),
            height: 350.h,
            width: 300.w,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  _onReadNews(newsList[i]);
                },
                child: SizedBox(
                  height: 60.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50.h,
                        width: 80.w,
                        color: AppColor.primary,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/default_logo.png',
                          placeholderFit: BoxFit.contain,
                          image: newsList[i].urlToImage!=''?newsList[i].urlToImage:'assets/images/default_logo.png',
                          fadeInDuration: const Duration(milliseconds: 400),
                          fit: BoxFit.fill,
                          // placeholderFit: BoxFit.fill,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/default_logo.png',
                          ),
                        ),
                      ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 190.w,
                        child: AutoSizeText(
                            newsList[i].title,
                            style: AppTypography.body.copyWith(
                              fontSize: 11.r,
                              fontWeight: FontWeight.w800,
                              color: AppColor.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              itemCount: newsList.length,
              scrollDirection: Axis.vertical,
            ),
          );
        }
        return SizedBox(height: 1);
      },
    ),
  );
  }

  SizedBox _buildFeaturesList(
      Size size, BuildContext context, List<String> menuList) {
    final List<String> featureList = <String>[
      "Video",
      "Sách",
      "Từ vựng",
      "TOEIC",
      "Giải đố",
      "Trò chuyện"
    ];
    return SizedBox(
        height: size.height * 0.08,
        child: ListView.builder(
          itemBuilder: (ctx, index) => GestureDetector(
            onTap: () {
              setState(() {});
              Navigator.pushNamed(context, _pages[index]);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  width: size.height * 0.08,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        // Container(
                        //   color: AppColor.accentBlue,
                        // ),
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
                AutoSizeText(
                  featureList[index],
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColor.textPrimary,
                  ),
                  maxLines: 2,
                ),
              ],
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
      if (hour > 5 && hour < 12) {
        return 'buổi sáng ☀️';
      }
      if (hour >= 12 && hour < 18) {
        return 'buổi chiều ☀️';
      }
      return 'buổi tối 🌙';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chào ${greeting()}",
                style: AppTypography.title.copyWith(
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.r),
              ),
              Text(
                user?.fullName ?? "User",
                style: AppTypography.subHeadline.copyWith(
                    color: AppColor.textPrimary, fontWeight: FontWeight.w700),
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
          showSearch(
            context: context,
            delegate: MonasterySearchDelegate(
                searchType: SearchType.all, buildContext: context),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            height: size.height * 0.05,
            width: size.width * 0.95,
            color: AppColor.darkGray,
            padding: EdgeInsets.symmetric(vertical: 0.8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: size.width * 0.04),
                SvgPicture.asset(
                  'assets/icons/ic_search.svg',
                  color: AppColor.textSecondary,
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: size.width * 0.02),
                AutoSizeText(
                  'Tra từ vựng, video, sách,...',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
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
