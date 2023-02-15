import 'package:bke/presentation/pages/uitest/quiz_screen.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'component/map_container.dart';
import 'component/map_object.dart';

class UITestPage extends StatefulWidget {
  const UITestPage({Key? key}) : super(key: key);

  @override
  State<UITestPage> createState() => _UITestPageState();
}

class _UITestPageState extends State<UITestPage> {
  late final List<MapObject> _originObjects;

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
    _originObjects = [
      // line 2
      MapObject(
        id: '1',
        offset: const Offset(0.36, 0.68),
        size: Size(25.r, 25.r),
      ),
      MapObject(
        id: '1',
        offset: const Offset(-0.12, 0.53),
        size: Size(25.r, 25.r),
        isDone: false,
      ),
    ];
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
              return MapContainer(
                initZoomLevel: getScreenSize(),
                assetImage: 'assets/images/mapQuiz.jpg',
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                backgroundColor: const Color(0xFFC0C0C0),
                objects: _originObjects,
                onItemClick: (mapObj) {
                  if (mapObj.isDone) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
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
            },
          ),
        ),
      ),
    );
  }
}
