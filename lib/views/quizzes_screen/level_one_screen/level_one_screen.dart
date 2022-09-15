import 'package:capstone_project_hcmut/components/components.dart';
import 'package:capstone_project_hcmut/models/models.dart';
import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';


class InstructionScreen extends StatefulWidget {
  static const String routeName = 'InstructionScreen';
  static MaterialPage page({String? text, void Function()? callAPi}) {
    return MaterialPage(
      child: InstructionScreen(
        text: text,
        callAPI: callAPi,
      ),
      key: const ValueKey(routeName),
      name: routeName,
    );
  }

  const InstructionScreen({super.key, this.text, this.callAPI});
  final String? text;
  final void Function()? callAPI;

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: Svg('assets/splash_screen/splash_screen.svg', size: size),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                _buildTopBar(context, size),
                SizedBox(height: size.height * 0.02),
                _buildStartContent(context, size),
                SizedBox(height: size.height * 0.02),
                _buildButton(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Size size) {
    return buildAuthTopBar(
      context,
      size,
      color: Colors.white,
      title: 'Introduction',
      function: () => Navigator.pop(context),
    );
  }

  Widget _buildButton(BuildContext context, Size size) {
    return buildThemeButton(
      context,
      widget: Text(
        'Start quiz',
        style: Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color: kPrimaryColor),
      ),
      elevation: 0,
      borderRadius: 30,
      width: size.width * 0.9,
      height: size.height * 0.07,
      color: Theme.of(context).backgroundColor,
      function: () {},
    );
  }

  Widget _buildStartContent(BuildContext context, Size size) {
    return IntroContentComponent(
      size: size,
      model: IntroModel(
          level: 'Level 1',
          content:
              'Any time is a good time for a quiz and even better if that happens to be a football themed quiz! You are about to answer 10 multiple choices questions, each of them will cost 10 points.',
          points: '100',
          questions: '10'),
    );
  }
}
