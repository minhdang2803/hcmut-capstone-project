import 'package:capstone_project_hcmut/utils/string_extension.dart';
import 'package:capstone_project_hcmut/view_models/view_models.dart';
import 'package:capstone_project_hcmut/views/authentication/sign_up_3.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_widgets.dart';

class SignUpGetPassword extends StatelessWidget {
  const SignUpGetPassword({Key? key}) : super(key: key);
  static const String routeName = "SignUpGetPassWord";
  static MaterialPage page() {
    return const MaterialPage(
      child: SignUpGetPassword(),
      name: routeName,
      key: ValueKey(ValueKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final registerProvider =
        Provider.of<RegisterViewModel>(context, listen: false);
    String? password;
    return Scaffold(
      backgroundColor: kQuizGameUnselectedColor,
      body: SafeArea(
        child: Form(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAuthTopBar(
                  context,
                  size,
                  title: "What's your password?",
                  function: () => context.pop(),
                ),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.06),
                  child: Text(
                    'Password',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeTextFormField(
                    context,
                    size,
                    hintText: 'Your password',
                    controller: registerProvider.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your password';
                      } else if (!value.isValidPassword()) {
                        return 'Password is not valid';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.06),
                  child: Text(
                    'Confirm password',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeTextFormField(
                    context,
                    size,
                    hintText: 'Your confirm password',
                    controller: registerProvider.confirmPassword,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your confirm password';
                      } else if (!value.isValidPassword()) {
                        return 'Password is not valid';
                      } else if (password != '' && password != value) {
                        return 'Password must be consistence';
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                buildSignUpProcessBar(context, size, 2 / 3),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeButton(
                    context,
                    widget: Text(
                      'Next step',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white),
                    ),
                    width: size.width * 0.9,
                    color: Theme.of(context).primaryColor,
                    function: () =>
                        context.pushNamed(SignUpGetFullName.routeName),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final registerProvider =
        Provider.of<RegisterViewModel>(context, listen: false);
    final isValidForm = registerProvider.formKey.currentState!.validate();
    if (!isValidForm) {
      return;
    }
  }
}
