part of 'auth_cubit.dart';

class AuthLogic extends AuthCubit with ChangeNotifier {
  List<Tab> authTabs = const [
    Tab(child: FittedBox(child: Text('Đăng nhập'))),
    Tab(child: FittedBox(child: Text('Đăng ký'))),
  ];

  bool changeLayout = false;
  bool otpVerifying = false;
  AuthAction authAction = AuthAction.authentication;

  String verifyPhoneNbr = '';
  String verificationID = '';
  String codeOTP = '';
  final registerKeyForm = GlobalKey<FormState>();
  final registerModel = RegisterModel();

  void onTabChange(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    verifyPhoneNbr = '';
    verificationID = '';
    registerModel.clear();
  }

  void goBackToAuthentication() {
    FocusManager.instance.primaryFocus?.unfocus();
    authAction = AuthAction.authentication;
    changeLayout = false;
    otpVerifying = false;
    verifyPhoneNbr = '';
    notifyListeners();
  }

  void changeAuthAction(AuthAction action) {
    if (action == AuthAction.forgotPassword ||
        action == AuthAction.verifyRegisterOTP) {
      changeLayout = true;
    }
    authAction = action;
    notifyListeners();
  }

  void setVerifyLoading(bool value) {
    otpVerifying = value;
  }

  void onRegisterClick(BuildContext context, bool mounted) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (registerKeyForm.currentState?.validate() ?? false) {
      if (!registerModel.isAcceptedTerms) {
        WidgetUtil.showSnackBar(context, 'Vui lòng chấp nhận điều khoản');
        return;
      }
      setVerifyLoading(true);
      final bool phoneExisting =
          await context.read<AuthCubit>().checkPhoneNumber(registerModel.email);
      if (phoneExisting) {
        if (mounted) {
          WidgetUtil.showSnackBar(context, 'Email đã được sử dụng');
        }
        verifyPhoneNbr = '';
        setVerifyLoading(false);
        return;
      }
      // _sendOTP(AuthAction.verifyRegisterOTP);
    } else {
      WidgetUtil.showSnackBar(
          context, 'Thông tin đăng ký chưa hợp lệ, vui lòng kiểm trả lại');
    }
  }

  void verifyOTP(BuildContext context, bool mounted) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      // verify otp
      if (authAction == AuthAction.verifyResetPwOTP) {
        changeAuthAction(AuthAction.resetPassword);
      } else if (authAction == AuthAction.verifyRegisterOTP) {
        if (!mounted) return;
        context.read<AuthCubit>().doRegister(registerModel);
      }
    } catch (e) {
      LogUtil.error('Verify phone fail: Invalid OTP', error: e);
      WidgetUtil.showSnackBar(context, 'Mã OTP không chính xác!');
    }
  }

  void sendOTP(AuthAction action) {}
}
