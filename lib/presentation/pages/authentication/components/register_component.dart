import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/authentication/register_model.dart';
import '../../../../utils/validation_util.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({
    Key? key,
    required this.registerKeyForm,
    required this.onRegisterClick,
    required this.registerModel,
    required this.isLoading,
  }) : super(key: key);

  final GlobalKey<FormState> registerKeyForm;
  final VoidCallback onRegisterClick;
  final RegisterModel registerModel;
  final bool isLoading;

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.registerKeyForm,
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildRegisterForms(context),
            ),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Center(
      child: widget.isLoading
          ? SizedBox(
              height: 44.h,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: const CircularProgressIndicator(),
                ),
              ),
            )
          : RoundedElevatedButton(
              label: 'Đăng ký',
              labelStyle: AppTypography.title.copyWith(color: Colors.white),
              width: 225.w,
              height: 44.h,
              radius: 22.r,
              onPressed: widget.onRegisterClick,
            ),
    );
  }

  Widget _buildRegisterForms(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AuthInputField(
          hintText: 'Họ và tên*',
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          capitalization: TextCapitalization.words,
          showHintError: widget.registerModel.invalidFullname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              setState(() {
                widget.registerModel.invalidFullname = true;
              });
              return '';
            }
            setState(() {
              widget.registerModel.invalidFullname = false;
            });
            return null;
          },
          onChange: (value) {
            widget.registerModel.fullName = value;
          },
        ),
        AuthInputField(
          hintText: 'Email*',
          inputAction: TextInputAction.next,
          inputType: TextInputType.number,
          showHintError: widget.registerModel.invalidEmail,
          validator: (value) {
            if (value == null || !ValidationUtil.isValidEmail(value)) {
              setState(() {
                widget.registerModel.invalidEmail = true;
              });
              return '';
            }
            setState(() {
              widget.registerModel.invalidEmail = false;
            });
            return null;
          },
          onChange: (value) {
            widget.registerModel.email = value;
          },
        ),
        AuthInputField(
          hintText: 'Mật khẩu*',
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          obscure: true,
          showHintError: widget.registerModel.invalidPassword,
          validator: (value) {
            if (value == null || !ValidationUtil.isPasswordValid(value)) {
              setState(() {
                widget.registerModel.invalidPassword = true;
              });
              return '';
            }
            setState(() {
              widget.registerModel.invalidPassword = false;
            });
            return null;
          },
          onChange: (value) {
            widget.registerModel.password = value;
          },
        ),
        AuthInputField(
          hintText: 'Xác nhận lại mật khẩu*',
          inputAction: TextInputAction.done,
          inputType: TextInputType.text,
          obscure: true,
          showHintError: widget.registerModel.invalidRepeatPassword,
          validator: (value) {
            final repeatPW = value ?? '';
            if (repeatPW.compareTo(widget.registerModel.password) != 0 ||
                repeatPW.isEmpty) {
              setState(() {
                widget.registerModel.invalidRepeatPassword = true;
              });
              return '';
            }
            setState(() {
              widget.registerModel.invalidRepeatPassword = false;
            });
            return null;
          },
          onChange: (value) {
            widget.registerModel.repeatPassword = value;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: widget.registerModel.isAcceptedTerms,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  widget.registerModel.isAcceptedTerms = value;
                });
              },
              shape: const CircleBorder(),
              activeColor: AppColor.primary,
              checkColor: Colors.white,
            ),
            Text(
              'Đồng ý với các điều khoản!',
              style: AppTypography.body.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
            15.horizontalSpace,
          ],
        ),
      ],
    );
  }
}
