import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/enum.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import 'forgot_pass_component.dart';
import 'login_component.dart';
import 'register_component.dart';
import 'reset_pass_component.dart';
import 'verify_otp_component.dart';
import 'verify_register_otp_component.dart';

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
  AuthAction _authAction = AuthAction.authentication;

  String _emailVerification = '';
  String _tokenVerification = '';

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
  }

  void _changeAuthAction(AuthAction action) {
    setState(() {
      if (action == AuthAction.forgotPassword ||
          action == AuthAction.verifyRegisterOTP) {
        _changeLayout = true;
      }

      if (action == AuthAction.authentication) {
        _changeLayout = false;
        _emailVerification = '';
        _tokenVerification = '';
      }

      _authAction = action;
    });
  }

  void _changeEmailVerification(String email) {
    setState(() {
      _emailVerification = email;
    });
  }

  void _changeTokenVerification(String token) {
    setState(() {
      _tokenVerification = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        if (!_changeLayout) {
          _changeAuthAction(AuthAction.authentication);
        }
      },
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.textPrimary, width: 1.5),
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(34.r),
      ),
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 250),
      width: 315.w,
      height: _changeLayout ? 340.h : 460.h,
      child: _buildAuthContent(),
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
              border: Border.all(color: AppColor.defaultBorder),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: AppTypography.body,
              labelColor: AppColor.textPrimary,
              unselectedLabelStyle: AppTypography.body,
              unselectedLabelColor: AppColor.textSecondary,
              indicator: BoxDecoration(
                color: AppColor.accentBlue,
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
                  onChangeAction: _changeAuthAction,
                  onChangeEmailVerify: _changeEmailVerification,
                ),
              ],
            ),
          )
        ],
      ),
    );
    if (_authAction == AuthAction.forgotPassword) {
      child = ForgotPassComponent(
        onChangeAction: _changeAuthAction,
        onChangeEmailVerify: _changeEmailVerification,
      );
    } else if (_authAction == AuthAction.resetPassword) {
      child = ResetPassComponent(
        onChangeAction: _changeAuthAction,
        email: _emailVerification,
        token: _tokenVerification,
      );
    } else if (_authAction == AuthAction.verifyResetPwOTP) {
      child = VerifyOTPComponent(
        onChangeAction: _changeAuthAction,
        onChangeTokenVerify: _changeTokenVerification,
        email: _emailVerification,
      );
    } else if (_authAction == AuthAction.verifyRegisterOTP) {
      child = VerifyRegisterOTPComponent(
        onChangeAction: _changeAuthAction,
        email: _emailVerification,
      );
    }
    return child;
  }
}
