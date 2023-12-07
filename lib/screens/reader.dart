import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = false; // Flag para controlar se o download está em andamento
  Dio dio = Dio(); // Objeto para realizar operações de download HTTP
  String filePath = ""; // Caminho do arquivo EPUB baixado

  @override
  void initState() {
    download(); // Método chamado ao iniciar o aplicativo para iniciar o download
    super.initState();
  }

  // Lógica para verificar permissões e iniciar o download
  download() async {
    if (Platform.isAndroid || Platform.isIOS) {
      String? firstPart;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final allInfo = deviceInfo.data;

      // Lógica para extrair a primeira parte da versão do sistema operacional
      if (allInfo['version']["release"].toString().contains(".")) {
        int indexOfFirstDot = allInfo['version']["release"].indexOf(".");
        firstPart = allInfo['version']["release"].substring(0, indexOfFirstDot);
      } else {
        firstPart = allInfo['version']["release"];
      }

      int intValue = int.parse(firstPart!);

      // Verificar a versão do sistema operacional para determinar se é necessário solicitar permissões
      if (intValue >= 13) {
        await startDownload();
      } else {
        if (await Permission.storage.isGranted) {
          await Permission.storage.request();
          await startDownload();
        } else {
          await startDownload();
        }
      }
    } else {
      loading =
          false; // Se não for Android ou iOS, não há download em andamento
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vocsy Plugin E-pub example'),
        ),
        body: Center(
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Downloading.... E-pub'),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print("=====filePath======$filePath");
                        if (filePath == "") {
                          download(); // Iniciar o download se o arquivo EPUB não estiver baixado
                        } else {
                          // Configurações e abertura do EPUB online
                          VocsyEpub.setConfig(
                            themeColor: Theme.of(context).primaryColor,
                            identifier: "iosBook",
                            scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                            allowSharing: true,
                            enableTts: true,
                            nightMode: true,
                          );

                          // Obter o localizador atual
                          VocsyEpub.locatorStream.listen((locator) {
                            print('LOCATOR: $locator');
                          });

                          // Abrir o EPUB online
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
                    ElevatedButton(
                      onPressed: () async {
                        // Configurações e abertura do EPUB local
                        VocsyEpub.setConfig(
                          themeColor: Theme.of(context).primaryColor,
                          identifier: "iosBook",
                          scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                          allowSharing: true,
                          enableTts: true,
                          nightMode: true,
                        );

                        // Obter o localizador atual
                        VocsyEpub.locatorStream.listen((locator) {
                          print('LOCATOR: $locator');
                        });

                        // Abrir o EPUB local
                        await VocsyEpub.openAsset(
                          'assets/4.epub',
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

  // Iniciar o download do EPUB da internet
  // Iniciar o download do EPUB da internet
  startDownload() async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/sample.epub';
    File file = File(path);

    // Se o arquivo EPUB não existir, crie-o e inicie o download
    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        "https://www.gutenberg.org/ebooks/72127.epub.images", // Substitua a URL aqui
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
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }

  // Iniciar o download do EPUB da internet
  // startDownload() async {
  //   Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();

  //   String path = appDocDir!.path + '/sample.epub';
  //   File file = File(path);

  //   // Se o arquivo EPUB não existir, crie-o e inicie o download
  //   if (!File(path).existsSync()) {
  //     await file.create();
  //     await dio.download(
  //       "https://www.gutenberg.org/ebooks/72134.epub3.images",
  //       path,
  //       deleteOnError: true,
  //       onReceiveProgress: (receivedBytes, totalBytes) {
  //         setState(() {
  //           loading = true;
  //         });
  //       },
  //     ).whenComplete(() {
  //       setState(() {
  //         loading = false;
  //         filePath = path;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //       filePath = path;
  //     });
  //   }
  // }
}
