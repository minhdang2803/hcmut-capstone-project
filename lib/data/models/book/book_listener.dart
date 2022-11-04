class BookListener {
  BookListener ({required this.bookId, required this.ckpt});
  late final String bookId;
  late final int ckpt; //checkpoint in seconds

  BookListener.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    ckpt = json["ckpt"];
  }
}

class BookListenArguments{
  BookListenArguments(this.bookId, this.title, this.coverUrl, this.mp3Url);
  final String bookId;
  final String title;
  final String coverUrl;
  final String mp3Url;
}
