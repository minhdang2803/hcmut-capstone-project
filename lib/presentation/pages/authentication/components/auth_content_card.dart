import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../data/models/authentication/register_model.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/log_util.dart';
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
  static const authTabs = <Tab>[
    Tab(child: FittedBox(child: Text('Đăng nhập'))),
    Tab(child: FittedBox(child: Text('Đăng ký'))),
  ];
  late TabController _tabController;
  bool _changeLayout = false;
  bool _otpVerifying = false;
  AuthAction _authAction = AuthAction.authentication;

  // Use this variable as global but not within forgotPW section
  // cuz we need to pass the number to verifyOTP section
  String _verifyPhoneNbr = '';

  String _verificationID = '';
  String _codeOTP = '';
  final _registerKeyForm = GlobalKey<FormState>();
  final _registerModel = RegisterModel();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: authTabs.length, vsync: this);
    _tabController.addListener(_onTabChange);
    _tabController.animateTo(widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _verifyPhoneNbr = '';
    _verificationID = '';
    setState(() {
      _registerModel.clear();
    });
  }

  void _goBackToAuthentication() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _changeLayout = false;
      _otpVerifying = false;
      _verifyPhoneNbr = '';
    });
  }

  void _changeAuthAction(AuthAction action) {
    setState(() {
      if (action == AuthAction.forgotPassword ||
          action == AuthAction.verifyRegisterOTP) {
        _changeLayout = true;
      }
      _authAction = action;
    });
  }

  void _onRegisterClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_registerKeyForm.currentState?.validate() ?? false) {
      if (!_registerModel.isAcceptedTerms) {
        WidgetUtil.showSnackBar(context, 'Vui lòng chấp nhận điều khoản');
        return;
      }
      _setVerifyLoading(true);
      final bool phoneExisting = await context
          .read<AuthCubit>()
          .checkPhoneNumber(_registerModel.email);
      if (phoneExisting) {
        if (mounted) {
          WidgetUtil.showSnackBar(context, 'Email đã được sử dụng');
        }
        _verifyPhoneNbr = '';
        _setVerifyLoading(false);
        return;
      }
      _sendOTP(AuthAction.verifyRegisterOTP);
    } else {
      WidgetUtil.showSnackBar(
          context, 'Thông tin đăng ký chưa hợp lệ, vui lòng kiểm trả lại');
    }
  }

  void _sendOTP(AuthAction action) async {
    // send otp
  }

  void _setVerifyLoading(bool value) {
    setState(() {
      _otpVerifying = value;
    });
  }

  void _verifyOTP() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      // verify otp
      if (_authAction == AuthAction.verifyResetPwOTP) {
        _changeAuthAction(AuthAction.resetPassword);
      } else if (_authAction == AuthAction.verifyRegisterOTP) {
        if (!mounted) return;
        context.read<AuthCubit>().doRegister(_registerModel);
      }
    } catch (e) {
      LogUtil.error('Verify phone fail: Invalid OTP', error: e);
      WidgetUtil.showSnackBar(context, 'Mã OTP không chính xác!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(34.r),
      child: AnimatedContainer(
        onEnd: () {
          if (!_changeLayout) {
            _changeAuthAction(AuthAction.authentication);
          }
        },
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34.r),
        ),
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 250),
        width: 315.w,
        height: _changeLayout ? 336.h : 524.h,
        child: _buildAuthContent(),
      ),
    );
  }

  Widget _buildAuthContent() {
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
              tabs: authTabs,
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LoginComponent(onChangeAction: _changeAuthAction),
                RegisterComponent(
                  registerKeyForm: _registerKeyForm,
                  onRegisterClick: _onRegisterClick,
                  registerModel: _registerModel,
                  isLoading: _otpVerifying,
                ),
              ],
            ),
          )
        ],
      ),
    );
    if (_authAction == AuthAction.forgotPassword) {
      child = _buildForgotPassword();
    } else if (_authAction == AuthAction.resetPassword) {
      child = _buildResetPassword();
    } else if (_authAction == AuthAction.verifyResetPwOTP ||
        _authAction == AuthAction.verifyRegisterOTP) {
      child = _buildVerifyOTP();
    }
    return child;
  }

  Widget _buildForgotPassword() {
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
                _verifyPhoneNbr = value;
              },
            ),
          ),
          Center(
            child: _otpVerifying
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
                        _setVerifyLoading(true);
                        final bool phoneExisting = await context
                            .read<AuthCubit>()
                            .checkPhoneNumber(_verifyPhoneNbr);
                        if (phoneExisting) {
                          _sendOTP(AuthAction.verifyResetPwOTP);
                        } else {
                          if (mounted) {
                            WidgetUtil.showSnackBar(
                                context, 'Số điện thoại chưa được đăng ký');
                          }
                          _verifyPhoneNbr = '';
                          _setVerifyLoading(false);
                        }
                      }
                    },
                  ),
          ),
          10.verticalSpace,
          GestureDetector(
            onTap: _goBackToAuthentication,
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
                    text: StringUtil.securityPhone(_verifyPhoneNbr),
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
                    _codeOTP = otp;
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
                    onPressed: _verifyOTP,
                  );
                },
              ),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: _goBackToAuthentication,
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
    final passwordFormKey = GlobalKey<FormState>();
    var password = '';
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          WidgetUtil.showSnackBar(context, state.errorMessage);
        }
        if (state is ResetPasswordSuccess) {
          _goBackToAuthentication();
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
                        context
                            .read<AuthCubit>()
                            .doResetPassword(_verifyPhoneNbr, password);
                      }
                    },
                  );
                },
              ),
            ),
            10.verticalSpace,
            GestureDetector(
              onTap: _goBackToAuthentication,
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
