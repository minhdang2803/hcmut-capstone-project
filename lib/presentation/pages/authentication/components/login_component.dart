import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/circular_border_icon.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({Key? key}) : super(key: key);

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
                        return 'Email không được bỏ trống';
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
                        return 'Mật khẩu không được bỏ trống';
                      }
                      if (!ValidationUtil.isPasswordValid(value)) {
                        return 'Mật khẩu không hợp lệ';
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
                      onTap: () {
                        context
                            .read<AuthLogic>()
                            .changeAuthAction(AuthAction.forgotPassword);
                      },
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
            Expanded(
              child: _buildLoginAction(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginAction() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLoginButton(),
        Text(
          'HOẶC',
          style: AppTypography.body.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularBorderIcon(
              icon: SvgPicture.asset(
                'assets/icons/ic_facebook.svg',
                width: 24.r,
                height: 24.r,
              ),
              borderColor: Colors.grey[400]!,
              onIconClick: () {
                // context.read<AuthCubit>().doFacebookLogin();
              },
            ),
            14.horizontalSpace,
            CircularBorderIcon(
              icon: SvgPicture.asset(
                'assets/icons/ic_google.svg',
                width: 30.r,
                height: 30.r,
              ),
              borderColor: Colors.grey[400]!,
              onIconClick: () {
                //context.read<AuthCubit>().doGoogleLogin();
              },
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(RouteName.main);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sử dụng không cần đăng nhập',
                style: AppTypography.body.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Icon(
                Icons.arrow_right_alt_rounded,
                size: 32.r,
                color: AppColor.textSecondary,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        } else if (state is LoginFailure) {
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
                  child: const CircularProgressIndicator()),
            ),
          );
        }
        return RoundedElevatedButton(
          label: 'Đăng nhập',
          labelStyle: AppTypography.title.copyWith(color: Colors.white),
          width: 225.w,
          height: 44.h,
          radius: 22.r,
          onPressed: _onLoginClick,
        );
      },
    );
  }
}
