# Books App

Este é um aplicativo Flutter que permite visualizar livros no formato EPUB. O aplicativo possui funcionalidades como download de livros da internet, abertura de livros online e locais, e uma tela de visualização do caminho do arquivo EPUB (para depuração).

## Conteúdo

1. [Estrutura do Projeto](#estrutura-do-projeto)
2. [Dependências](#dependências)
3. [Como Usar](#como-usar)

## Estrutura do Projeto

O projeto é organizado nas seguintes classes principais:

- **`Book`**: Representa um livro e contém informações como título, URL da capa, ID, autor e URL de download.

- **`BookshelfScreen`**: Tela principal que exibe uma estante de livros. Permite o download e a visualização de detalhes dos livros.

- **`BookDetailsScreen`**: Tela que exibe os detalhes de um livro específico. Permite a abertura do livro em diferentes modos.

- **`EpubViewerScreen`**: Tela dedicada à visualização de livros EPUB. Gerencia o download e a abertura de livros online e locais.

## Dependências

O projeto utiliza as seguintes dependências:

- **`flutter/material`**: Biblioteca principal para desenvolvimento de interfaces do Flutter.
- **`path_provider`**: Fornece métodos para obter caminhos para diretórios especiais no sistema de arquivos.
- **`dio`**: Uma poderosa biblioteca para fazer requisições HTTP.
- **`vocsy_epub_viewer`**: Biblioteca para visualização de livros EPUB.

## Observação

- **`O projeto foi idealizado apenas para as plataformas android e ios`**:

## Como Usar

1. Clone este repositório:

```bash
git clone https://github.com/lucasvinicius360/books.git


2. Navegue até o diretório do projeto:

    * cd epub_viewer_app

3. Instale as dependências:

    * flutter pub get

4. Execute o aplicativo:

    flutter run
`

