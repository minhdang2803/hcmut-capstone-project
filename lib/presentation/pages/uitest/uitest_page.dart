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
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return MapContainer(
          initZoomLevel: 1,
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
                  color: Colors.red,
                );
              },
            );
          },
        );
      },
    );
  }
}
