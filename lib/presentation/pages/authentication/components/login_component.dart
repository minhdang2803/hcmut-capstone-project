import 'package:bke/presentation/pages/authentication/widgets/3rdservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({
    Key? key,
    required this.onChangeAction,
  }) : super(key: key);

  final Function(AuthAction action) onChangeAction;

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _onLoginClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().doLogin(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthInputField(
                    hintText: 'Email',
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    enableErrorText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email không được để trống';
                      }
                      if (!ValidationUtil.isValidEmail(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                    onChange: (value) {
                      _email = value;
                    },
                  ),
                  AuthInputField(
                    hintText: 'Mật khẩu',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    obscure: true,
                    enableErrorText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mật khẩu không được để trống';
                      }
                      if (!ValidationUtil.isPasswordValid(value)) {
                        return 'Mật khẩu phải có nhiều hơn 6 ký tự';
                      }
                      return null;
                    },
                    onChange: (value) {
                      _password = value;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          widget.onChangeAction(AuthAction.forgotPassword),
                      child: Text(
                        'Quên mật khẩu?',
                        style: AppTypography.body.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildLoginButton(),
            const Expanded(
              child: Option(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        }else if (state is WaitingPassword) {
           Navigator.of(context).pushReplacementNamed(RouteName.setPassComponent);
        }else if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return SizedBox(
            height: 44.h,
            child: FittedBox(
              child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: const CircularProgressIndicator(
                    color: AppColor.secondary,
                  )),
            ),
          );
        }
        return RoundedElevatedButton(
          label: 'Đăng nhập',
          labelStyle: AppTypography.title.copyWith(color: AppColor.textPrimary),
          backgroundColor: AppColor.accentBlue,
          width: 225.w,
          height: 44.h,
          radius: 22.r,
          onPressed: _onLoginClick,
        );
      },
    );
  }
}
