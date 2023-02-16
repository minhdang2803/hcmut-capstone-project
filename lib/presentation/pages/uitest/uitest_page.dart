import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_map/map_cubit.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import 'component/map_container.dart';
import 'component/map_object.dart';

class UITestPage extends StatefulWidget {
  const UITestPage({Key? key}) : super(key: key);

  @override
  State<UITestPage> createState() => _UITestPageState();
}

class _UITestPageState extends State<UITestPage> {
  double getScreenSize() {
    String getDoubleRoundedToTwo(double size) {
      return size.toStringAsFixed(2);
    }

    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double screenSize = double.parse(getDoubleRoundedToTwo(height / width));
    double sixteenPerNine = double.parse(getDoubleRoundedToTwo(16 / 9));
    double seventeenPerNine = double.parse(getDoubleRoundedToTwo(17 / 9));
    double eighteenPerNine = double.parse(getDoubleRoundedToTwo(18 / 9));
    double nineteenPerNine = double.parse(getDoubleRoundedToTwo(19 / 9));

    if (screenSize >= nineteenPerNine) {
      return 2.5;
    } else if (screenSize >= eighteenPerNine) {
      return 2.7;
    } else if (screenSize >= seventeenPerNine) {
      return 2.9;
    } else if (screenSize >= sixteenPerNine) {
      return 3.0;
    } else {
      return 2.5;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().getMapObject();
    // _originObjects = [
    //   // line 2
    //   MapObject(
    //     id: '1',
    //     offset: const Offset(-0.12, 0.97),
    //     size: Size(25.r, 25.r),
    //   ),
    //   MapObject(
    //     id: '2',
    //     offset: const Offset(0.5, 0.93),
    //     size: Size(25.r, 25.r),
    //     isDone: false,
    //   ),
    //   MapObject(
    //     id: '3',
    //     offset: const Offset(0.13, 0.86),
    //     size: Size(25.r, 25.r),
    //     isDone: false,
    //   ),
    //   MapObject(
    //     id: '4',
    //     offset: const Offset(0.25, 0.78),
    //     size: Size(25.r, 25.r),
    //     isDone: false,
    //   ),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Trò chơi giải đố",
                style: AppTypography.subHeadline
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 35.r)
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        // padding: EdgeInsets.only(top: 10.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          // borderRadius: BorderRadius.only(
          //   topRight: Radius.circular(20.r),
          //   topLeft: Radius.circular(20.r),
          // ),
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
                  }
                  return MapContainer(
                    initZoomLevel: getScreenSize(),
                    assetImage: 'assets/images/mapQuiz.jpg',
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    backgroundColor: const Color(0xFFC0C0C0),
                    objects: state.listMapObject!,
                    onItemClick: (mapObj) {
                      if (mapObj.isDone) {
                        context
                            .read<QuizCubit>()
                            .getLevel(int.parse(mapObj.id));
                        Navigator.pushNamed(context, RouteName.quizScreen,
                            arguments: context);
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
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
