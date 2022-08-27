import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_provider_model.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:capstone_project_hcmut/view_models/login_viewmodel.dart';
import 'package:capstone_project_hcmut/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../utils/string_extension.dart';

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
  final email = TextEditingController()..text = '0906005539';
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
          print(value.isPop);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            !value.isPop ? Navigator.pop(context, true) : null;
            showsnackBar(context: context, message: value.errorMessage);
            value.setStatus(ViewState.none);
          });
        }
        return _buildUI(context, size);
      },
    );
  }

  // Widget _buildUI(BuildContext context, Size size) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).primaryColor,
  //       image: DecorationImage(
  //         image: Svg('assets/authentication/welcome_screen.svg', size: size),
  //       ),
  //     ),
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       body: SafeArea(
  //         child: Container(
  //           height: size.height,
  //           width: size.width,
  //           child: Column(
  //             children: [
  //               // Image(image: Svg('assets/logo.svg')),
  //               SizedBox(height: size.height * 0.05),
  //               _buildHuman(context, size),
  //               _buildOption(context, size),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildHuman(BuildContext context, Size size) {
  //   return Container(
  //     color: Colors.transparent,
  //     height: size.height * 0.45,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         SizedBox(width: size.width * 0.01),
  //         Image(
  //           image: Svg('assets/authentication/6.svg',
  //               size: Size(size.width, size.height)),
  //         ),
  //         Image(
  //           image: Svg('assets/authentication/3.svg',
  //               size: Size(size.width, size.height)),
  //         ),
  //         SizedBox(width: size.width * 0.01),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildOption(BuildContext context, Size size) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(25)),
  //     height: size.height * 0.36,
  //     width: size.width * 0.9,
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Login or Sign Up',
  //           style: Theme.of(context).textTheme.headline2?.copyWith(
  //                 fontWeight: FontWeight.w300,
  //               ),
  //         ),
  //         SizedBox(height: size.height * 0.015),
  //         Text(
  //           'Login or create an account to learn English, take part in challenges.',
  //           style: Theme.of(context).textTheme.headline5!.copyWith(
  //                 fontWeight: FontWeight.normal,
  //                 color: Theme.of(context).hintColor,
  //               ),
  //           textAlign: TextAlign.center,
  //         ),
  //         SizedBox(height: size.height * 0.025),
  //         buildThemeButton(
  //           context,
  //           elevation: 0.0,
  //           height: MediaQuery.of(context).size.height * 0.05,
  //           color: Theme.of(context).primaryColor,
  //           title: 'Login',
  //           function: () {},
  //         ),
  //         SizedBox(height: size.height * 0.015),
  //         buildThemeButton(
  //           context,
  //           elevation: 0,
  //           height: MediaQuery.of(context).size.height * 0.05,
  //           color: Theme.of(context).secondaryHeaderColor,
  //           title: 'Create an account',
  //           textStyle: Theme.of(context).textTheme.headline5!.copyWith(
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //           function: () {},
  //         ),
  //         SizedBox(height: size.height * 0.015),
  //         buildThemeButton(
  //           context,
  //           elevation: 0,
  //           height: MediaQuery.of(context).size.height * 0.05,
  //           color: Theme.of(context).backgroundColor,
  //           title: 'Later',
  //           textStyle: Theme.of(context).textTheme.headline5!.copyWith(
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //           function: () {},
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget _buildUI(BuildContext context, Size size) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/authentication/login.png'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              _buildWellcomeText(context),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      right: 35,
                      left: 35,
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Form(
                    key: Provider.of<LoginStateViewModel>(context).formKey,
                    child: Column(
                      children: [
                        _buildEmailOrPhoneField(context),
                        const SizedBox(height: 30),
                        _buildPasswordField(context),
                        const SizedBox(height: 40),
                        _buildLoginButton(context),
                        const SizedBox(height: 40),
                        _buildOptionsButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildWellcomeText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 35, top: 80),
      child: const Text(
        "Welcome\nBack",
        style: TextStyle(color: Colors.white, fontSize: 33),
      ),
    );
  }

  Widget _buildEmailOrPhoneField(BuildContext context) {
    return TextFormField(
      controller: email,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Please input correct email or phone';
        } else if (!value.isDigit(0) && value.isValidEmail()) {
          return 'Email is not correct';
        } else if (value.isDigit(0) && value.isValidPhoneNumber()) {
          return 'Phone is not correct';
        }
        return null;
      }),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: password,
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please input correct password';
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xff4c505b),
              fontSize: 27,
              fontWeight: FontWeight.w700,
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xff4c505b),
            child: IconButton(
              color: Colors.white,
              onPressed: _buildSubmitButton,
              icon: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      );

  Widget _buildOptionsButtons(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextButton(
        onPressed: () {
          return null;
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Color(0xff4c505b),
          ),
        ),
      ),
    ]);
  }

  void _buildSubmitButton() {
    final loginState = Provider.of<LoginStateViewModel>(context, listen: false);
    if (loginState.formKey.currentState!.validate()) {
      loginState.getToken(email.text, password.text, context);
    }
  }
}
