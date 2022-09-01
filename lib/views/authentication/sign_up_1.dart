import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import '../../utils/string_extension.dart';
import 'package:capstone_project_hcmut/view_models/view_models.dart';
import 'package:capstone_project_hcmut/views/authentication/sign_up_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpGetEmail extends StatelessWidget {
  const SignUpGetEmail({Key? key}) : super(key: key);
  static const String routeName = 'SignUpGetEmail';
  static MaterialPage page() {
    return const MaterialPage(
      child: SignUpGetEmail(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final registerProvider =
        Provider.of<RegisterViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: kQuizGameUnselectedColor,
      body: SafeArea(
        child: Form(
          key: registerProvider.formKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAuthTopBar(
                  context,
                  size,
                  title: "What's your email?",
                  function: () => context.pop(),
                ),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.06),
                  child: Text(
                    'Email Address',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeTextFormField(
                    context,
                    size,
                    controller: registerProvider.email,
                    hintText: 'Your email address',
                    prefixIcon: Icon(
                      Icons.mail,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!value.isValidEmail()) {
                        return 'Please enter correct email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.06),
                  child: Text(
                    'Phone number',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeTextFormField(
                    context,
                    size,
                    controller: registerProvider.phone,
                    hintText: 'Your phone number',
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      } else if (!value.isValidPhoneNumber()) {
                        return 'Please enter legal phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
                buildSignUpProcessBar(context, size, 1 / 3),
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
                    function: () {
                      _submitForm(context);
                      if (registerProvider.formKey.currentState!.validate()) {
                        context.pushNamed(SignUpGetPassword.routeName);
                      }
                    },
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
