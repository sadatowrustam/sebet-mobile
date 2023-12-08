import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/hasabym/chancePassword.dart';
import 'package:sebet/models/Hasabym/DecodHasap.dart';
import 'package:sebet/models/Hasabym/Patch.dart';
import 'package:sebet/models/language/Language.dart';
import '../IpAddress.dart';
import '../main.dart';

class Hasabym extends StatefulWidget {
  const Hasabym({Key? key}) : super(key: key);

  @override
  _HasabymState createState() => _HasabymState();
}

class _HasabymState extends State<Hasabym> {
  Future<DecodHasap>? veri;

  Future<String> get tokenDosyaYolu async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
  }

  Future<File> get tokenDosyaOlustur async {
    var dosya = await tokenDosyaYolu + "/Token.txt";
    return File(dosya);
  }

  Future<String> tokenDosyaOku() async {
    try {
      var myDosya = await tokenDosyaOlustur;
      String dosyaIcerik = await myDosya.readAsString();
      return dosyaIcerik;
    } catch (exception) {
      return 'Hata Cikti $exception';
    }
  }

  Future<File> tokenDosyaYaz(String yaz) async {
    var myDosya = await tokenDosyaOlustur;
    return myDosya.writeAsString(yaz);
  }

  String token = '';

  Future<Patch> createUser(String name, String addres) async {
    await tokenDosyaOku().then((value) {
      token = value;
      debugPrint(token);
    });
    final response = await http.patch(
        Uri.parse(
          "${IpAddres().ipAddress}/users/update-me/",
        ),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(
            <String, String>{"user_name": name, "user_address": addres}));


    if (response.statusCode == 200) {


      return Patch.fromJsonMap(jsonDecode(response.body));
    } else {
      throw Exception("faild");
    }
  }

  @override
  Future<DecodHasap> fetchAlbum() async {
    await tokenDosyaOku().then((value) {
      token = value;
    });
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.get( Uri.parse("${IpAddres().ipAddress}/users/my-account"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },);

    DecodHasap decodHasap;

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      decodHasap = DecodHasap.fromJsonMap(decodedJson);
      debugPrint(token);
      return decodHasap;
    } else {
      throw Exception('Failed to load album');
    }
  }

  final _formkey = GlobalKey<FormState>();

  bool otomatikKontrol = false;
  TextEditingController? phoneControl;
  TextEditingController? name;
  TextEditingController? salgy;

  void initState() {
    veri = fetchAlbum();

    lan = languageAlbum();
    super.initState();
  }

  @override
  void dispose() {
    phoneControl!.dispose();
    name!.dispose();
    salgy!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Patch? _patch;
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

  Future<Language> languageAlbum() async {
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

  Future<Language>? lan;

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
              builder: (context, AsyncSnapshot<DecodHasap> sonuc) {
                if (sonuc.hasData) {
                  return Container(
                    child: FutureBuilder(
                        future: lan,
                        builder: (context, AsyncSnapshot<Language> langu) {
                          if (langu.hasData) {
                            return ListView(children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      yzy();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 14),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/left.svg"),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                            ),
                                            child: Text(
                                              langu.data!.accont.hasabym,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(
                                        left: 14, top: 32, bottom: 17),
                                    child: Text(
                                      langu.data!.accont.hasabym,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(errorColor: Colors.red),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 13, left: 12),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Form(
                                                key: _formkey,
                                                autovalidateMode: AutovalidateMode.always,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 15),
                                                        child: Text(
                                                          langu.data!.accont.ady,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )),
                                                    TextFormField(
                                                      controller: name =
                                                          TextEditingController(
                                                              text: sonuc.data!
                                                                  .user_name
                                                                  .toString()),
                                                      cursorColor:
                                                      Color.fromRGBO(104, 109, 118, 1),
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromRGBO(
                                                                      230,
                                                                      230,
                                                                      230,
                                                                      1)),
                                                      validator: (jog) {
                                                        int a = jog!.length;
                                                        if (a == 0) {
                                                          return langu.data!.gosmaca.doldur;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 15),
                                                        child: Text(
                                                          langu.data!.accont.telefon,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )),
                                                    TextFormField(
                                                      controller: phoneControl =
                                                          TextEditingController(
                                                              text:
                                                                  "${sonuc.data!.user_phone.toString()}"),
                                                      enabled: false,
                                                      cursorColor:
                                                      Color.fromRGBO(104, 109, 118, 1),
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: "",
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromRGBO(
                                                                      230,
                                                                      230,
                                                                      230,
                                                                      1)),

                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 15),
                                                        child: Text(
                                                          langu.data!.accont.salgym,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )),
                                                    TextFormField(
                                                      controller: salgy =
                                                          TextEditingController(
                                                              text: sonuc.data!
                                                                  .user_address),
                                                      cursorColor:
                                                      Color.fromRGBO(104, 109, 118, 1),
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: "",
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromRGBO(
                                                                      230,
                                                                      230,
                                                                      230,
                                                                      1)),
                                                      validator: (jog) {
                                                        if (jog!.length == 0) {
                                                          return langu.data!.gosmaca.doldur;
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PasswordChange()));
                                          },
                                          child: Container(
                                              alignment: Alignment.bottomLeft,
                                              padding: EdgeInsets.only(
                                                  top: 15, left: 13, right: 13,bottom: 15),
                                              child: Text(
                                               langu.data!.accont.acar,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      girisBilgi();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => MyApp(5)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10,
                                          left: 14,
                                          right: 14,
                                          top: 25),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color.fromRGBO(255, 0, 0, 1),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(langu.data!.perewod.remember,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                          } else {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ))
                            );
                          }
                        }),
                  );
                }else {
                  return Center(
                      child: Container(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ))
                  );
                }
              }),
        ),
      ),
    );
  }

  yzy() {
    Navigator.of(context).pop();
  }

  void girisBilgi() async {
    if (_formkey.currentState!.validate()) {

      _formkey.currentState!.save();
      final String Salgy = salgy!.text;
      final String Name = name!.text;
      final Patch signUp = await createUser(Name, Salgy);
      setState(() {
        _patch = signUp;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }

  newHasabym(String sorag, String jog) {
    return Column(
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 13, bottom: 10, top: 15),
            child: Text(
              sorag,
              style: TextStyle(fontSize: 14),
            )),
        Padding(
            padding: EdgeInsets.only(
              left: 13,
              right: 13,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    jog,
                    style: TextStyle(fontSize: 14),
                  )),
            ))
      ],
    );
  }
}
