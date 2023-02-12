import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_view_port.dart';
import 'map_object.dart';

class MapContainer extends StatefulWidget {
  const MapContainer({
    Key? key,
    required this.initZoomLevel,
    required this.assetImage,
    required this.objects,
    required this.width,
    required this.height,
    this.backgroundColor,
    this.onMapDoubleTap,
    this.onItemClick,
    this.doubleTapToZoomIn = true,
    this.maxZoomLevel = 6,
    this.minZoomLevel = 3,
    this.zoomScaleLevel = 2,
  }) : super(key: key);

  final double initZoomLevel;
  final String assetImage;
  final List<MapObject> objects;
  final double width;
  final double height;
  final Color? backgroundColor;
  final VoidCallback? onMapDoubleTap;
  final Function(MapObject)? onItemClick;
  final bool doubleTapToZoomIn;
  final double maxZoomLevel;
  final double minZoomLevel;
  final double zoomScaleLevel;

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  late double _zoomLevel;
  late String _assetImage;
  late List<MapObject> _objects;

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.initZoomLevel;
    _assetImage = widget.assetImage;
    _objects = widget.objects;
  }

  @override
  void didUpdateWidget(MapContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.assetImage != _assetImage) {
      _assetImage = widget.assetImage;
    }
  }

  void onMapDoubleTap() {
    if (widget.doubleTapToZoomIn) {
      if (_zoomLevel >= widget.maxZoomLevel) return;
      setState(() {
        _zoomLevel = _zoomLevel * widget.zoomScaleLevel;
      });
    }
    if (widget.onMapDoubleTap != null) {
      widget.onMapDoubleTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          color: widget.backgroundColor ?? Colors.black26,
          child: ImageViewPort(
            zoomLevel: _zoomLevel,
            assetImage: _assetImage,
            objects: _objects,
            onMapDoubleTap: onMapDoubleTap,
            onItemClick: (mapObj) {
              if (widget.onItemClick != null) {
                widget.onItemClick!(mapObj);
              }
            },
          ),
        ),
        // 5.verticalSpace,
        // _buildZoomButtons(),
      ],
    );
  }

  Widget _buildZoomButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.green,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.remove,
              size: 24,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (_zoomLevel <= widget.minZoomLevel) return;
            setState(() {
              _zoomLevel = _zoomLevel / widget.zoomScaleLevel;
            });
          },
        ),
        IconButton(
          icon: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.green,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              size: 24,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            if (_zoomLevel >= widget.maxZoomLevel) return;
            setState(() {
              _zoomLevel = _zoomLevel * widget.zoomScaleLevel;
            });
          },
        ),
      ],
    );
  }
}
