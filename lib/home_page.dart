import 'package:bookstore/book_data.dart';
import 'package:bookstore/book_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookStore> booklist = [];
  TextEditingController titleOfBook = TextEditingController();
  TextEditingController nameOfAuthor = TextEditingController();
  TextEditingController urlOfImage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              builder: ((context){
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 280,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleOfBook,
                        decoration: const InputDecoration(
                            hintText: "Book Title",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        controller: nameOfAuthor,
                        decoration: const InputDecoration(
                            hintText: "Book Author",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        controller: urlOfImage,
                        decoration: const InputDecoration(
                            hintText: "Book Cover URL",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height:20,
                      ),
                      Container(
                        width: 300,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0977CB),
                          borderRadius:BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextButton(
                          onPressed: () {
                            BookProvider.instance.insert(BookStore(
                                bookName: titleOfBook.text,
                                author: nameOfAuthor.text,
                                url: urlOfImage.text));
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        },
        elevation: 0,
        backgroundColor: const Color(0xFF0977CB),
        child: const Icon(Icons.add , size: 50,),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0977CB),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Available Books",
          style: TextStyle(
            fontSize: 35,
          ),
        ),
      ),
      body: FutureBuilder<List<BookStore>>(
          future: BookProvider.instance.getAllBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              booklist = snapshot.data!;
              return ListView.builder(
                itemCount: booklist.length,
                itemBuilder: (context, index) {
                  BookStore store = booklist[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        store.bookName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Author: ${store.author}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: ()async {
                          if (store.id != null) {
                            await BookProvider.instance
                                .delete(store.id!);
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete_outline_sharp , size: 40,),
                      ),
                      leading: SizedBox(
                          height: 200,
                          width: 50,
                          child: Image.network(store.url , fit:BoxFit.fill ,)),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }
}
