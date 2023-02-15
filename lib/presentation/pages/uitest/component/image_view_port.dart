import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'map_object.dart';
import 'map_painter.dart';

class ImageViewPort extends StatefulWidget {
  const ImageViewPort({
    Key? key,
    required this.zoomLevel,
    required this.assetImage,
    required this.objects,
    this.onMapDoubleTap,
    this.onItemClick,
  }) : super(key: key);

  final double zoomLevel;
  final String assetImage;
  final List<MapObject> objects;
  final VoidCallback? onMapDoubleTap;
  final Function(MapObject)? onItemClick;

  @override
  State<ImageViewPort> createState() => _ImageViewPortState();
}

class _ImageViewPortState extends State<ImageViewPort> {
  late double _zoomLevel;
  late String _assetImage;
  ui.Image? _image;
  late bool _resolved;
  late Offset _centerOffset;
  double _maxHorizontalDelta = 0.0;
  double _maxVerticalDelta = 0.0;
  late Offset _normalized;
  bool _denormalize = false;
  Size _actualImageSize = const Size(0.0, 0.0);
  late Size _viewportSize;

  late List<MapObject> _objects;

  double _abs(double value) {
    return value < 0 ? value * (-1) : value;
  }

  StreamSubscription? _streamSubscription;

  void _updateActualImageDimensions() {
    if (_image != null) {
      _actualImageSize = Size(
        (_image!.width / ui.window.devicePixelRatio) * _zoomLevel,
        (_image!.height / ui.window.devicePixelRatio) * _zoomLevel,
      );
    }
  }

  void _resolveImageProvider() async {
    ByteData bd = await rootBundle.load(_assetImage);
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    _image = image;
    _resolved = true;
    _updateActualImageDimensions();
    setState(() {});
    //
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImageProvider();
  }

  @override
  void didUpdateWidget(ImageViewPort oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.assetImage != _assetImage) {
      _assetImage = widget.assetImage;
      _resolveImageProvider();
    }
    double normalizedDx =
        _maxHorizontalDelta == 0 ? 0 : _centerOffset.dx / _maxHorizontalDelta;
    double normalizedDy =
        _maxVerticalDelta == 0 ? 0 : _centerOffset.dy / _maxVerticalDelta;
    _normalized = Offset(normalizedDx, normalizedDy);
    _denormalize = true;
    _zoomLevel = widget.zoomLevel;
    _updateActualImageDimensions();
  }

  Offset _globalToLocalOffset(Offset value) {
    double hDelta = (_actualImageSize.width / 2) * value.dx;
    double vDelta = (_actualImageSize.height / 2) * value.dy;
    double dx = (hDelta - _centerOffset.dx) + (_viewportSize.width / 2);
    double dy = (vDelta - _centerOffset.dy) + (_viewportSize.height / 2);
    return Offset(dx, dy);
  }

  /////////////////////
  void _handlePanUpdate(DragUpdateDetails updateDetails) {
    //Translate (0, -updateDetails.delta.dy) để không drag ngang được
    ///Translate (-updateDetails.delta.dx, -updateDetails.delta.dy) để drag ngang dọc
    Offset newOffset = _centerOffset.translate(0, -updateDetails.delta.dy);
    if (_abs(newOffset.dx) <= _maxHorizontalDelta &&
        _abs(newOffset.dy) <= _maxVerticalDelta) {
      setState(() {
        _centerOffset = newOffset;
      });
    }
  }

  List<Widget> _buildObjects() {
    return _objects.map((object) {
      return Positioned(
        left: _globalToLocalOffset(object.offset).dx -
            (object.size == null ? 0 : (object.size!.width * _zoomLevel) / 2),
        top: _globalToLocalOffset(object.offset).dy -
            (object.size == null ? 0 : (object.size!.height * _zoomLevel) / 2),
        child: GestureDetector(
          onTap: () {
            if (widget.onItemClick != null) {
              widget.onItemClick!(object);
            }
          },
          child: Container(
            width: object.size == null ? null : object.size!.width * _zoomLevel,
            height:
                object.size == null ? null : object.size!.height * _zoomLevel,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              image: DecorationImage(
                image: object.isDone
                    ? const AssetImage(
                        "assets/images/game1.png",
                      )
                    : const AssetImage("assets/images/game_lock.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.zoomLevel;
    _assetImage = widget.assetImage;
    _resolved = false;
    _centerOffset = const Offset(0, 0);
    _objects = widget.objects;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!_resolved)
        ? const SizedBox()
        : LayoutBuilder(
            builder: (ctx, constraints) {
              _viewportSize = Size(
                min(constraints.maxWidth, _actualImageSize.width),
                min(constraints.maxHeight, _actualImageSize.height),
              );
              _maxHorizontalDelta =
                  (_actualImageSize.width - _viewportSize.width) / 2;
              _maxVerticalDelta =
                  (_actualImageSize.height - _viewportSize.height) / 2;
              bool reactOnHorizontalDrag =
                  _maxHorizontalDelta > _maxVerticalDelta;
              bool reactOnPan =
                  (_maxHorizontalDelta > 0 && _maxVerticalDelta > 0);
              if (_denormalize) {
                _centerOffset = Offset(_maxHorizontalDelta * _normalized.dx,
                    _maxVerticalDelta * _normalized.dy);
                _denormalize = false;
              }

              //
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: reactOnPan ? _handlePanUpdate : null,
                onHorizontalDragUpdate: reactOnHorizontalDrag && !reactOnPan
                    ? _handlePanUpdate
                    : null,
                onVerticalDragUpdate: !reactOnHorizontalDrag && !reactOnPan
                    ? _handlePanUpdate
                    : null,
                onDoubleTap: widget.onMapDoubleTap,
                child: Stack(
                  children: [
                    if (_image != null)
                      CustomPaint(
                        size: _viewportSize,
                        painter: MapPainter(
                          image: _image!,
                          zoomLevel: _zoomLevel,
                          centerOffset: _centerOffset,
                        ),
                      ),
                    ..._buildObjects(),
                  ],
                ),
              );
            },
          );
  }
}
