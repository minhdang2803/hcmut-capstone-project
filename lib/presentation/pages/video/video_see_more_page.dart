import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/presentation/pages/video/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../bloc/video/category_video/category_video_cubit.dart';
import '../../../utils/constants.dart';
import '../../../utils/enum.dart';
import '../../routes/route_name.dart';
import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/video_youtube_item.dart';

class VideoSeeMorePageModel {
  final BuildContext context;
  final String category;
  final SeeMoreVideoAction? action;
  VideoSeeMorePageModel({
    required this.category,
    this.action,
    required this.context,
  });
}

class VideoSeeMorePage extends StatefulWidget {
  const VideoSeeMorePage(
      {Key? key, required this.action, required this.category})
      : super(key: key);
  final String category;
  final SeeMoreVideoAction? action;

  @override
  State<VideoSeeMorePage> createState() => _VideoSeeMorePageState();
}

class _VideoSeeMorePageState extends State<VideoSeeMorePage>
    with SingleTickerProviderStateMixin {
  var _currentPageKey = 1;
  final PagingController<int, VideoYoutubeInfo> _pagingController =
      PagingController(firstPageKey: 1);

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();

  late final Animation<double> _animationEaseIn = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animationEaseOut = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _currentPageKey = pageKey;
      if (widget.action != SeeMoreVideoAction.recently) {
        _getCategory(widget.category);
      } else {
        _getRecently();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  void _getRecently() {
    try {
      final newItems = context.read<CategoryVideoCubit>().state.videos;
      _pagingController.appendLastPage(newItems!);
    } on RemoteException catch (error) {}
  }

  Future<void> _getCategory(String category) async {
    try {
      final newItems = await context.read<CategoryVideoCubit>().getVideo(
            category: category,
            pageKey: _currentPageKey,
            pageSize: Constants.defaultPageSize,
          );
      final isLastPage = newItems.length < Constants.defaultPageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _currentPageKey++;
        _pagingController.appendPage(newItems, _currentPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  String _getAppBarLabel() {
    switch (widget.action) {
      case SeeMoreVideoAction.category1:
        return 'Video Ted Talk';
      case SeeMoreVideoAction.category2:
        return 'Video Ted Ed';
      case SeeMoreVideoAction.category3:
        return 'Video Ted In A Nutshell';
      default:
        return "Recently videos";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: _getAppBarLabel(),
              showNotificationAction: true,
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () {
            _pagingController.refresh();
          },
        ),
        child: FadeTransition(
          opacity: _animationEaseIn,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
              ),
              color: AppColor.primary,
            ),
            child: PagedListView<int, VideoYoutubeInfo>(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16.r, bottom: 30.r),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<VideoYoutubeInfo>(
                firstPageProgressIndicatorBuilder: (context) =>
                    _buildLoadingSkeleton(),
                itemBuilder: (context, item, index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RouteName.videoPlayer,
                      arguments:
                          VideoPlayerPageModel(context: context, video: item),
                    );
                  },
                  child: VideoYoutubeItem(
                    videoYoutubeInfo: item,
                    onItemClick: () {
                      Navigator.of(context).pushNamed(
                        RouteName.videoPlayer,
                        arguments:
                            VideoPlayerPageModel(context: context, video: item),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return FadeTransition(
      opacity: _animationEaseOut,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30.r),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, index) => Row(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.rectangle,
                  width: 100.r,
                  height: 70.r,
                ),
              ),
              SizedBox(width: 15.r),
              Flex(
                direction: Axis.vertical,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 15.r,
                          borderRadius: BorderRadius.circular(8),
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                      SizedBox(height: 4.r),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          randomLength: true,
                          height: 15.r,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 6,
                          maxLength: MediaQuery.of(context).size.width / 3,
                        ),
                      ),
                      SizedBox(height: 12.r),
                      Row(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              randomLength: true,
                              height: 20.r,
                              borderRadius: BorderRadius.circular(8),
                              minLength: 40.r,
                              maxLength: 70.r,
                            ),
                          ),
                          10.horizontalSpace,
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              randomLength: true,
                              height: 20.r,
                              borderRadius: BorderRadius.circular(8),
                              minLength: 60.r,
                              maxLength: 90.r,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10.r);
          },
        ),
      ),
    );
  }
}
