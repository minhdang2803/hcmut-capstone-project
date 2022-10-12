import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/back_to_login_btn.dart';

class ForgotPassComponent extends StatefulWidget {
  const ForgotPassComponent({
    Key? key,
    required this.onChangeAction,
    required this.onChangeEmailVerify,
  }) : super(key: key);

  final Function(AuthAction action) onChangeAction;
  final Function(String emailVerification) onChangeEmailVerify;

  @override
  State<ForgotPassComponent> createState() => _ForgotPassComponentState();
}

class _ForgotPassComponentState extends State<ForgotPassComponent> {
  final _verifyEmailFormKey = GlobalKey<FormState>();
  var _email = '';

  void _onVerifyEmailClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_verifyEmailFormKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().gmailVerify(_email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is EmailVerifySuccess) {
          widget.onChangeEmailVerify(_email);
          widget.onChangeAction(AuthAction.verifyResetPwOTP);
        } else if (state is EmailVerifyFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opp.. You forgot password?',
              style: AppTypography.headline.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Please enter the registered email to recover the password',
              style: AppTypography.body,
            ),
            Form(
              key: _verifyEmailFormKey,
              child: AuthInputField(
                hintText: 'Your email',
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                validator: (value) {
                  if (value == null || !ValidationUtil.isValidEmail(value)) {
                    return 'Email is invalid';
                  }
                  return null;
                },
                enableErrorText: true,
                onChange: (value) {
                  _email = value;
                },
              ),
            ),
            _buildVerifyEmailButton(),
            10.verticalSpace,
            BackToLoginBtn(onChangeAction: widget.onChangeAction),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyEmailButton() {
    return Center(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return SizedBox(
              height: 44.h,
              child: FittedBox(
                child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: const CircularProgressIndicator()),
              ),
            );
          }
          return RoundedElevatedButton(
            label: 'Verify email',
            labelStyle: AppTypography.title.copyWith(color: Colors.white),
            width: 225.w,
            height: 44.h,
            radius: 22.r,
            onPressed: _onVerifyEmailClick,
          );
        },
      ),
    );
  }
}
