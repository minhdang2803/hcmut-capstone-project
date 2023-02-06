import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../bloc/video/video_cubit.dart';
import '../../../data/models/video/video_youtube_info_model.dart';
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
              // context.read<VideoCubit>().getMainActivities();
            },
          );
        }

        if (state is VideoLoading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColor.primary,
            )),
          );
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
}
