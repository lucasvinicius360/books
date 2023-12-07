// Classe Book que representa um livro.
class Book {
  // Atributos finais que representam as propriedades de um livro.
  // Eles são marcados como 'final' porque seus valores não podem ser alterados após a inicialização.
  
  // Título do livro.
  final String title;
  
  // URL da capa do livro.
  final String cover_url;
  
  // Identificador único do livro.
  final int id;
  
  // Autor do livro.
  final String author;
  
  // URL para download ou acesso ao conteúdo do livro.
  final String download_url;

  // Construtor da classe Book, que exige valores para todos os atributos ao criar uma instância.
  Book({
    required this.title,
    required this.cover_url,
    required this.id,
    required this.author,
    required this.download_url,
  });
}
