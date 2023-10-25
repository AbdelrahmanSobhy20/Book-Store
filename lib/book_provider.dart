import 'package:bookstore/book_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String bookTable = 'booktable';
const String columnId = '_id';
const String columnBookName = 'bookname';
const String columnAuthor = 'author';
const String columnURL = 'url';

class BookProvider {
  late Database db;
  static final BookProvider instance = BookProvider._internal();
  factory BookProvider() {
    return instance;
  }
  BookProvider._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'bookstore.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $bookTable ( 
  $columnId integer primary key autoincrement, 
  $columnBookName text not null,
  $columnAuthor text not null,
  $columnURL text not null)
''');
    });
  }

  Future<List<BookStore>> getAllBooks() async {
    List<Map<String, dynamic>> bookMaps = await db.query(bookTable);
    if (bookMaps.isEmpty) {
      return [];
    } else {
      List<BookStore> books = [];
      for (var element in bookMaps) {
        books.add(BookStore.fromMap(element));
      }
      return books;
    }
  }

  Future<BookStore> insert(BookStore store) async {
    store.id = await db.insert(bookTable, store.toMap());
    return store;
  }

  Future<int> delete(int id) async {
    return await db.delete(bookTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(BookStore store) async {
    return await db.update(bookTable, store.toMap(),
        where: '$columnId = ?', whereArgs: [store.id]);
  }

  Future close() async => db.close();
}
