import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:capstone_project_hcmut/view_models/login_viewmodel.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:capstone_project_hcmut/views/authentication/welcome_screen.dart';
import 'package:capstone_project_hcmut/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'LoginScreen';
  static MaterialPage page() {
    return const MaterialPage(
      child: LoginScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController()..text = '0906005535';
  final password = TextEditingController()..text = '123456';
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<LoginStateViewModel>(
      builder: (context, value, child) {
        if (value.viewState == ViewState.loading) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              showDialog(
                context: context,
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    print('hello');
                    value.isPop = true;
                    value.isCancel = true;
                    value.cancelToken.cancel();
                    return true;
                  },
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        } else if (value.viewState == ViewState.done) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.goNamed(HomeScreen.routeName, params: {'tab': 'home'});
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
        return _buildUI(context, size, value);
      },
    );
  }

  void _submitform(BuildContext context) {
    final loginState = Provider.of<LoginStateViewModel>(context, listen: false);
    if (loginState.loginFormKey.currentState!.validate()) {
      loginState.loginByEmail(email.text, password.text, context);
    }
  }

  Widget _buildUI(BuildContext context, Size size, LoginStateViewModel value) {
    return Scaffold(
      backgroundColor: kQuizGameUnselectedColor,
      body: SafeArea(
        child: Form(
          key: value.loginFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: size.height * 0.03),
                _buildTopBar(context, size),
                SizedBox(height: size.height * 0.03),
                _buildLoginOption(context, size),
                SizedBox(height: size.height * 0.03),
                _buildDivider(context, size),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Text('Email',
                      style: Theme.of(context).textTheme.headline4),
                ),
                SizedBox(height: size.height * 0.01),
                Center(child: _buildLoginForm(context, size)),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Text(
                    'Password',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(child: _buildPasswordForm(context, size)),
                SizedBox(height: size.height * 0.02),
                _buildSubmitButon(context, size),
                SizedBox(height: size.height * 0.05),
                _buildForgotPassword(context, size),
                SizedBox(height: size.height * 0.05),
                _buildRichTextPrivacy(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              size: 35,
            ),
          ),
          Text(
            'Login',
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
          SizedBox(
            width: size.width * 0.1,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context, Size size) {
    return Container(
      width: size.width,
      child: Column(
        children: [
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
                Text('Login with Google',
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            function: () {},
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
                Text('Login with Facebook',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Theme.of(context).backgroundColor)),
              ],
            ),
            color: kFacebookIcon,
            elevation: 0,
            function: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Divider(
            color: Provider.of<ThemeManager>(context, listen: false).getDarkMode
                ? Colors.white.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            thickness: 1,
          ),
        ),
        SizedBox(width: size.width * 0.02),
        Text(
          'Or',
          style: Theme.of(context).textTheme.headline3?.copyWith(
                fontWeight: FontWeight.normal,
                color: Provider.of<ThemeManager>(context, listen: false)
                        .getDarkMode
                    ? Colors.white
                    : Colors.grey,
              ),
        ),
        SizedBox(width: size.width * 0.02),
        Flexible(
          child: Divider(
            color: Provider.of<ThemeManager>(context, listen: false).getDarkMode
                ? Colors.white.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, Size size) {
    return buildThemeTextFormField(context, size,
        prefixIcon: Icon(
          Icons.email,
          size: 25,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter your email',
        controller: email);
  }

  Widget _buildPasswordForm(BuildContext context, Size size) {
    return buildThemeTextFormField(context, size,
        prefixIcon: Icon(
          Icons.lock,
          size: 25,
          color: Theme.of(context).primaryColor,
        ),
        hintText: 'Enter your password',
        isPassword: true,
        posfixIcon: GestureDetector(
          onLongPressDown: null,
          onLongPressUp: null,
          child: Icon(
            Icons.remove_red_eye,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        controller: password);
  }

  Widget _buildSubmitButon(BuildContext context, Size size) {
    return Center(
      child: buildThemeButton(
        context,
        elevation: 0.0,
        borderRadius: 25,
        height: size.height * 0.065,
        width: size.width * 0.9,
        color: Theme.of(context).primaryColor,
        widget: Text(
          'Login',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Theme.of(context).backgroundColor,
              ),
        ),
        function: () => _submitform(context),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context, Size size) {
    return Center(
      child: Text(
        'Forgot password?',
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }

  _buildRichText(BuildContext context) {
    List<InlineSpan> richtext = [];
    final value = loginScreenPrivacyText.split(' ');
    for (final element in value) {
      if (['Terms', 'of', 'Services', 'Privacy', 'Policy.'].contains(element)) {
        richtext.add(
          TextSpan(text: element, style: Theme.of(context).textTheme.headline4),
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

  Widget _buildRichTextPrivacy(BuildContext context, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [..._buildRichText(context)])),
    );
  }
}

final String loginScreenPrivacyText =
    'By continuing, you agree to the Terms of Services & Privacy Policy.';
