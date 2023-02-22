import 'package:bke/bloc/book/book_event.dart';

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
  static const getYoutubeVideoInfo = '$_baseUrl/videoYoutubeInfo/getOne';

  static const getVocabInfos = '$_baseUrl/vocab';

  static const getAllBooks = '$_baseUrl/BookInfo';
  static const getHomepageList = '$_baseUrl/BookInfo/listCategory';

  static const getContinueReading = '$_baseUrl/bookCheckpoint/getAllEBook';
  static const getContinueListening = '$_baseUrl/bookCheckpoint/getAllAudiobook';
  static const getFavorites = '$_baseUrl/bookFavorites/getAll';

  static const getBookInfo = '$_baseUrl/bookInfo/getOne';

  static const getEbook = '$_baseUrl/bookDetail';
  static const getAudiobook = '$_baseUrl/bookDetail/audio';

  static const updateCkpt = '$_baseUrl/bookCheckpoint/add';

  static const getContinueWatching = '$_baseUrl/videoCheckpoint/getAll';

  static const updateVideoCkpt = '$_baseUrl/videoCheckpoint/add';

  static const addFavorite = '$_baseUrl/bookFavorites/add';
  static const removeFavorite = '$_baseUrl/bookFavorites/delete';
  static const findVocabsByListId = "$_baseUrl/vocab/getListVocab";
  static const getAllFlashcard = '$_baseUrl/flashCard/getAll';
  static const updateFlashcard = '$_baseUrl/flashCard/upsert';
  // {{baseURL}}/api/vocab/getById?vocabId=7154
  static const findVocabById = "$_baseUrl/vocab/getById";
  static const flashcardRandomGetAllThumbnail =
      "$_baseUrl/templateFlashCard/listCategory";
  static const flashcardRandomGetAll = "$_baseUrl/templateFlashCard/random";
}
