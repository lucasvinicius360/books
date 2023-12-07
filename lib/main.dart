// Importa o pacote flutter/material, que contém os widgets e recursos
// necessários para construir interfaces do usuário no Flutter.
import 'package:flutter/material.dart';

// Importa o arquivo bookshelf_screen.dart que contém a definição da tela da estante de livros.
import 'screens/bookshelf_screen.dart';

// Função principal que inicia a execução do aplicativo Flutter.
void main() {
  // Executa o aplicativo envolvendo-o com o widget MyApp.
  runApp(MyApp());
}

// Classe MyApp que representa o aplicativo Flutter.
class MyApp extends StatelessWidget {
  // Método obrigatório para construir a interface do usuário.
  @override
  Widget build(BuildContext context) {
    // Retorna um MaterialApp, que é o widget principal para aplicativos Flutter.
    return MaterialApp(
      // Define o título do aplicativo exibido na barra de título.
      title: 'Leitor de eBooks',

      // Define o tema do aplicativo, neste caso, com uma cor primária azul.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Define a tela inicial do aplicativo como BookshelfScreen.
      home: BookshelfScreen(),
    );
  }
}
