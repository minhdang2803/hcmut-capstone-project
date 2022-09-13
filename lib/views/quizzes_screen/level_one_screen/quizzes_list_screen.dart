import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:capstone_project_hcmut/views/quizzes_screen/level_one_screen/level_one_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LevelOneScreen extends StatefulWidget {
  const LevelOneScreen({Key? key}) : super(key: key);
  static const String routeName = 'LevelOneScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: LevelOneScreen(),
      name: routeName,
      key: ValueKey(routeName),
    );
  }

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  late int lengthList;
  late List<Map<String, Object?>> listNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int getNumber() {
      int maxLenght = listNumber.length;
      double x1 = (maxLenght) / 5;
      double x2 = (maxLenght - 3) / 5;
      int valueFinal = x1.ceil() + x2.ceil();
      return valueFinal;
    }

    listNumber = [
      {'text': 'Hello', 'api_call': null},
      {'text': 'Hello', 'api_call': null},
      {'text': 'Hello', 'api_call': null},
      {'text': 'Hello', 'api_call': null},
      {'text': 'Hello', 'api_call': null},
      {'text': 'Hello', 'api_call': null},
    ];
    lengthList = listNumber.length;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Level one',
          style: Theme.of(context).textTheme.headline2?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.2),
              //Line Paint
              _buildStoryMap(size, getNumber),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildStoryMap(Size size, int Function() getNumber) {
    return SizedBox(
      height: (size.height * 0.14) * (getNumber() - 1),
      width: size.width,
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: DashedPathPainter(
            originalPath: pathCustom(size, getNumber(), lengthList),
            dashGapLength: 8,
            strokeWidth: 5,
            dashLength: 15,
            pathColor: kHawkBlueColor),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -size.height * 0.05,
              right: 0,
              left: 0,
              child: Column(children: [
                ...List.generate(
                  getNumber(),
                  (indexColumn) => Padding(
                    padding: EdgeInsets.only(
                        left: size.height * 0.02,
                        right: size.height * 0.02,
                        bottom: size.height * 0.04),
                    child: indexColumn % 2 == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              3,
                              (indexRow) {
                                int numberStepTwo = indexColumn ~/ 2;
                                int numberStepThree =
                                    (3 * indexColumn + indexRow);
                                bool checkLength =
                                    numberStepThree - numberStepTwo <
                                        listNumber.length;
                                if (checkLength) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const InstructionScreenLV1(),
                                        )),
                                    child: AbsorbPointer(
                                      child: TextShapeCircle(
                                          color: Theme.of(context).primaryColor,
                                          text: (numberStepThree -
                                                  numberStepTwo +
                                                  1)
                                              .toString()),
                                    ),
                                  );
                                } else {
                                  return IgnorePointer(child: Container());
                                }
                              },
                            ),
                          )
                        : Stack(alignment: Alignment.center, children: [
                            const IgnorePointer(child: SizedBox()),
                            ...List.generate(
                              2,
                              (indexRow) {
                                int numberStepTwo = indexColumn ~/ 2;
                                int numberStepThree =
                                    (3 * indexColumn + indexRow);
                                bool checkLength =
                                    numberStepThree - numberStepTwo <
                                        listNumber.length;
                                if (checkLength) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const InstructionScreenLV1(),
                                        )),
                                    child: Align(
                                      alignment: Alignment(
                                          indexRow == 0 ? 0.55 : -0.55, 0),
                                      child: TextShapeCircle(
                                          color: Theme.of(context).primaryColor,
                                          text: (numberStepThree -
                                                  numberStepTwo +
                                                  1)
                                              .toString()),
                                    ),
                                  );
                                } else {
                                  return IgnorePointer(child: Container());
                                }
                              },
                            ),
                            const IgnorePointer(child: SizedBox()),
                          ]),
                  ),
                ),
                IgnorePointer(child: Container())
              ]),
            )
          ],
        ),
      ),
    );
  }

  Path pathCustom(Size size, int lengthRow, int lengthList) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.2, 0);
    path0.lineTo(size.width * 0.2, 0);
    path0.lineTo(size.width * 0.8, 0);
    //line 1

    for (int i = 0;
        i < (lengthRow % 2 == 0 ? (lengthRow / 2) : (lengthRow ~/ 2));
        i++) {
      path0.moveTo(size.width * 0.8, size.height * 0.28 * i);
      path0.quadraticBezierTo(size.width * 0.8, size.height * 0.28 * i,
          size.width * 0.8, size.height * 0.28 * i);
      path0.cubicTo(
          size.width,
          size.height * 0.28 * i,
          size.width,
          size.height * 0.14 * (i + i + 1),
          size.width * 0.8,
          size.height * 0.14 * (i + i + 1));
      path0.quadraticBezierTo(
          size.width * 0.8,
          size.height * 0.14 * (i + i + 1),
          size.width * 0.8,
          size.height * 0.14 * (i + i + 1));

      //fix line following lengthList
      if (lengthRow % 2 == 0) {
        if (i ==
            (lengthRow % 2 == 0 ? (lengthRow / 2) : (lengthRow ~/ 2)) - 1) {
          int valueMaxLine = 5 * (lengthRow ~/ 2);
          if (valueMaxLine == lengthList) {
            path0.quadraticBezierTo(
                size.width * 0.8,
                size.height * 0.14 * (i + i + 1),
                size.width * 0.2,
                size.height * 0.14 * (i + i + 1));
          } else {
            path0.quadraticBezierTo(
                size.width * 0.8,
                size.height * 0.14 * (i + i + 1),
                size.width * 0.65,
                size.height * 0.14 * (i + i + 1));
          }
        } else {
          path0.quadraticBezierTo(
              size.width * 0.8,
              size.height * 0.14 * (i + i + 1),
              size.width * 0.2,
              size.height * 0.14 * (i + i + 1));
        }
      } else {
        path0.quadraticBezierTo(
            size.width * 0.8,
            size.height * 0.14 * (i + i + 1),
            size.width * 0.2,
            size.height * 0.14 * (i + i + 1));
      }
    }
    for (int i = 0;
        i <
            (lengthRow % 2 == 0
                ? (lengthRow / 2 - 1)
                : (lengthRow / 2).ceil() - 1);
        i++) {
      path0.moveTo(size.width * 0.2, size.height * 0.14 * (i + i + 1));
      path0.quadraticBezierTo(
          size.width * 0.2,
          size.height * 0.14 * (i + i + 1),
          size.width * 0.2,
          size.height * 0.14 * (i + i + 1));
      path0.cubicTo(
          0,
          size.height * 0.14 * (i + i + 1),
          0,
          size.height * 0.28 * (i + 1),
          size.width * 0.2,
          size.height * 0.28 * (i + 1));
      path0.quadraticBezierTo(size.width * 0.2, size.height * 0.28 * (i + 1),
          size.width * 0.3, size.height * 0.28 * (i + 1));

      //fix line following lengthList
      if (lengthRow % 2 == 1) {
        if (i ==
            (lengthRow % 2 == 0
                    ? (lengthRow / 2 - 1)
                    : (lengthRow / 2).ceil() - 1) -
                1) {
          int valueMaxLine = 5 * (lengthRow ~/ 2);
          if (valueMaxLine + 1 == lengthList) {
            path0.quadraticBezierTo(
                size.width * 0.2,
                size.height * 0.28 * (i + 1),
                size.width * 0.2,
                size.height * 0.28 * (i + 1));
          } else if (valueMaxLine + 2 == lengthList) {
            path0.quadraticBezierTo(
                size.width * 0.2,
                size.height * 0.28 * (i + 1),
                size.width * 0.5,
                size.height * 0.28 * (i + 1));
          } else if (valueMaxLine + 3 == lengthList) {
            path0.quadraticBezierTo(
                size.width * 0.2,
                size.height * 0.28 * (i + 1),
                size.width * 0.8,
                size.height * 0.28 * (i + 1));
          }
        } else {
          path0.quadraticBezierTo(
              size.width * 0.2,
              size.height * 0.28 * (i + 1),
              size.width * 0.8,
              size.height * 0.28 * (i + 1));
        }
      } else {
        path0.quadraticBezierTo(size.width * 0.2, size.height * 0.28 * (i + 1),
            size.width * 0.8, size.height * 0.28 * (i + 1));
      }
    }

    return path0;
  }
}
