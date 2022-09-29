import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/string_util.dart';
import '../../../../utils/validation_util.dart';
import '../../../../utils/widget_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/rounded_elevated_button.dart';
import '../widgets/auth_input_field.dart';
import 'login_component.dart';
import 'register_component.dart';

class AuthContentCard extends StatefulWidget {
  const AuthContentCard({
    Key? key,
    required this.initialTabIndex,
  }) : super(key: key);

  final int initialTabIndex;

  @override
  State<AuthContentCard> createState() => _AuthContentCardState();
}

class _AuthContentCardState extends State<AuthContentCard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: context.read<AuthLogic>().authTabs.length, vsync: this);
    _tabController
        .addListener(() => context.read<AuthLogic>().onTabChange(context));
    _tabController.animateTo(widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController
        .removeListener(() => context.read<AuthLogic>().onTabChange(context));
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authLogic = context.read<AuthLogic>();
    return Consumer<AuthLogic>(
      builder: (context, value, child) {
        return AnimatedContainer(
          onEnd: () {
            if (!authLogic.changeLayout) {
              authLogic.changeAuthAction(AuthAction.authentication);
            }
          },
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(34.r),
          ),
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 150),
          width: 315.w,
          height: authLogic.changeLayout ? 336.h : 524.h,
          child: _buildAuthContent(value),
        );
      },
    );
  }

  Widget _buildAuthContent(AuthLogic value) {
    final authLogic = context.read<AuthLogic>();

    Widget child = Padding(
      padding: EdgeInsets.only(top: 45.h),
      child: Column(
        children: [
          Container(
            height: 32.h,
            width: 225.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: AppTypography.body,
              labelColor: Colors.white,
              unselectedLabelStyle: AppTypography.body,
              unselectedLabelColor: AppColor.primary,
              indicator: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              // indicatorColor: themeData.colorScheme.primary,
              tabs: authLogic.authTabs,
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const LoginComponent(),
                RegisterComponent(
                  registerKeyForm: authLogic.registerKeyForm,
                  onRegisterClick: () =>
                      authLogic.onRegisterClick(context, mounted),
                  registerModel: authLogic.registerModel,
                  isLoading: authLogic.otpVerifying,
                ),
              ],
            ),
          )
        ],
      ),
    );
    if (value.authAction == AuthAction.forgotPassword) {
      child = _buildForgotPassword();
    } else if (value.authAction == AuthAction.resetPassword) {
      child = _buildResetPassword();
    } else if (value.authAction == AuthAction.verifyResetPwOTP ||
        value.authAction == AuthAction.verifyRegisterOTP) {
      child = _buildVerifyOTP();
    }
    // Future.delayed(Duration.zero);
    return child;
  }

  Widget _buildForgotPassword() {
    final authLogic = context.read<AuthLogic>();
    final phoneFormKey = GlobalKey<FormState>();
    return Padding(
      padding: EdgeInsets.all(30.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn quên mật khẩu?',
            style: AppTypography.headline.copyWith(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Vui lòng nhập số điện thoại đã đăng ký để khôi phục mật khẩu',
            style: AppTypography.body,
          ),
          Form(
            key: phoneFormKey,
            child: AuthInputField(
              hintText: 'Số điện thoại',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || !ValidationUtil.isValidEmail(value)) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
              enableErrorText: true,
              onChange: (value) {
                authLogic.verifyPhoneNbr = value;
              },
            ),
          ),
          Center(
            child: authLogic.otpVerifying
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
                    label: 'Xác nhận',
                    labelStyle:
                        AppTypography.title.copyWith(color: Colors.white),
                    width: 225.w,
                    height: 44.h,
                    radius: 22.r,
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (phoneFormKey.currentState?.validate() ?? false) {
                        authLogic.setVerifyLoading(true);
                        final bool phoneExisting = await context
                            .read<AuthCubit>()
                            .checkPhoneNumber(authLogic.verifyPhoneNbr);
                        if (phoneExisting) {
                          authLogic.sendOTP(AuthAction.verifyResetPwOTP);
                        } else {
                          if (mounted) {
                            WidgetUtil.showSnackBar(
                                context, 'Số điện thoại chưa được đăng ký');
                          }
                          authLogic.verifyPhoneNbr = '';
                          authLogic.setVerifyLoading(false);
                        }
                      }
                    },
                  ),
          ),
          10.verticalSpace,
          GestureDetector(
            onTap: () {
              authLogic.goBackToAuthentication();
            },
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
                  'Quay lại',
                  style: AppTypography.body.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerifyOTP() {
    final authLogic = context.read<AuthLogic>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.of(context).pushReplacementNamed(RouteName.main);
        }
        if (state is RegisterFailure) {
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
              'Nhập mã xác nhận',
              style: AppTypography.title.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                text:
                    'Quý phật tử vui lòng nhập mã OTP đã được gửi về số điện thoại ',
                style: AppTypography.body,
                children: [
                  TextSpan(
                    text: StringUtil.securityPhone(authLogic.verifyPhoneNbr),
                    style: AppTypography.body.copyWith(
                      color: AppColor.primary,
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
                    authLogic.codeOTP = otp;
                  },
                ),
              ),
            ),
            Center(
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
                    labelStyle:
                        AppTypography.title.copyWith(color: Colors.white),
                    width: 225.w,
                    height: 44.h,
                    radius: 22.r,
                    onPressed: () => authLogic.verifyOTP(context, mounted),
                  );
                },
              ),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: authLogic.goBackToAuthentication,
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
                    'Quay lại',
                    style: AppTypography.body.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResetPassword() {
    final authLogic = context.read<AuthLogic>();
    final passwordFormKey = GlobalKey<FormState>();
    var password = '';
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          WidgetUtil.showSnackBar(context, state.errorMessage);
        }
        if (state is ResetPasswordSuccess) {
          authLogic.goBackToAuthentication();
          WidgetUtil.showSnackBar(context, state.message);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tạo mật khẩu mới',
              style: AppTypography.title.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: passwordFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthInputField(
                    obscure: true,
                    hintText: 'Mật khẩu mới',
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null ||
                          !ValidationUtil.isPasswordValid(value)) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                    enableErrorText: true,
                    onChange: (value) {
                      password = value;
                    },
                  ),
                  AuthInputField(
                    obscure: true,
                    hintText: 'Xác nhận mật khẩu mới',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || !(value == password)) {
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
            Center(
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
                    labelStyle:
                        AppTypography.title.copyWith(color: Colors.white),
                    width: 225.w,
                    height: 44.h,
                    radius: 22.r,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (passwordFormKey.currentState?.validate() ?? false) {
                        context.read<AuthCubit>().doResetPassword(
                            authLogic.verifyPhoneNbr, password);
                      }
                    },
                  );
                },
              ),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: authLogic.goBackToAuthentication,
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
                    'Quay lại',
                    style: AppTypography.body.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
