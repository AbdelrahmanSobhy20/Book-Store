import 'book_provider.dart';

class BookStore {
  int? id;
  late String bookName;
  late String author;
  late String url;

  BookStore({
  this.id,
  required this.bookName,
  required this.author,
  required this.url,
  });

  BookStore.fromMap(Map<String , dynamic> map){
  if (map[columnId] != null) id = map[columnId];
  bookName = map[columnBookName];
  author = map[columnAuthor];
  url = map[columnURL];
  }

  Map <String , dynamic >toMap(){
  Map<String , dynamic> map ={};
  if (id != null ) map[columnId]= id;
  map[columnBookName] = bookName;
  map[columnAuthor] = author;
  map[columnURL]= url;
  return map;
  }
  }
