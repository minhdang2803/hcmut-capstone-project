import 'dart:math';

import 'package:capstone_project_hcmut/view_models/abstract/base_provider_model.dart';
import 'package:capstone_project_hcmut/view_models/login_viewmodel.dart';
import 'package:capstone_project_hcmut/views/home_screen.dart';
import 'package:flutter/material.dart';
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
    return Consumer<LoginStateViewModel>(builder: (context, value, child) {
      if (value.data.viewStatus == ViewStatus.loading) {
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      } else if (value.data.viewStatus == ViewStatus.succeed) {
        if (value.data.data == null) {
          print('No matching username/password');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.goNamed(HomeScreen.routeName, params: {'tab':'home'});
          });
          return Container();
        }
      } else if (value.data.viewStatus == ViewStatus.failed) {
        return const Scaffold(
          body: Center(
            child: Text('Failed'),
          ),
        );
      }
      return _buildUI(context);
    });
  }

  Widget _buildUI(BuildContext context) => Container(
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
      loginState.getToken(email.text, password.text);
    }
  }
}
