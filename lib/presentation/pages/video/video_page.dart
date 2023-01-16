import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/video_youtube_info.dart';
import '../../routes/route_name.dart';
import '../../widgets/holder_widget.dart';
import 'component/video_horizontal_list.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
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

  Map<String, List<VideoYoutubeInfo>> _data = {};

  @override
  void initState() {
    super.initState();
    if (_data.isEmpty) {
      context.read<VideoCubit>().getMainActivities();
    }
  }

  Future<void> _onRefresh() {
    return context.read<VideoCubit>().getMainActivities();
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
              label: 'Video',
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
        onRefresh: _onRefresh,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
          ),
          child: ListView(
            padding: EdgeInsets.only(bottom: 30.r),
            children: [
              SizedBox(height: 20.r),
              _buildActivitiesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return BlocConsumer<VideoCubit, VideoState>(
      listener: (context, state) {
        if (state is VideoYoutubeInfoSuccess) {
          setState(() {
            _data = state.data;
          });
        }
      },
      builder: (context, state) {
        if (state is VideoYoutubeInfoFailure) {
          return HolderWidget(
            message: state.errorMessage,
            asset: 'assets/images/error_holder.png',
            onRetry: () {
              context.read<VideoCubit>().getMainActivities();
            },
          );
        }

        if (state is VideoLoading) {
          return Center(child: SizedBox(width: 0.5.sw));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_data['category1'] != null)
              VideoYoutubeHorizontalList(
                title: 'Category 1',
                data: _data['category1']!,
                onSeeMore: () {
                  const action = SeeMoreVideoAction.category1;
                  Navigator.of(context).pushNamed(
                    RouteName.videoSeeMore,
                    arguments: action,
                  );
                },
              ),
            if (_data['category2'] != null)
              VideoYoutubeHorizontalList(
                title: 'Category 2',
                data: _data['category2']!,
                onSeeMore: () {
                  const action = SeeMoreVideoAction.category1;
                  Navigator.of(context).pushNamed(
                    RouteName.videoSeeMore,
                    arguments: action,
                  );
                },
              ),
          ],
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
