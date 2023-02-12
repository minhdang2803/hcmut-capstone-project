import 'package:bke/presentation/theme/app_typography.dart';
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize();
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          return MapContainer(
            initZoomLevel: getScreenSize(),
            assetImage: 'assets/images/mapQuiz.jpg',
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            backgroundColor: const Color(0xFFC0C0C0),
            objects: _originObjects,
            onItemClick: (mapObj) {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Container(
                    width: 20.r,
                    height: 30.r,
                    child: Text(mapObj.id),
                    color: Colors.white,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
