import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';

import 'package:sebet/Sargytlar/sargyt.dart';
import 'package:sebet/Ulanys_duzgunleri/ulanys.dart';
import 'package:sebet/bizBarada/bizBar.dart';
import 'package:sebet/eltip_Ber/eltip_ber.dart';
import 'package:sebet/habarlasmak/habarlasmak.dart';

import 'package:sebet/hasabym/hasabym.dart';

import 'package:sebet/main.dart';
import 'package:sebet/models/language/Language.dart';

class LogInProfil extends StatefulWidget {
  @override
  _LogInProfilState createState() => _LogInProfilState();
}

class _LogInProfilState extends State<LogInProfil> {
  Future<String> get dosyaYoly async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }

  Future<File> get dosyaOlostur async {
    var dosya = await dosyaYoly + "/myDosya.txt";
    return File(dosya);
  }

  Future<String> dosyaOku() async {
    try {
      var myDosya = await dosyaOlostur;
      String dosyaIcerik = await myDosya.readAsString();
      return dosyaIcerik;
    } catch (exception) {
      return 'Hata Cikti $exception';
    }
  }

  Future<File> dosyaYaz(String yaz) async {
    var myDosya = await dosyaOlostur;
    return myDosya.writeAsString(yaz);
  }

  String? url;

  Future<String> get languageFile async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }
  Future<String> get id async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }

  Future<File> get createId async {
    var dosya = await id + "/id.txt";
    return File(dosya);
  }

  Future<String> idread() async {
    try {
      var myDosya = await createId;
      String dosyaIcerik = await myDosya.readAsString();
      return dosyaIcerik;
    } catch (exception) {
      return "false";
    }
  }

  Future<File> idwrite(String yaz) async {
    var myDosya = await createId;
    return myDosya.writeAsString(yaz);
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
    // TODO: implement initState
    super.initState();
    setState(() {
      veri = fetchAlbum();

    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String exit = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Avenir',
        ),
        debugShowCheckedModeBanner: false,
        title: 'Sebet',
        home: Scaffold(
            key: _scaffoldKey,
            body: Container(
              child: FutureBuilder(
                  future: veri,
                  builder: (context, AsyncSnapshot<Language> sonuc) {
                    if (sonuc.hasData) {
                      return Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(
                                  left: 14, top: 10, bottom: 30),
                              alignment: Alignment.bottomLeft,
                              child: SvgPicture.asset("assets/logo/Sebet.svg")),
                          InkWell(
                            child: newprofil(sonuc.data!.accont.hasabym,
                                "assets/icon/Hasabym.svg"),
                            onTap: () {
                              Habar();
                            },
                          ),
                          InkWell(
                            child: newprofil(sonuc.data!.orders.sargyt,
                                "assets/icon/Sebet3.svg"),
                            onTap: () {
                              iceri();
                            },
                          ),
                          InkWell(
                            child: newprofil(sonuc.data!.gosmaca.dilCalys,
                                "assets/icon/dil.svg"),
                            onTap: () {
                              newDialog(context, sonuc.data!.gosmaca.dilCalys);
                            },
                          ),
                          InkWell(
                            child: newprofil(
                                sonuc.data!.home.ulanys.toString() , "assets/icon/2.svg"),
                            onTap: () {
                              ulanys();
                            },
                          ),
                          InkWell(
                            child: newprofil(sonuc.data!.home.eltip.toString(),
                                "assets/icon/eltip.svg"),
                            onTap: () {
                              eltip();
                            },
                          ),
                          InkWell(
                            child: newprofil(sonuc.data!.gosmaca.habarlas,
                                "assets/icon/habarlas.svg"),
                            onTap: () {
                              habar();
                            },
                          ),
                          InkWell(
                            child: newprofil(sonuc.data!.home.bizbarada,
                                "assets/icon/1.svg"),
                            onTap: () {
                              barada();
                            },
                          ),
                          InkWell(
                            onTap: () {
                              showAlertDialog(
                                  context,
                                  sonuc.data!.gosmaca.duydurys,
                                  sonuc.data!.gosmaca.cykmak,
                                  sonuc.data!.perewod.yes,
                                sonuc.data!.perewod.no,);
                              exit = sonuc.data!.gosmaca.cykdynyz;
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 15),
                                          child: Icon(
                                            Icons.exit_to_app_sharp,
                                            size: 20,
                                          )),
                                      Text(sonuc.data!.perewod.deleteAcou)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: Container(
                              child: CircularProgressIndicator(
                        color: Colors.red,
                      )));
                    }
                  }),
            )),
      ),
    );
  }
  ulanys(){
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) => Ulan()));
  }
  Habar() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Hasabym()));
  }

  iceri() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Sargyt()));
  }

  eltip() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Toleg()));
  }

  habar() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Habarlas()));
  }

  barada() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Barada()));
  }

  Future<dynamic> newDialog(BuildContext context, String changeLang) =>
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              width: 500,
              height: 150,
              child: SimpleDialog(
                titlePadding: EdgeInsets.only(left: 17, top: 16),
                title: Text(
                  changeLang,
                  style: TextStyle(fontSize: 20),
                ),
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
                      languageFileWrite('tm');
                      if (url == "tm" || url == null) {
                        Navigator.of(context).pop();
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp(5)),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  SimpleDialogOption(
                    child: Text(
                      "Pусский",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      debugPrint(url);
                      if (url == "ru") {
                        Navigator.of(context).pop();
                      }
                      languageFileWrite('ru');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp(5)),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            );
          });
  void _showToastEdit(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("${exit}"),
      ),
    );
  }

  void showAlertDialog(
      context, String duydur, String text, String yes, String no) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              duydur,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 16),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 14, left: 12),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                    child: Text(
                                      no,
                                      style: TextStyle(fontSize: 16),
                                    ))),
                            InkWell(
                                onTap: () {
                                  _showToastEdit(context);
                                  dosyaYaz(false.toString());
                                  idwrite(false.toString());
                                  yzyCyk();
                                },
                                child: Container(
                                    child: Text(
                                  yes,
                                  style: TextStyle(fontSize: 16),
                                )))
                          ],
                        )),
                  )
                ],
              ),
            ],
          );
        });
  }

  yzyCyk() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp(5)),
      (Route<dynamic> route) => false,
    );
  }

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
