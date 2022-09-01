import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/utils/shared_preference_wrapper.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:capstone_project_hcmut/view_models/view_models.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String routeName = 'RegisterScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: RegisterScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _buildNormalProvider(context, size);
  }

  Widget _buildNormalProvider(BuildContext context, Size size) {
    return Consumer<LoginStateViewModel>(
      builder: (context, value, child) {
        if (value.viewState == ViewState.loading) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              showDialog(
                context: context,
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    value.isPop = true;
                    value.isCancel = true;
                    value.cancelToken.cancel();
                    return true;
                  },
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (value.viewState == ViewState.done) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            final pref = SharedPreferencesWrapper.instance;
            final refreshToken = await pref.getBool('isLoggedIn');
            if (refreshToken) {
              context.goNamed(HomeScreen.routeName, params: {'tab': 'home'});
            }
            value.setStatus(ViewState.none);
          });
        } else if (value.viewState == ViewState.fail) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            !value.isPop ? Navigator.pop(context, true) : null;
            showDialogAlert(
                context: context,
                title: 'Alert!',
                buttonText: 'Got it!',
                message: value.errorMessage,
                onPressed: () {
                  Navigator.pop(context, true);
                });
            value.setStatus(ViewState.none);
          });
        }
        return _buildUI(context, size);
      },
      child: _buildUI(context, size),
    );
  }

  Widget _buildUI(BuildContext context, Size size) {
    return Scaffold(
      backgroundColor: kQuizGameUnselectedColor,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              buildAuthTopBar(
                context,
                size,
                title: 'Sign Up',
                function: () => context.pop(),
              ),
              SizedBox(height: size.height * 0.05),
              _buildLoginOption(context, size),
              SizedBox(height: size.height * 0.025),
              _buildHaveAnAccount(context, size),
              SizedBox(height: size.height * 0.025),
              _buildRichTextPrivacy(context, size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context, Size size) {
    return Container(
      width: size.width,
      child: Column(
        children: [
          buildThemeButton(context,
              height: size.height * 0.07,
              width: size.width * 0.9,
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail_outline),
                  SizedBox(width: size.width * 0.025),
                  Text('Sign up with email',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).backgroundColor,
                          )),
                ],
              ),
              color: Theme.of(context).primaryColor,
              elevation: 0,
              function: () async =>
                  context.pushNamed(SignUpGetEmail.routeName)),
          SizedBox(height: size.height * 0.025),
          buildThemeButton(
            context,
            height: size.height * 0.07,
            width: size.width * 0.9,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/authentication/google_icon.svg',
                  height: size.height * 0.03,
                  width: size.width * 0.03,
                ),
                SizedBox(width: size.width * 0.025),
                Text('Sign up with Google',
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            function: () async =>
                Provider.of<LoginStateViewModel>(context, listen: false)
                    .loginbyGoogle(),
          ),
          SizedBox(height: size.height * 0.025),
          buildThemeButton(
            context,
            height: size.height * 0.07,
            width: size.width * 0.9,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.facebook),
                SizedBox(width: size.width * 0.025),
                Text(
                  'Sign up with Facebook',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Theme.of(context).backgroundColor),
                ),
              ],
            ),
            color: kFacebookIcon,
            elevation: 0,
            function: () async =>
                Provider.of<LoginStateViewModel>(context, listen: false)
                    .loginByFacebook(),
          ),
        ],
      ),
    );
  }

  Widget _buildHaveAnAccount(BuildContext context, Size size) {
    const String text = 'Already have an account? Login';
    _buildRichText(BuildContext context) {
      List<InlineSpan> richtext = [];
      final value = text.split(' ');
      for (final element in value) {
        if (element == "Login") {
          richtext.add(
            TextSpan(
              text: element,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          );
        } else {
          richtext.add(
            TextSpan(
              text: element,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: kGreyBodyText),
            ),
          );
        }
        richtext.add(
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 5.0),
            ),
          ),
        );
      }
      return richtext;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: TextButton(
        onPressed: () => context.pushNamed(LoginScreen.routeName),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [..._buildRichText(context)])),
      ),
    );
  }

  Widget _buildRichTextPrivacy(BuildContext context, Size size) {
    const String loginScreenPrivacyText =
        "By continuing, you agree to the Terms of Services & Privacy Policy.";
    _buildRichText(BuildContext context) {
      List<InlineSpan> richtext = [];
      final value = loginScreenPrivacyText.split(' ');
      for (final element in value) {
        if (['Terms', 'of', 'Services', 'Privacy', 'Policy.']
            .contains(element)) {
          richtext.add(
            TextSpan(
                text: element, style: Theme.of(context).textTheme.headline4),
          );
          richtext.add(
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
              ),
            ),
          );
        } else {
          richtext.add(
            TextSpan(
                text: element,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kGreyBodyText)),
          );
          richtext.add(
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
              ),
            ),
          );
        }
      }
      return richtext;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [..._buildRichText(context)])),
    );
  }
}
