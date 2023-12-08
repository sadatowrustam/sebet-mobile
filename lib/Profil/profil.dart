import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/Agza/Agza_bol.dart';
import 'package:sebet/Iceri_gir/Iceri_gir.dart';

import 'package:sebet/Ulanys_duzgunleri/ulanys.dart';
import 'package:sebet/bizBarada/bizBar.dart';
import 'package:sebet/eltip_Ber/eltip_ber.dart';
import 'package:sebet/habarlasmak/habarlasmak.dart';
import 'package:sebet/models/language/Language.dart';

import '../main.dart';

class LogOut extends StatefulWidget {
  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  String AssetLan = '';

  Future<String> get LanguageFile async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }

  Future<File> get LanguageFileCreate async {
    var dosya = await LanguageFile + "/myLanguage.text";
    return File(dosya);
  }

  Future<String> LanguageFileRead() async {
    try {
      var myDosya = await LanguageFileCreate;
      String dosyaIcerik = await myDosya.readAsString();
      return dosyaIcerik;
    } catch (exception) {
      return 'Hata Cikti $exception';
    }
  }

  Future<File> LanguageFileWrite(String yaz) async {
    var myDosya = await LanguageFileCreate;
    return myDosya.writeAsString(yaz);
  }

  Future<String> LanguageCode() async {
    await LanguageFileRead().then((value) {
      AssetLan = value;
    });
    return AssetLan == 'tm'
        ? "assets/language/tk.json"
        : "assets/language/ru.json";
  }

  /*DefaultAssetBundle.of(context).loadString(
        await LanguageFileRead().then((value) {
          return value=='tm' ? "assets/language/tk.json":"assets/language/ru.json";
        }));*/
  /**/
  List<Language> _items = [];
  @override
  Future<Language>? veri;

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      veri = fetchAlbum();
    });
  }

  var allLan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Avenir',
        ),
        debugShowCheckedModeBanner: false,
        title: 'Sebet',
        home: SafeArea(
          child: Scaffold(
              body: FutureBuilder(
                  future: veri,
                  builder: (context, AsyncSnapshot<Language> sonuc) {
                    if (sonuc.hasData) {
                      return ListView(children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                  padding:
                                      EdgeInsets.only(left: 14, bottom: 30),
                                  alignment: Alignment.bottomLeft,
                                  child: SvgPicture.asset(
                                      "assets/logo/Sebet.svg")),
                              InkWell(
                                  child: newprofil(
                                      sonuc.data!.home.agza.toString(),
                                      "assets/icon/addperson.svg"),
                                  onTap: () {
                                    agzaBol();
                                  }),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.home.iceri.toString(),
                                    "assets/icon/Iceri.svg"),
                                onTap: () {
                                  iceriGir();
                                },
                              ),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.gosmaca.dilCalys.toString(),
                                    "assets/icon/dil.svg"),
                                onTap: () {
                                  newDialog(
                                      context, sonuc.data!.gosmaca.dilCalys);
                                },
                              ),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.home.ulanys.toString(),
                                    "assets/icon/2.svg"),
                                onTap: () {
                                  ulanys();
                                },
                              ),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.home.eltip.toString(),
                                    "assets/icon/eltip.svg"),
                                onTap: () {
                                  eltipBer();
                                },
                              ),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.gosmaca.habarlas
                                        .toString()
                                        .toString(),
                                    "assets/icon/habarlas.svg"),
                                onTap: () {
                                  Habarlasmak();
                                },
                              ),
                              InkWell(
                                child: newprofil(
                                    sonuc.data!.home.bizbarada.toString(),
                                    "assets/icon/1.svg"),
                                onTap: () {
                                  bizBara();
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    } else {
                      return Center(
                          child: Container(
                              child: CircularProgressIndicator(
                        color: Colors.red,
                      )));
                    }
                    ;
                  })),
        ),
      ),
    );
  }

  String? url;

  bizBara() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Barada()));
  }

  Habarlasmak() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Habarlas()));
  }

  eltipBer() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Toleg()));
  }

  ulanys() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ulan()));
  }

  agzaBol() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Agza()));
  }

  iceriGir() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Iceri()));
  }

  Language? language;

  Future<Language> fetchAlbum() async {
    await LanguageFileRead().then((value) {
      url = value;
    });
    debugPrint(url.toString());
    var giveJson = await DefaultAssetBundle.of(context).loadString(
        url == "ru" ? "assets/language/ru.json" : "assets/language/tk.json");
    var decodedJson = json.decode(giveJson);
    language = Language.fromJson(decodedJson);

    return language!;
  }

  Future<dynamic> newDialog(BuildContext context, String ady) => showDialog(
      context: context,
      builder: (context) {
        return Container(
          width: 500,
          height: 150,
          child: SimpleDialog(
            titlePadding: EdgeInsets.only(left: 17, top: 16),
            title: Text(ady),
            contentPadding: EdgeInsets.only(left: 17, top: 16, bottom: 32),
            children: [
              SimpleDialogOption(
                child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Turkmençe",
                      style: TextStyle(fontSize: 16),
                    )),
                onPressed: () async {
                  if (url == "tm" || url == null) {
                    Navigator.pop(context);
                  } else {
                    LanguageFileWrite('tm');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp(5)),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Pусский",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (url == "ru") {
                    Navigator.pop(context);
                  } else {
                    LanguageFileWrite('ru');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp(5)),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        );
      });

  Padding newprofil(String ady, String url) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Card(
        elevation: 5,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 15),
                child: SvgPicture.asset(
                  url,
                  width: 24,
                  height: 18,
                ),
              ),
              Text(ady)
            ],
          ),
        ),
      ),
    );
  }
}
