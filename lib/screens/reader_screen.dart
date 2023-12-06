import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../models/book.dart';

class EpubViewerScreen extends StatelessWidget {
  final Book book;

  const EpubViewerScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        // Utilize o método para abrir o livro EPUB
        future: openEpubBook(book.download_url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Use o widget fornecido pelo pacote para exibir o conteúdo do livro
            return YourEpubViewerWidget(epubContent: snapshot.data);
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Método para abrir o livro EPUB
  Future<dynamic> openEpubBook(String epubUrl) async {
    try {
      return await VocsyEpub.openAsset(epubUrl);
    } catch (e) {
      // Lidar com possíveis erros ao abrir o livro EPUB
      throw Exception('Erro ao abrir o livro EPUB: $e');
    }
  }
}

class YourEpubViewerWidget extends StatelessWidget {
  final dynamic epubContent;

  const YourEpubViewerWidget({Key? key, required this.epubContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Acessa o conteúdo do livro EPUB e exibe o texto das páginas
    List<String> pages = extractPagesContent(epubContent);

    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(pages[index]),
        );
      },
    );
  }

  // Método para extrair o conteúdo das páginas do livro EPUB
  List<String> extractPagesContent(dynamic epubContent) {
    // Lógica para extrair o conteúdo do livro. Adaptar conforme necessário.
    // Este é apenas um exemplo, a estrutura real depende do pacote usado.
    // Substitua esta lógica com base na documentação do pacote.

    List<String> pages = [];

    if (epubContent != null) {
      // Exemplo: Supondo que o conteúdo do EPUB é uma lista de páginas.
      for (var page in epubContent.pages) {
        pages.add(page.text);
      }
    }

    return pages;
  }
}

