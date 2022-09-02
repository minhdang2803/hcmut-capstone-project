// ignore_for_file: prefer_final_fields, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../view_models/theme_viewmodel.dart';
import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:go_router/go_router.dart';
import '../models/onboard_data.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);
  static String routeName = 'OnboardScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: const OnboardScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentPage = 0;

  PageController _pageController = PageController(initialPage: 0);

  bool seenOnboard = false;

  // Future setSeenonboard() async {
  //   final prefs = SharedPreferencesWrapper.instance;
  //   seenOnboard = await prefs.setBool('seenOnboard', true);
  //   // this will set seenOnboard to true when running onboard page for first time.
  // }

  @override
  void initState() {
    super.initState();
    // setSeenonboard();
  }

  @override
  Widget build(BuildContext context) {
    // initialize size config
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
            child: Column(children: [
              SizedBox(height: size.height * 0.15),
              Expanded(
                flex: 9,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: onboardContents.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Image(
                        image: Svg(onboardContents[index].image,
                            size: Size(size.width, size.height * 0.4)),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardContents.length,
                          (index) => dotIndicator(index),
                        ),
                      ),
                      SizedBox(height: size.height * 0.025),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          height: size.height * 0.3,
                          width: size.width * 0.9,
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            Text(
                              onboardContents[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.height * 0.03),
                            buildThemeButton(
                              context,
                              elevation: 0.0,
                              height: MediaQuery.of(context).size.height * 0.08,
                              color: Theme.of(context).primaryColor,
                              widget: Text(
                                'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: Theme.of(context).backgroundColor,
                                    ),
                              ),
                              function: () =>
                                  context.pushNamed(RegisterScreen.routeName),
                            ),
                            SizedBox(height: size.height * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(LoginScreen.routeName);
                                  },
                                  child: Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                )
                              ],
                            )
                          ]))
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: const Duration(milliseconds: 400),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Theme.of(context).backgroundColor
            : kSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
