
import '../meta_data.dart';

class BookReader {
  BookReader({required this.ebook, required this.metadata});
  
  late final EbookModel ebook;
  late final MetaDataBook metadata;
   //checkpoint page

  BookReader.fromJson(Map<String, dynamic> json) {
    ebook = EbookModel.fromJson(json['bookDetail']);
   
    metadata = MetaDataBook.fromJson(json['metaData']);
  
  }

  toList() {}
}

class EbookModel{
  late final String bookId; 
  late List<Sentence> sentences = [];
  Map<String, int> chapter = {};
  late final int ckpt;
 
  EbookModel({required this.bookId, required this.sentences});

  EbookModel.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    ckpt = json["checkpoint"];
    if (json['sentences'] != null) {
      final jsonSentences = (json["sentences"] as List).map((s) => Sentence.fromJson(s)).toList();
  
      for (var s in jsonSentences) {
        sentences.add(s);
      }
    }
    if (json['chapter'] != null){
      json['chapter'].forEach((key, value) {
        chapter[key] = value; });
    }
  }
}

class Sentence {
  Sentence({required this.index, required this.text});

  late final int index;
  late final String text;

  Sentence.fromJson(Map<String, dynamic> json) {
    index = json["index"];
    text = json["text"];
  }
}

class ChapterModel{
  late final  Map<String, int> chapter;
  ChapterModel({required this.chapter});

  ChapterModel.fromJson(Map<String, dynamic> json) {
    if (json != null){
      json.forEach((key, value) {
        chapter[key] = value; });
    }
    
  }
  
}


