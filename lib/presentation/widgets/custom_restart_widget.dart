import 'package:flutter/material.dart';

class CVNRestartWidget extends StatefulWidget {
  const CVNRestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_CVNRestartWidgetState>()?.restartApp();
  }

  @override
  State<CVNRestartWidget> createState() => _CVNRestartWidgetState();
}

class _CVNRestartWidgetState extends State<CVNRestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
