class EndPoint {
  static const String baseUrl = 'https://bke200701.herokuapp.com/api/v1/';
  static const String loginWithPhoneOrEmail =
      'https://bkenglish-9ec8e.et.r.appspot.com/api/user/login';
  static const String registerWithPhoneOrEmail =
      'https://bkenglish-9ec8e.et.r.appspot.com/api/user/createUser';
  static const String loginWithGoogle = '${baseUrl}users/loginWithGoogle';
  static const String loginWithFacebook = '${baseUrl}users/loginWithFacebook';

  //quizzes
  static const String quizzLevelOne = '${baseUrl}exams';
}
