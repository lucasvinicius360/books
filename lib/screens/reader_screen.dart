// Importa bibliotecas necessárias para operações de I/O, Flutter, Dio (para downloads),
// e a biblioteca vocsy_epub_viewer para visualização de livros EPUB.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../models/book.dart';

// Classe EpubViewerScreen que representa a tela de visualização de livros EPUB.
class EpubViewerScreen extends StatefulWidget {
  final Book book;

  const EpubViewerScreen({Key? key, required this.book}) : super(key: key);

  @override
  _EpubViewerScreenState createState() => _EpubViewerScreenState();
}

// Classe de estado (_EpubViewerScreenState) associada à EpubViewerScreen.
class _EpubViewerScreenState extends State<EpubViewerScreen> {
  bool loading = false; // Flag para indicar se o download está em andamento.
  String filePath = ""; // Caminho do arquivo EPUB após o download.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Barra superior (AppBar) com título sendo o título do livro.
        appBar: AppBar(
          title: Text(widget.book.title),
          actions: [
            // Ícone de seta para voltar à tela anterior.
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Indicador de progresso durante o download.
                    CircularProgressIndicator(),
                    Text('Downloading.... E-pub'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botões para abrir o livro EPUB online e a partir dos assets.
                    ElevatedButton(
                      onPressed: () async {
                        if (filePath == "") {
                          // Iniciar o download se o arquivo EPUB não estiver baixado.
                          startDownload();
                        } else {
                          // Configurações e abertura do EPUB online.
                          VocsyEpub.setConfig(
                            themeColor: Theme.of(context).primaryColor,
                            identifier: "iosBook",
                            scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                            allowSharing: true,
                            enableTts: true,
                            nightMode: true,
                          );

                          // Obter o localizador atual.
                          VocsyEpub.locatorStream.listen((locator) {
                            print('LOCATOR: $locator');
                          });

                          // Abrir o EPUB online.
                          VocsyEpub.open(
                            filePath,
                            lastLocation: EpubLocator.fromJson({
                              "bookId": "2239",
                              "href": "/OEBPS/ch06.xhtml",
                              "created": 1539934158390,
                              "locations": {
                                "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                              }
                            }),
                          );
                        }
                      },
                      child: Text('Open Online E-pub'),
                    ),

                    SizedBox(width: 8.0),

                    ElevatedButton(
                      onPressed: () async {
                        // Configurações e abertura do EPUB local.
                        VocsyEpub.setConfig(
                          themeColor: Theme.of(context).primaryColor,
                          identifier: "iosBook",
                          scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                          allowSharing: true,
                          enableTts: true,
                          nightMode: true,
                        );

                        // Obter o localizador atual.
                        VocsyEpub.locatorStream.listen((locator) {
                          print('LOCATOR: $locator');
                        });

                        // Abrir o EPUB local.
                        await VocsyEpub.openAsset(
                          filePath,
                          lastLocation: EpubLocator.fromJson({
                            "bookId": "2239",
                            "href": "/OEBPS/ch06.xhtml",
                            "created": 1539934158390,
                            "locations": {
                              "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                            }
                          }),
                        );
                      },
                      child: Text('Open Assets E-pub'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Iniciar o download do EPUB ao inicializar o estado.
    startDownload();
  }

  // Iniciar o download do EPUB da internet.
  startDownload() async {
    // Obter o diretório de armazenamento externo ou de documentos do aplicativo, dependendo da plataforma.
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    // Construir o caminho do arquivo EPUB.
    String path = appDocDir!.path + '/${widget.book.id}.epub';
    File file = File(path);

    // Imprimir informações de depuração sobre o download.
    debugPrintStack(label: '${widget.book.download_url}-------> test ');

    // Se o arquivo EPUB não existir, crie-o e inicie o download.
    if (!file.existsSync()) {
      await file.create();
      await Dio().download(
        "${widget.book.download_url}",
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
          openEpub();
        });
      });
    } else {
      // Se o arquivo já existir, simplesmente abra-o.
      setState(() {
        loading = false;
        filePath = path;
        openEpub();
      });
    }
  }

  // Abrir o livro EPUB.
  void openEpub() {
    if (filePath.isNotEmpty) {
      VocsyEpub.open(filePath);
    }
  }
}

// Widget personalizado para visualização do caminho do arquivo EPUB (para depuração).
class YourEpubViewerWidget extends StatelessWidget {
  final String filePath;

  const YourEpubViewerWidget({Key? key, required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(
          filePath, // Exibindo o caminho do arquivo (para depuração).
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
