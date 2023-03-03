import 'package:flutter/material.dart';

class ToeicInstructionParam {
  final int part;
  final String title;
  final BuildContext context;
  ToeicInstructionParam({
    required this.part,
    required this.title,
    required this.context,
  });
}

class ToeicInstructionPage extends StatelessWidget {
  const ToeicInstructionPage({
    super.key,
    required this.part,
    required this.title,
  });
  final int part;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Center(
            child: Text("Hello"),
          )),
    );
  }
}
