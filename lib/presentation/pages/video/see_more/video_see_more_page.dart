import 'package:bke/data/models/video/video_youtube_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../bloc/video/video_cubit.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/enum.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/custom_app_bar.dart';
import '../widgets/video_youtube_item.dart';

class VideoSeeMorePage extends StatefulWidget {
  const VideoSeeMorePage({Key? key, required this.action}) : super(key: key);

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
      switch (widget.action) {
        case SeeMoreVideoAction.category1:
          _getCategory1();
          break;
        case SeeMoreVideoAction.category2:
          _getCategory2();
          break;

        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  Future<void> _getCategory1() async {
    try {
      final newItems = await context.read<VideoCubit>().getCategory1(
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

  Future<void> _getCategory2() async {
    try {
      final newItems = await context.read<VideoCubit>().getCategory2(
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
        return 'Video ted-ed';
      case SeeMoreVideoAction.category2:
        return 'Video ted...';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
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
              color: Colors.white,
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
                      arguments: item,
                    );
                  },
                  child: VideoYoutubeItem(
                    videoYoutubeInfo: item,
                    onItemClick: () {
                      Navigator.of(context)
                          .pushNamed(RouteName.videoPlayer, arguments: item);
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

  Widget _buildSubYoutubeData(VideoYoutubeInfo item) {
    return Expanded(
      child: Column(
        children: [
          Text(
            item.title,
            style:
                AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          10.verticalSpace,
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(078),
                    color: AppColor.primary),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.r, vertical: 3.r),
                  child: Text(
                    'Basic',
                    style:
                        AppTypography.bodySmall.copyWith(color: Colors.white),
                  ),
                ),
              ),
              5.horizontalSpace,
              Text('${item.viewCount} views', style: AppTypography.bodySmall),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return FadeTransition(
      opacity: _animationEaseOut,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30.r),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, index) => Row(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                    shape: BoxShape.rectangle, width: 100.r, height: 70.r),
              ),
              SizedBox(width: 15.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 15.r,
                        borderRadius: BorderRadius.circular(8),
                        width: double.infinity,
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
