class EndPoint {
  static const String baseUrl = 'https://bke200701.herokuapp.com/api/v1/';
  static const String loginWithPhoneOrEmail =
      '${baseUrl}users/loginWithEmailorPhone';
  static const String registerWithPhoneOrEmail = '${baseUrl}users/register';
  static const String loginWithGoogle = '${baseUrl}users/loginWithGoogle';
  //https://bke200701.herokuapp.com/api/v1/users/loginWithGoogle
  static const String loginWithFacebook = '${baseUrl}users/loginWithFacebook';
}
