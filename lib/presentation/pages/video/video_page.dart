import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/video_youtube_info.dart';
import '../../../utils/constants.dart';
import '../../routes/route_name.dart';
import '../../widgets/holder_widget.dart';
import 'widgets/video_youtube_item.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
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
      context.read<VideoCubit>().getYoutubeVideoList(pageKey: pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCubit, VideoState>(
      listener: (context, state) {
        if (state is VideoYoutubeInfoSuccess) {
          try {
            final newItems = state.data;
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
      },
      builder: (context, state) {
        if (state is VideoLoading && _pagingController.itemList == null) {
          return _buildLoadingSkeleton();
        }

        if (state is VideoYoutubeInfoFailure) {
          return Center(
            child: SizedBox(
              width: 1.sw,
              child: HolderWidget(
                asset: 'assets/images/error.png',
                onRetry: () => {
                  context
                      .read<VideoCubit>()
                      .getYoutubeVideoList(pageKey: _currentPageKey)
                },
              ),
            ),
          );
        }

        return FadeTransition(
          opacity: _animationEaseIn,
          child: PagedListView<int, VideoYoutubeInfo>(
            pagingController: _pagingController,
            addAutomaticKeepAlives: true,
            padding: EdgeInsets.symmetric(vertical: 5.r),
            builderDelegate: PagedChildBuilderDelegate<VideoYoutubeInfo>(
              itemBuilder: (ctx, item, index) => VideoYoutubeItem(
                videoYoutubeInfo: item,
                onItemClick: () {
                  Navigator.of(context)
                      .pushNamed(RouteName.videoPlayer, arguments: item);
                },
              ),
              noItemsFoundIndicatorBuilder: (context) {
                return const HolderWidget(
                  asset: 'assets/images/default_logo.png',
                  message: 'Fail to load',
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return FadeTransition(
      opacity: _animationEaseOut,
      child: Padding(
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
