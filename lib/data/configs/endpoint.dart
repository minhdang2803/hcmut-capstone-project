class EndPoint {
  static const _baseUrl = 'https://bkenglish-9ec8e.et.r.appspot.com/api';
  static const loginPath = '$_baseUrl/user/login';
  static const registerPath = '$_baseUrl/user/createUser';
  static const gmailVerifyPath = '$_baseUrl/user/gmailVerify';
  static const checkGmailVerifyPath = '$_baseUrl/user/checkGmailVerify';
  static const resetPassPath = '$_baseUrl/user/resetPassword';
  // static const getToeicP1Path = '$_baseUrl/toeicP1/getToeicP1';
  // static const saveScoreToeicP1Path = '$_baseUrl/scoreToeicP1/saveScoreToeicP1';

  //Video
  static const getSubVideo = '$_baseUrl/subVideo';
  static const getYoutubeVideoInfos = '$_baseUrl/videoYoutubeInfo';
  static const getYoutubeVideoInfo = '$_baseUrl/videoYoutubeInfo/getOne';
  static const updateCkpt = '$_baseUrl/bookCheckpoint/add';
  static const getContinueWatching = '$_baseUrl/videoCheckpoint/getAll';
  static const updateVideoCkpt = '$_baseUrl/videoCheckpoint/add';

  //Book
  static const getAllBooks = '$_baseUrl/BookInfo';
  static const getHomepageList = '$_baseUrl/BookInfo/listCategory';
  static const getContinueReading = '$_baseUrl/bookCheckpoint/getAllEBook';
  static const getContinueListening =
      '$_baseUrl/bookCheckpoint/getAllAudiobook';
  static const getFavorites = '$_baseUrl/bookFavorites/getAll';
  static const getBookInfo = '$_baseUrl/bookInfo/getOne';
  static const getEbook = '$_baseUrl/bookDetail';
  static const getAudiobook = '$_baseUrl/bookDetail/audio';
  static const addFavorite = '$_baseUrl/bookFavorites/add';
  static const removeFavorite = '$_baseUrl/bookFavorites/delete';

  //Vocab
  static const findVocabsByListId = "$_baseUrl/vocab/getListVocab";
  static const getVocabInfos = '$_baseUrl/vocab';

  //Flashcard
  static const getAllFlashcard = '$_baseUrl/flashCard/getAll';
  static const updateFlashcard = '$_baseUrl/flashCard/upsert';
  // {{baseURL}}/api/vocab/getById?vocabId=7154
  static const findVocabById = "$_baseUrl/vocab/getById";
  static const flashcardRandomGetAllThumbnail =
      "$_baseUrl/templateFlashCard/listCategory";
  static const flashcardRandomGetAll = "$_baseUrl/templateFlashCard/random";

  // Quiz
  static const getMultipleChoiceQuiz = "$_baseUrl/quizVocab/level";
  static const upsertResultBylevel = "$_baseUrl/userQuizScore/upsert";
  static const getUserQuizResult = "$_baseUrl/userQuizScore/getAll";

  //Toeic
  static const getPart = "$_baseUrl/toeic/practice";

  // calendar
  static const getHistoryActivities =
      "$_baseUrl/historyActivities/getByYearMonth";
}
