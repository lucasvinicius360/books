// Importa o pacote flutter/material para utilizar os widgets do Flutter.
import 'package:flutter/material.dart';

// Importa o modelo de livro (Book) e o serviço de API (ApiService).
import '../models/book.dart';
import '../services/api_service.dart';

// Importa a tela de detalhes do livro (BookDetailsScreen).
import 'book_details_screen.dart';

// Classe BookshelfScreen que representa a tela principal da estante de livros.
class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

// Classe de estado (_BookshelfScreenState) associada à BookshelfScreen.
class _BookshelfScreenState extends State<BookshelfScreen> {
  // Declara uma variável Future para armazenar a lista de livros.
  late Future<List<Book>> _books;

  // Método chamado quando o estado é inicializado.
  @override
  void initState() {
    super.initState();
    // Inicializa a variável _books chamando o método fetchBooks da ApiService.
    _books = ApiService.fetchBooks();
  }

  // Método para construir a interface da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior (AppBar) com título centralizado.
      appBar: AppBar(centerTitle: true, title: Text('Estante de Livros')),
      body: FutureBuilder<List<Book>>(
        // Utiliza o FutureBuilder para lidar com o carregamento assíncrono dos livros.
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se os dados ainda estão sendo carregados, exibe um indicador de progresso.
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Se ocorrer um erro durante o carregamento, exibe uma mensagem de erro.
            return Text('Erro: ${snapshot.error}');
          } else {
            // Se os dados foram carregados com sucesso, exibe a grade de livros.
            final books = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  // Adiciona um GestureDetector para lidar com toques nos livros.
                  onTap: () {
                    // Navega para a tela de detalhes do livro ao ser tocado.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        // Exibe a capa do livro como uma imagem da internet.
                        Image.network(
                          book.cover_url,
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10.0), // Espaço entre a imagem e o título.
                        Text(
                          // Exibe o título do livro centrado.
                          book.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
