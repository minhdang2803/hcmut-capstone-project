class EndPoint {
  static const _baseUrl = 'https://bkenglish-9ec8e.et.r.appspot.com/api';
  static const loginPath = '$_baseUrl/user/login';
  static const registerPath = '$_baseUrl/user/createUser';
  static const gmailVerifyPath = '$_baseUrl/user/gmailVerify';
  static const checkGmailVerifyPath = '$_baseUrl/user/checkGmailVerify';
  static const resetPassPath = '$_baseUrl/user/resetPassword';

  static const gamePath =
      'https://mocki.io/v1/2aba0527-2609-49d8-87b7-76a088b57877';

  static const getToeicP1Path = '$_baseUrl/toeicP1/getToeicP1';
  static const saveScoreToeicP1Path = '$_baseUrl/scoreToeicP1/saveScoreToeicP1';

  static const getSubVideo = '$_baseUrl/subVideo';
  static const getYoutubeVideoInfos = '$_baseUrl/videoYoutubeInfo';

  static const getVocabInfos = '$_baseUrl/vocab';

  static const getAllBooks = '$_baseUrl/BookInfo';
  static const getBookInfo = '$_baseUrl/bookInfo/getOne';

  static const getEbook = '$_baseUrl/bookDetail';
}
