import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../data/models/authentication/register_model.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/validation_util.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/3rdservices.dart';
import '../widgets/auth_input_field.dart';

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({
    Key? key,
    required this.onChangeAction,
    required this.onChangeEmailVerify,
  }) : super(key: key);

  final Function(AuthAction action) onChangeAction;
  final Function(String emailVerification) onChangeEmailVerify;

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  final _registerFormKey = GlobalKey<FormState>();
  final RegisterModel _registerModel = RegisterModel();

  void _onRegisterClick() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_registerFormKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().doRegister(_registerModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRegisterForms(context),
            _buildRegisterButton(),
            Expanded(child: Option())
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          widget.onChangeEmailVerify(_registerModel.email);
          widget.onChangeAction(AuthAction.verifyRegisterOTP);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return SizedBox(
            height: 4.h,
            child: FittedBox(
              child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: const CircularProgressIndicator()),
            ),
          );
        }
        return RoundedElevatedButton(
          label: 'Đăng ký',
          labelStyle: AppTypography.title.copyWith(color: Colors.white),
          width: 225.w,
          height: 44.h,
          radius: 22.r,
          onPressed: _onRegisterClick,
        );
      },
    );
  }

  Widget _buildRegisterForms(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AuthInputField(
          hintText: 'Tên',
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          capitalization: TextCapitalization.words,
          showHintError: _registerModel.invalidFullname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tên không được để trống';
            }
            return null;
          },
          onChange: (value) {
            _registerModel.fullName = value;
          },
        ),
        20.verticalSpace,
        AuthInputField(
          hintText: 'Email',
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          showHintError: _registerModel.invalidEmail,
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
            _registerModel.email = value;
          },
        ),
        20.verticalSpace,
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
            _registerModel.password = value;
          },
        ),
      ],
    );
  }
}
