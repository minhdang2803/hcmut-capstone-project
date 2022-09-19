import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'WelcomeScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: WelcomeScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: Svg('assets/authentication/welcome_screen.svg', size: size),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),
                  _buildHuman(context, size),
                  _buildOption(context, size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHuman(BuildContext context, Size size) {
    return Container(
      color: Colors.transparent,
      height: size.height * 0.45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: size.width * 0.01),
          Image(
            image: Svg('assets/authentication/6.svg',
                size: Size(size.width, size.height)),
          ),
          Image(
            image: Svg('assets/authentication/3.svg',
                size: Size(size.width, size.height)),
          ),
          SizedBox(width: size.width * 0.01),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      height: size.height * 0.36,
      width: size.width * 0.9,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Login or Sign Up',
              style: Theme.of(context).textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              'Login or create an account to learn English, take part in challenges.',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).hintColor,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.025),
            buildThemeButton(
              context,
              elevation: 0.0,
              height: MediaQuery.of(context).size.height * 0.05,
              color: Theme.of(context).primaryColor,
              widget: Text(
                'Login',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).backgroundColor,
                    ),
              ),
              function: () => context.pushNamed(LoginScreen.routeName),
            ),
            SizedBox(height: size.height * 0.015),
            buildThemeButton(
              context,
              elevation: 0,
              height: MediaQuery.of(context).size.height * 0.05,
              color: Theme.of(context).secondaryHeaderColor,
              widget: Text(
                'Create an account',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              function: () => context.pushNamed(RegisterScreen.routeName),
            ),
            SizedBox(height: size.height * 0.015),
            buildThemeButton(
              context,
              elevation: 0,
              height: MediaQuery.of(context).size.height * 0.05,
              color: Theme.of(context).backgroundColor,
              widget: Text(
                'Later',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              function: () => context.goNamed('root'),
            )
          ],
        ),
      ),
    );
  }
}
