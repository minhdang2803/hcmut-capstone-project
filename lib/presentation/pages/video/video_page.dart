import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';

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
    with AutomaticKeepAliveClientMixin {
  var _currentPageKey = 1;
  final PagingController<int, VideoYoutubeInfo> _pagingController =
      PagingController(firstPageKey: 1);

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
    super.build(context);
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
          return Center(
            child: Lottie.asset(
              'assets/lotties/loading.json',
              fit: BoxFit.contain,
              width: 0.5.sw,
            ),
          );
        }

        if (state is VideoYoutubeInfoFailure) {
          return Center(
            child: SizedBox(
              width: 1.sw,
              child: HolderWidget(
                asset: 'assets/images/default_logo.png',
                onRetry: () => {
                  context
                      .read<VideoCubit>()
                      .getYoutubeVideoList(pageKey: _currentPageKey)
                },
              ),
            ),
          );
        }

        return PagedListView<int, VideoYoutubeInfo>(
          pagingController: _pagingController,
          padding: EdgeInsets.symmetric(vertical: 10.r),
          builderDelegate: PagedChildBuilderDelegate<VideoYoutubeInfo>(
            itemBuilder: (ctx, item, index) => VideoYoutubeItem(
              videoYoutubeInfo: item,
              onItemClick: () {
                final argument = item.videoId;
                Navigator.of(context)
                    .pushNamed(RouteName.videoPlayer, arguments: argument);
              },
            ),
            noItemsFoundIndicatorBuilder: (context) {
              return const HolderWidget(
                asset: 'assets/images/default_logo.png',
                message: 'Fail to load',
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
