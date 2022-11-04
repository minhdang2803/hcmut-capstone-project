import '../meta_data.dart';

class BookReader {
  BookReader({required this.bookId, required this.sentences, required this.ckpt});
  
  late final String bookId; 
  List<String> sentences = [];
  // late final MetaDataModel metadata;
  late final int ckpt; //checkpoint page

  BookReader.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    if (json['sentences'] != null) {
      for (var e in (json['sentences'] as List)) {
        sentences.add(e);
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
    ckpt = json["ckpt"];
  }

  toList() {}
}


