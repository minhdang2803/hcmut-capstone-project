import 'package:flutter/material.dart';

class InstructionScreenLV1 extends StatelessWidget {
  static const String routeName = 'InstructionScreenLV1';
  static MaterialPage page({String? text, void Function(void)? callAPi}) {
    return MaterialPage(
      child: InstructionScreenLV1(
        text: text,
        callAPI: callAPi,
      ),
      key: const ValueKey(routeName),
      name: routeName,
    );
  }

  const InstructionScreenLV1({super.key, this.text, this.callAPI});
  final String? text;
  final void Function(void)? callAPI;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text ?? 'CLM'),
      ),
    );
  }
}
