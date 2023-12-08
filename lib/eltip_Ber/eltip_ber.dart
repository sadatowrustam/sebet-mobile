import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/models/language/Language.dart';

class Toleg extends StatefulWidget {
  const Toleg({Key? key}) : super(key: key);

  @override
  _TolegState createState() => _TolegState();
}

class _TolegState extends State<Toleg> {
  String? url;

  Future<String> get languageFile async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }

  Future<File> get languageFileCreate async {
    var dosya = await languageFile + "/myLanguage.text";
    return File(dosya);
  }

  Future<String> languageFileRead() async {
    try {
      var myDosya = await languageFileCreate;
      String dosyaIcerik = await myDosya.readAsString();
      return dosyaIcerik;
    } catch (exception) {
      return 'Hata Cikti $exception';
    }
  }

  Future<File> languageFileWrite(String yaz) async {
    var myDosya = await languageFileCreate;
    return myDosya.writeAsString(yaz);
  }

  Language? language;

  Future<Language> fetchAlbum() async {
    await languageFileRead().then((value) {
      url = value;
    });
    debugPrint(url.toString());
    var giveJson = await DefaultAssetBundle.of(context).loadString(
        url == "ru" ? "assets/language/ru.json" : "assets/language/tk.json");
    var decodedJson = json.decode(giveJson);
    language = Language.fromJson(decodedJson);

    return language!;
  }

  Future<Language>? veri;

  void initState() {
    super.initState();
    setState(() {
      veri = fetchAlbum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Avenir',
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
              future: veri,
              builder: (context, AsyncSnapshot<Language> sonuc) {
                if (sonuc.hasData) {
                  return ListView(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              yzaCyk();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20, left: 14),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icon/left.svg"),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Text(
                                      sonuc.data!.gosmaca.bermek,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 14, top: 32),
                            child: Text(
                              sonuc.data!.gosmaca.bermek,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 14, top: 32, right: 14),
                            child: Text(
                              sonuc.data!.eltipBer,
                              style: TextStyle(fontSize: 16, wordSpacing: 3),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  yzaCyk() {
    Navigator.pop(context);
  }
}
