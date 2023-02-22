import 'package:bke/bloc/video/category_video/category_video_cubit.dart';
import 'package:bke/presentation/pages/video/see_more/video_see_more_page.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/utils/enum.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<CategoryVideoCubit>().getMainActivities();
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
              onBackButtonPress: () {
                context.read<CategoryVideoCubit>().exit();
                Navigator.pop(context);
              },
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
        onRefresh: () => context.read<CategoryVideoCubit>().getMainActivities(),
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
    return BlocBuilder<CategoryVideoCubit, CategoryVideoState>(
      builder: (context, state) {
        if (state.status == CategoryVideoStatus.fail) {
          return HolderWidget(
            message: state.errorMessage,
            asset: 'assets/images/error_holder.png',
            onRetry: () {
              context.read<CategoryVideoCubit>().getMainActivities();
            },
          );
        }
        if (state.status == CategoryVideoStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColor.primary,
            )),
          );
        }

        return FadeTransition(
          opacity: _animationEaseIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: state.videos!.isNotEmpty,
                child: VideoYoutubeHorizontalList(
                  data: state.videos!,
                  title: "Tiếp tục xem",
                  onSeeMore: () {
                    var action = SeeMoreVideoAction.recently;
                    Navigator.of(context).pushNamed(
                      RouteName.videoSeeMore,
                      arguments: VideoSeeMorePageModel(
                        category: "Recently videos",
                        action: action,
                      ),
                    );
                  },
                ),
              ),
              ...state.data!.values.map((e) {
                return VideoYoutubeHorizontalList(
                    title: e.first.category.toCapitalizeEachWord(),
                    data: e,
                    onSeeMore: () {
                      var action = e.first.category.contains("talk")
                          ? SeeMoreVideoAction.category1
                          : e.first.category.contains("ed")
                              ? SeeMoreVideoAction.category2
                              : SeeMoreVideoAction.category3;
                      Navigator.of(context).pushNamed(
                        RouteName.videoSeeMore,
                        arguments: VideoSeeMorePageModel(
                          category: e.first.category,
                          action: action,
                        ),
                      );
                    });
              }).toList()
            ],
          ),
        );
      },
    );
  }
}
