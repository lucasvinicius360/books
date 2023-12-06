import 'package:flutter/material.dart';
import '../models/book.dart';
import 'reader_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(book.cover_url),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpubViewerScreen(book: book),
                  ),
                );
              },
              child: Text('Ler Livro'),
            ),
          ],
        ),
      ),
    );
  }
}
