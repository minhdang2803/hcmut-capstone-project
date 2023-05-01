import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../data/models/authentication/register_model.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../../utils/widget_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/back_to_login_btn.dart';

class SetPassComponent extends StatefulWidget {
  const SetPassComponent({
    Key? key,

  }) : super(key: key);

  @override
  State<SetPassComponent> createState() => _SetPassComponentState();
}

class _SetPassComponentState extends State<SetPassComponent> {
  final _passwordFormKey = GlobalKey<FormState>();
  String _password = '';

  void _onResetPassClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_passwordFormKey.currentState?.validate() ?? false) {
      final RegisterModel registerModel = RegisterModel();
      registerModel.password = _password;
      context
          .read<AuthCubit>()
          .doRegister(registerModel, is3party: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo một mật khẩu',
                style: AppTypography.title.copyWith(
                  color: AppColor.textPrimary,
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
                      hintText: 'Mật khẩu',
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null ||
                            !ValidationUtil.isPasswordValid(value)) {
                          return 'Mật khẩu phải có nhiều hơn 6 ký tự';
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
                      hintText: 'Xác nhận mật khẩu',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || !(value == _password)) {
                          return 'Mật khẩu không trùng khớp';
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
              // BackToLoginBtn(onChangeAction: widget.onChangeAction),
            ],
          ),
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
            label: 'Xác nhận',
            labelStyle: AppTypography.title.copyWith(color: AppColor.textPrimary),
            backgroundColor: AppColor.accentBlue,
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
