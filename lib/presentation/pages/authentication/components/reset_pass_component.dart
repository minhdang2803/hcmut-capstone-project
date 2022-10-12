import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../../utils/widget_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/back_to_login_btn.dart';

class ResetPassComponent extends StatefulWidget {
  const ResetPassComponent({
    Key? key,
    required this.onChangeAction,
    required this.email,
    required this.token,
  }) : super(key: key);

  final Function(AuthAction action) onChangeAction;
  final String email;
  final String token;

  @override
  State<ResetPassComponent> createState() => _ResetPassComponentState();
}

class _ResetPassComponentState extends State<ResetPassComponent> {
  final _passwordFormKey = GlobalKey<FormState>();
  String _password = '';

  void _onResetPassClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_passwordFormKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .resetPassword(widget.token, widget.email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          WidgetUtil.showSnackBar(context, state.errorMessage);
        }
        if (state is ResetPasswordSuccess) {
          WidgetUtil.showSnackBar(context, "Change password successfully");
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create new password',
              style: AppTypography.title.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _passwordFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthInputField(
                    obscure: true,
                    hintText: 'New password',
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null ||
                          !ValidationUtil.isPasswordValid(value)) {
                        return 'Password should have at least 6 characters';
                      }
                      return null;
                    },
                    enableErrorText: true,
                    onChange: (value) {
                      _password = value;
                    },
                  ),
                  AuthInputField(
                    obscure: true,
                    hintText: 'Confirm password',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || !(value == _password)) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    enableErrorText: true,
                    onChange: (_) => null,
                  ),
                ],
              ),
            ),
            _buildResetPassButton(),
            10.verticalSpace,
            BackToLoginBtn(onChangeAction: widget.onChangeAction),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPassButton() {
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
            label: 'Confirm',
            labelStyle: AppTypography.title.copyWith(color: Colors.white),
            width: 225.w,
            height: 44.h,
            radius: 22.r,
            onPressed: _onResetPassClick,
          );
        },
      ),
    );
  }
}
