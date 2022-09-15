class BookModel {
  final String title;
  final String author;
  final String cover;
  final String year;
  final String pages;
  final int downloads;
  final String description;
  final List<String> genres;
  final double rating;

  BookModel({
    required this.title, 
    required this.author, 
    required this.cover, 
    required this.year, 
    required this.pages, 
    required this.downloads, 
    required this.description, 
    required this.genres, 
    required this.rating});

  factory BookModel.fromJson(Map<String, dynamic> json){
    return BookModel(
      title: json['title'],
      author: json['author'], 
      cover: json['cover'], 
      year: json['year'], 
      pages: json['pages'],
      downloads: json['downloads'], 
      description: json['description'], 
      genres: json['genres'], 
      rating: json['rating']
    );
  }
}
