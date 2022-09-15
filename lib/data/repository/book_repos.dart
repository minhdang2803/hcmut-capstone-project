import '../../models/book_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class BookRepos{ 
  String endpoint = 'assets/books.json/';
  Future<List<BookModel>> getBooks() async{
    final String response = await rootBundle.loadString(endpoint);
    final data = await json.decode(response);
    return data.map((e)=>BookModel.fromJson(e)).toList();
  }
}
List<BookModel> allBooks = [
  BookModel(
        title: "The Adventures of Sherlock Holmes",
        author: "Arthur Conan Doyle",
        cover: "https://manybooks.net/sites/default/files/styles/220x330sc/public/old-covers/cover-orig-2305.jpg?itok=fKkqXRnW",
        year: "1892",
        pages: "236",
        downloads: 570963,
        description: "A delight for a public which enjoys incident, mystery, and above all that matching of the wits of a clever man against the dumb resistance of the secrecy of inanimate things, which results in the triumph of the human intelligence.",
        genres: [
            "BANNED BOOKS",
            "FICTION AND LITERATURE",
            "MYSTERY/DETECTIVE",
            "SHORT STORY COLLECTION"
        ],
        rating: 0
  ),
  BookModel(
        title: "Pride and Prejudice",
        author: "Jane Austen",
        cover: "https://manybooks.net/sites/default/files/styles/220x330sc/public/old-covers/cover-cust-699.jpg?itok=YMpHxFDI",
        year: "1813",
        pages: "311",
        downloads: 366008,
        description: "Austen's finest comedy of manners portrays life in the genteel rural society of the early 1800s, and tells of the initial misunderstandings (and mutual enlightenment) between lively and quick witted Elizabeth Bennet and the haughty Mr. Darcy.",
        genres: [
            "FICTION AND LITERATURE",
            "HARVARD CLASSICS",
            "ROMANCE"
        ],
        rating: 0
  ),
  BookModel(
        title: "Emma",
        author: "Jane Austen",
        cover: "https://manybooks.net/sites/default/files/styles/220x330sc/public/old-covers/cover-cust-693.jpg?itok=GUgOTN8v",
        year: "1815",
        pages: "380",
        downloads: 269346,
        description: "The main character, Emma Woodhouse, is described in the opening paragraph as ''handsome, clever, and rich'' but is also rather spoiled. As a result of the recent marriage of her former governess, Emma prides herself on her ability to matchmake, and proceeds to take under her wing an illegitimate orphan, Harriet Smith, whom she hopes to marry off to the vicar, Mr Elton. So confident is she that she persuades Harriet to reject a proposal from a young farmer who is a much more suitable partner for the girl.",
        genres: [
            "FICTION AND LITERATURE",
            "ROMANCE",
            "HUMOR"
        ],
        rating: 0
  ),
  BookModel(
        title: "The Call of Cthulhu",
        author: "H. P. Lovecraft",
        cover: "https://manybooks.net/sites/default/files/styles/220x330sc/public/old-covers/cover-cust-13095.jpg?itok=H0c1QL8Y",
        year: "1926",
        pages: "28",
        downloads: 215544,
        description: "Three independent narratives linked together by the device of a narrator discovering notes left by a deceased relative. Piecing together the whole truth and disturbing significance of the information he possesses, the narrator's final line is ''The most merciful thing in the world, I think, is the inability of the human mind to correlate all its contents.''",
        genres: [
            "HORROR",
            "SHORT STORY"
        ],
        rating: 0
  ),
  BookModel(
        title: "The Count of Monte Cristo",
        author: "Alexandre Dumas",
        cover: "https://manybooks.net/sites/default/files/styles/220x330sc/public/old-covers/cover-cust-2356.jpg?itok=NsH-dAJf",
        year: "1845",
        pages: "1424",
        downloads: 195067,
        description: "A classic adventure novel, often considered Dumas' best work, and frequently included on lists of the best novels of all time. Completed in 1844, and released as an 18-part series over the next two years, Dumas collaborated with other authors throughout. The story takes place in France, Italy, and the Mediterranean from the end of the rule of Napoleon I through the reign of Louis-Philippe.",
        genres: [
            "ADVENTURE",
            "FICTION AND LITERATURE",
            "HISTORY",
            "PIRATE TALES"
        ],
        rating: 0
  )
];

