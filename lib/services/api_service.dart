// Importa a biblioteca 'dart:convert' para utilizar funcionalidades de codificação e decodificação JSON.
import 'dart:convert';

// Importa a biblioteca 'http' e a renomeia para 'http' para facilitar o acesso aos recursos dessa biblioteca.
import 'package:http/http.dart' as http;

// Importa o modelo de dados 'Book' que parece ser definido em algum outro lugar do código.
import '../models/book.dart';

// Classe que contém métodos para interagir com uma API e obter informações sobre livros.
class ApiService {
  // Método estático assíncrono que retorna uma lista de livros no futuro.
  static Future<List<Book>> fetchBooks() async {
    // Faz uma requisição HTTP GET para a URL fornecida.
    final response = await http.get(Uri.parse('https://escribo.com/books.json'));

    // Verifica se o código de status da resposta é 200 (OK).
    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta JSON em uma lista dinâmica.
      final List<dynamic> data = json.decode(response.body);

      // Mapeia a lista dinâmica para uma lista de objetos 'Book' usando construtores apropriados.
      return data
          .map((json) => Book(
                title: json['title'],
                cover_url: json['cover_url'],
                id: json['id'],
                author: json['author'],
                download_url: json['download_url'],
              ))
          .toList();
    } else {
      // Se o código de status não for 200, lança uma exceção indicando falha ao carregar livros.
      throw Exception('Falha ao carregar livros');
    }
  }
}
