import 'package:capstone_project_hcmut/utils/custom_widgets.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';
import 'package:capstone_project_hcmut/view_models/register_viewmodel.dart';
import 'package:capstone_project_hcmut/view_models/theme_viewmodel.dart';
import 'package:capstone_project_hcmut/views/views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpGetFullName extends StatelessWidget {
  const SignUpGetFullName({Key? key}) : super(key: key);
  static const String routeName = 'SignUpGetUserName';
  static MaterialPage page() {
    return const MaterialPage(
      child: SignUpGetFullName(),
      name: routeName,
      key: ValueKey(routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
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
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialogAlert(
                context: context,
                title: 'Congratulation!',
                buttonText: 'Start the Journeyyyy!',
                message: 'Successfully Registration!',
                onPressed: () {
                  context.goNamed(LoginScreen.routeName);
                });
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
        return _buildUI(context, value);
      },
    );
  }

  Widget _buildUI(BuildContext context, RegisterViewModel registerProvider) {
    Size size = MediaQuery.of(context).size;
    // final registerProvider =
    //     Provider.of<RegisterViewModel>(context, listen: false);
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
                  title: "What's your full name?",
                  function: () => context.pop(),
                ),
                SizedBox(height: size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.06),
                  child: Text(
                    'Full name',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeTextFormField(
                    context,
                    size,
                    controller: registerProvider.fullName,
                    hintText: 'Your full name',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                buildSignUpProcessBar(context, size, 1),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: buildThemeButton(
                    context,
                    widget: Text(
                      'Start your journey!',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white),
                    ),
                    width: size.width * 0.9,
                    color: Theme.of(context).primaryColor,
                    function: () {
                      _submitForm(context);
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
    registerProvider.register(
        phone: registerProvider.phone.text,
        email: registerProvider.email.text,
        password: registerProvider.password.text,
        fullName: registerProvider.fullName.text);
  }
}
