import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_map/map_cubit.dart';
import 'package:bke/presentation/pages/quiz/component/map_object.dart';
import 'package:bke/presentation/pages/quiz/quizzes.dart';

import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import 'component/map_container.dart';

class QuizMapScreen extends StatefulWidget {
  const QuizMapScreen({Key? key}) : super(key: key);

  @override
  State<QuizMapScreen> createState() => _QuizMapScreenState();
}

class _QuizMapScreenState extends State<QuizMapScreen> {
  List<MapObject> _objs = [];
  double getScreenSize() {
    String getDoubleRoundedToTwo(double size) {
      return size.toStringAsFixed(2);
    }

    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double screenSize = double.parse(getDoubleRoundedToTwo(height / width));
    double nineteenPerNine = double.parse(getDoubleRoundedToTwo(19 / 9));

    if (screenSize <= nineteenPerNine) {
      return 1.75;
    } else {
      return 2.5;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().getMapObject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      appBar: AppBar(
        backgroundColor: AppColor.appBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButton(
              color: AppColor.textPrimary,
              onPressed: () {
                context.read<QuizCubit>().upsertQuizResult();
                Navigator.pop(context);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Trò chơi giải đố",
                style: AppTypography.subHeadline.copyWith(
                    color: AppColor.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 35.r)
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.r),
          // padding: EdgeInsets.only(top: 10.r),
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(20.r),
            borderRadius: BorderRadius.circular(20.r
                // topRight: Radius.circular(20.r),
                // topLeft: Radius.circular(20.r),
                ),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                return BlocBuilder<MapCubit, MapState>(
                  builder: (context, state) {
                    if (state.status == MapStatus.loading) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                      );
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        _objs.clear();
                        for (final element in state.listMapObject!) {
                          setState(() {
                            _objs.add(
                              MapObject(
                                id: element.id,
                                offset: Offset(element.dx!, element.dy!),
                                isDone: element.isDone,
                                total: element.total,
                                type: element.type,
                                size: Size(25.r, 25.r),
                              ),
                            );
                          });
                        }
                      });

                      return MapContainer(
                        initZoomLevel: getScreenSize(),
                        assetImage: 'assets/images/mapQuiz.jpg',
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        backgroundColor: AppColor.primary,
                        objects: _objs,
                        onItemClick: (mapObj) {
                          if (mapObj.isDone) {
                            context.read<QuizCubit>().setInitial();
                            context
                                .read<QuizCubit>()
                                .getLevel(int.parse(mapObj.id));
                            Navigator.pushNamed(
                              context,
                              RouteName.quizScreen,
                              arguments: QuizScreenParam(
                                  context, int.parse(mapObj.id)),
                            );
                          } else if (!mapObj.isDone) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BKEDialog(
                                  title: "Cảnh báo",
                                  message: "Bạn phải hoàn thành màn chơi trước",
                                  onDismissed: () => Navigator.pop(context),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
