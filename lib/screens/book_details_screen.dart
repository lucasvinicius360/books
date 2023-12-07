// Importa o pacote flutter/material para utilizar os widgets do Flutter.
import 'package:flutter/material.dart';

// Importa o modelo de livro (Book).
import '../models/book.dart';

// Importa a tela de leitura de livros (ReaderScreen).
import 'reader_screen.dart';

// Classe BookDetailsScreen que representa a tela de detalhes de um livro.
class BookDetailsScreen extends StatelessWidget {
  // Propriedade final que armazena o livro a ser exibido nos detalhes.
  final Book book;

  // Construtor da classe que exige um livro ao criar uma instância.
  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  // Método para construir a interface da tela de detalhes do livro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior (AppBar) com o título sendo o título do livro.
      appBar: AppBar(title: Text(book.title)),
      
      // Corpo da tela, contendo uma coluna de elementos.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exibe a capa do livro como uma imagem da internet.
          Image.network(book.cover_url),
          SizedBox(height: 16.0), // Espaço entre a imagem e os botões
          
          // Linha contendo botões para "Ler Livro" e "Voltar".
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão "Ler Livro" que navega para a tela de leitura (EpubViewerScreen).
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
              SizedBox(width: 8.0), // Espaço entre os botões
              
              // Botão "Voltar" que fecha a tela atual e retorna à tela anterior.
              ElevatedButton(
                onPressed: () {
                  // Ação para o botão "Voltar"
                  Navigator.pop(context);
                },
                child: Text('Voltar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
