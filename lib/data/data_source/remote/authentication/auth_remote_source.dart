import '../../../../utils/log_util.dart';
import '../../../configs/endpoint.dart';
import '../../../models/authentication/login_model.dart';
import '../../../models/authentication/register_model.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../services/api_service.dart';

abstract class AuthRemoteSource {
  // Future<BaseResponse<User>> loginWithGoogle();

  // Future<BaseResponse<User>> loginWithFacebook();

  // Future<BaseResponse<User>> loginWithApple();

  Future<BaseResponse<LoginModel>> login(String email, String password);

  Future<BaseResponse<LoginModel>> register(RegisterModel registerModel);

  Future<BaseResponse> gmailVerify(String email);

  Future<BaseResponse<Authorization>> checkGmailVerify(
      String email, String otpCode);

  Future<BaseResponse<LoginModel>> resetPass(
      String token, String email, String password);
}

class AuthRemoteSourceImpl extends AuthRemoteSource {
  final APIService _api = APIService.instance();

  // @override
  // Future<BaseResponse<User>> loginWithGoogle() async {
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn(
  //       scopes: [
  //         'email',
  //         'https://www.googleapis.com/auth/userinfo.profile',
  //       ],
  //     );
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     final base64Img =
  //         await ImageUtil.networkImageToBase64(googleUser!.photoUrl);
  //     final bodyRequest = LoginModel(
  //       id: googleUser.id,
  //       fullName: googleUser.displayName,
  //       email: googleUser.email,
  //       photoUrl: base64Img,
  //     ).toMap();
  //     final loginRequest = APIServiceRequest(
  //       EndPoint.loginPath,
  //       dataBody: bodyRequest,
  //       (response) => BaseResponse<User>.fromJson(
  //           json: response, dataBuilder: User.fromJson),
  //     );
  //     LogUtil.debug('Google login: $bodyRequest');
  //     return _api.post(loginRequest);
  //   } catch (e) {
  //     LogUtil.error('Google authentication failed: $e');
  //     return Future.error(e);
  //   }
  // }

  // @override
  // Future<BaseResponse<User>> loginWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       final userData = await FacebookAuth.instance.getUserData();
  //       final String? profileImageUrl = userData['picture']?['data']?['url'];
  //       final base64Img = await ImageUtil.networkImageToBase64(profileImageUrl);
  //       final bodyRequest = LoginModel(
  //         id: accessToken.userId,
  //         fullName: userData['fullName'],
  //         email: userData['email'],
  //         photoUrl: base64Img,
  //       ).toMap();
  //       final loginRequest = APIServiceRequest(
  //         EndPoint.loginPath,
  //         dataBody: bodyRequest,
  //         (response) => BaseResponse<User>.fromJson(
  //             json: response, dataBuilder: User.fromJson),
  //       );
  //       LogUtil.debug('Facebook login: $bodyRequest');
  //       return _api.post(loginRequest);
  //     } else {
  //       return Future.error('Facebook authentication failed: ${result.status}');
  //     }
  //   } catch (e) {
  //     LogUtil.error('Facebook authentication failed: $e');
  //     return Future.error(e);
  //   }
  // }

  // @override
  // Future<BaseResponse<User>> loginWithApple() async {

  //   throw UnimplementedError();
  // }

  @override
  Future<BaseResponse<LoginModel>> login(String email, String password) async {
    const path = EndPoint.loginPath;
    final bodyRequest = {'email': email.toLowerCase(), 'password': password};
    final request = APIServiceRequest(
      path,
      dataBody: bodyRequest,
      (response) => BaseResponse<LoginModel>.fromJson(
          json: response, dataBuilder: LoginModel.fromJson),
    );
    LogUtil.debug('Login: $bodyRequest');
    return _api.post(request);
  }

  @override
  Future<BaseResponse<LoginModel>> register(RegisterModel registerModel) {
    const path = EndPoint.registerPath;
    final bodyRequest = registerModel.toMap();
    final request = APIServiceRequest(
      path,
      dataBody: bodyRequest,
      (response) => BaseResponse<LoginModel>.fromJson(
          json: response, dataBuilder: LoginModel.fromJson),
    );
    LogUtil.debug('Register: $bodyRequest');
    return _api.post(request);
  }

  @override
  Future<BaseResponse> gmailVerify(String email) {
    const path = EndPoint.gmailVerifyPath;
    final bodyRequest = {'email': email};
    final request = APIServiceRequest(
      path,
      dataBody: bodyRequest,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );
    LogUtil.debug('Check email: $bodyRequest');
    return _api.post(request);
  }

  @override
  Future<BaseResponse<Authorization>> checkGmailVerify(
      String email, String otpCode) {
    const path = EndPoint.checkGmailVerifyPath;
    final bodyRequest = {'email': email, 'otpCode': otpCode};
    final request = APIServiceRequest(
      path,
      dataBody: bodyRequest,
      (response) => BaseResponse<Authorization>.fromJson(
          json: response, dataBuilder: Authorization.fromJson),
    );
    LogUtil.debug('Check email verify: $bodyRequest');
    return _api.post(request);
  }

  @override
  Future<BaseResponse<LoginModel>> resetPass(
      String token, String email, String password) async {
    const path = EndPoint.resetPassPath;
    final bodyRequest = {'email': email, 'password': password};
    final header = {'Authorization': 'Bearer $token'};
    final request = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) => BaseResponse<LoginModel>.fromJson(
          json: response, dataBuilder: LoginModel.fromJson),
    );
    LogUtil.debug('Reset pass: $bodyRequest');
    return _api.post(request);
  }
}
