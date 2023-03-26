import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/widget_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';

class VerifyRegisterOTPComponent extends StatefulWidget {
  const VerifyRegisterOTPComponent({
    Key? key,
    required this.onChangeAction,
    required this.email,
  }) : super(key: key);

  final Function(AuthAction action) onChangeAction;
  final String email;

  @override
  State<VerifyRegisterOTPComponent> createState() =>
      _VerifyRegisterOTPComponentState();
}

class _VerifyRegisterOTPComponentState
    extends State<VerifyRegisterOTPComponent> {
  String _otpCode = '';

  void _onVerifyOTPClick() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_otpCode != '') {
      context.read<AuthCubit>().checkGmailVerify(widget.email, _otpCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is CheckEmailVerifySuccess) {
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        }
        if (state is CheckEmailVerifyFailure) {
          WidgetUtil.showSnackBar(context, state.errorMessage);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập mã OTP',
              style: AppTypography.title.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                text:
                    'Nhập mã OTP đã được gửi đến email của bạn để xác nhận',
                style: AppTypography.body,
                children: [
                  TextSpan(
                    text: widget.email,
                    style: AppTypography.body.copyWith(
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Pinput(
                  length: 6,
                  autofocus: true,
                  defaultPinTheme: AppTheme.defaultPinTheme,
                  focusedPinTheme: AppTheme.defaultPinTheme,
                  submittedPinTheme: AppTheme.defaultPinTheme,
                  pinContentAlignment: Alignment.center,
                  showCursor: true,
                  onCompleted: (otp) {
                    _otpCode = otp;
                  },
                ),
              ),
            ),
            _buildVerifyOTPButton(),
            10.verticalSpace,
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(RouteName.main),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 16.r,
                    color: AppColor.textSecondary,
                  ),
                  4.horizontalSpace,
                  Text(
                    'Xác nhận sau',
                    style: AppTypography.body.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyOTPButton() {
    return Center(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return SizedBox(
              height: 44.h,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: const CircularProgressIndicator(),
                ),
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
            onPressed: () => _onVerifyOTPClick(),
          );
        },
      ),
    );
  }
}
