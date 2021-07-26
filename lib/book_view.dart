import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookViewArguments {
  final String indeks,
      tytul,
      autor,
      gatunek,
      opis,
      rok,
      jezyk,
      stron,
      wydawnictwo,
      oprawa,
      wydanie,
      zdjecie;
  BookViewArguments(
      this.indeks,
      this.tytul,
      this.autor,
      this.gatunek,
      this.opis,
      this.rok,
      this.jezyk,
      this.stron,
      this.wydawnictwo,
      this.oprawa,
      this.wydanie,
      this.zdjecie);
}

class BookView extends StatefulWidget {
  @override
  BookViewState createState() => BookViewState();
}

class BookViewState extends State<BookView> {
  static const routeName = '/bookView';

  String subTitle(int index) {
    switch (index) {
      case 1:
        {
          return "Tytuł: ";
        }
        break;
      case 2:
        {
          return "Autor: ";
        }
        break;
      case 3:
        {
          return "Gatunek: ";
        }
        break;
      case 4:
        {
          return "Opis: ";
        }
        break;
      case 5:
        {
          return "Rok pierwszego wydania: ";
        }
        break;
      case 6:
        {
          return "Język: ";
        }
        break;
      case 7:
        {
          return "Ilość stron: ";
        }
        break;
      case 8:
        {
          return "Wydawnictwo: ";
        }
        break;
      case 9:
        {
          return "Oprawa: ";
        }
        break;
      case 10:
        {
          return "Wydanie: ";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args[1]),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: args.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          //Image.network(args[args.length - 1])
                          CachedNetworkImage(
                            imageUrl: args[args.length - 1],
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ],
                      ),
                    );
                  } else if (index != args.length - 1)
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(subTitle(index)),
                            ExpandableText(
                              text: args[index],
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    );
                  else
                    return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({Key key, this.maxLines, this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Text(
          widget.text,
          overflow: TextOverflow.fade,
          maxLines: _isExpanded ? null : widget.maxLines,
        ),
      );
}
