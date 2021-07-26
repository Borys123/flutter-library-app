import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'entities/book.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'book_view.dart';
import 'file_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteka',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Biblioteka', storage: FileStorage()),
      routes: {
        BookViewState.routeName: (context) => BookView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FileStorage storage;

  MyHomePage({Key key, @required this.storage, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  List<Book> _books = List<Book>();
  List<Book> _duplicateBooks = List<Book>();
  List<String> _dropDowns = ["Tytuł", "Autor"];
  String _selectedDropDown = "Tytuł";

  Future<File> writeBooks() async {
    var url =
        'https://raw.githubusercontent.com/Borys123/bibliotekaflutter/main/lista.json';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      widget.storage.writeFile(response.body);
    }
  }

  Future<List<Book>> fetchBooks() async {
    try {
      await writeBooks();
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "Brak internetu, używanie ostatniej znanej wersji",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
    String booksNotFetched = await widget.storage.readFile();
    var books = List<Book>();
    if (booksNotFetched != '') {
      var booksJson = json.decode(booksNotFetched);
      for (var bookJson in booksJson) {
        books.add(Book.fromJson(bookJson));
      }
      return books;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks().then((value) {
      setState(() {
        _books.addAll(value);
        _duplicateBooks.addAll(value);
        sortBooks(_selectedDropDown);
      });
    });
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase().contains(string2?.toLowerCase());
  }

  void filterSearchResults(String query) {
    List<Book> dummySearchList = List<Book>();
    dummySearchList.addAll(_duplicateBooks);
    if (query.isNotEmpty) {
      List<Book> dummyListData = List<Book>();
      dummySearchList.forEach((item) {
        if (equalsIgnoreCase(item.tytul, query)) {
          dummyListData.add(item);
        } else if (equalsIgnoreCase(item.autor, query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _books.clear();
        _books.addAll(dummyListData);
        sortBooks(_selectedDropDown);
      });
      return;
    } else {
      setState(() {
        _books.clear();
        _books.addAll(_duplicateBooks);
        sortBooks(_selectedDropDown);
      });
    }
  }

  void sortBooks(String option) {
    if (option == "Tytuł") {
      setState(() {
        _books.sort((a, b) => a.tytul.compareTo(b.tytul));
        _duplicateBooks.sort((a, b) => a.tytul.compareTo(b.tytul));
      });
    } else if (option == "Autor") {
      setState(() {
        _books.sort(
            (a, b) => a.autor.split(' ')[1].compareTo(b.autor.split(' ')[1]));
        _duplicateBooks.sort(
            (a, b) => a.autor.split(' ')[1].compareTo(b.autor.split(' ')[1]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Szukaj",
                    hintText: "Szukaj",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                hint: Text("Sortowanie"),
                value: _selectedDropDown,
                onChanged: (value) {
                  setState(() {
                    _selectedDropDown = value;
                  });
                  sortBooks(value);
                },
                items: _dropDowns.map((dropDown) {
                  return DropdownMenuItem(
                    child: new Text(dropDown),
                    value: dropDown,
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          BookViewState.routeName,
                          arguments: <String>[
                            _books[index].indeks,
                            _books[index].tytul,
                            _books[index].autor,
                            _books[index].gatunek,
                            _books[index].opis,
                            _books[index].rok,
                            _books[index].jezyk,
                            _books[index].stron,
                            _books[index].wydawnictwo,
                            _books[index].oprawa,
                            _books[index].wydanie,
                            _books[index].zdjecie
                          ],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_books[index].tytul),
                            Text(_books[index].autor),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
