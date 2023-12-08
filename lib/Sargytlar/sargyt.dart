import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/models/Orders.dart';
import 'package:sebet/models/language/Language.dart';
import 'package:http/http.dart' as http;

import '../IpAddress.dart';

class Sargyt extends StatefulWidget {
  const Sargyt({Key? key}) : super(key: key);

  @override
  _SargytState createState() => _SargytState();
}

class _SargytState extends State<Sargyt> {
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

  String? url;

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

  String token = "";
  Future<Language>? veri;
  Orders? orders;
  Future<List<Sargytlar>> Order() async {
    await tokenDosyaOku().then((value) {
      token = value;
    });
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.get(Uri.parse("${IpAddres().ipAddress}/users/my-orders"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {

debugPrint(response.body);
      return (json.decode(response.body) as List)
          .map((e) => Sargytlar.fromJson(e))
          .toList();;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Sargytlar>>? order;

  void initState() {
    // TODO: implement initState
    order = Order();
    super.initState();
    setState(() {
      veri = fetchAlbum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: veri,
            builder: (context, AsyncSnapshot<Language> sonuc) {
              if (sonuc.hasData) {
                return FutureBuilder(
                    future: order,
                    builder: (context, AsyncSnapshot<List<Sargytlar>> sargyt) {
                      if (sargyt.hasData) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                yzaCyk();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15),
                                alignment: Alignment.topLeft,
                                padding:
                                    const EdgeInsets.only(top: 15, left: 14),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icon/left.svg"),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(
                                        sonuc.data!.orders.sargyt,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
height: MediaQuery.of(context).size.height-78,
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 15, bottom: 10),
                              child:
                      ListView.builder(
                      itemCount: sargyt.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                      final date = sargyt.data![index];
                      String time=date.createdAt.year.toString()+"-"+date.createdAt.month.toString()+"-"+date.createdAt.day.toString();
                            return
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child:card(
                                    'ID:',
                                    sonuc.data!.orders.sargytTaryh,
                                    sonuc.data!.orders.haryt,
                                    sonuc.data!.orders.jemi,
                                    sonuc.data!.orders.sargytYag,
                                    sonuc.data!.orders.goybulsun,
                                    sonuc.data!.home.manat,
                                    date.id,
                                    date.totalPrice.toString(),
                                  time,date.totalQuantity.toString(),
                                ) ,
                              );
                              })
                            )
                          ],
                        );
                      } else {
                        return Center(
                            child: Container(
                                child: CircularProgressIndicator(
                          color: Colors.red,
                        )));
                      }
                    });
              } else {
                return Center(
                    child: Container(
                        child: CircularProgressIndicator(
                  color: Colors.red,
                )));
              }
            }),
      ),
    );
  }

  yzaCyk() {
    Navigator.pop(context);
  }

  card(String Id, String History, String count, String all, String how,
      String gowsur, String manat,int harytId, String price,String data,String size) {
    return Container(
      padding: EdgeInsets.only(left: 17, top: 17),
      decoration: BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      Id,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 17),
                    child: Text(
                      harytId.toString(),
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(55, 58, 64, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      all,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      price+" "+ manat,
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(20, 89, 29, 1)),
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      History,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 17),
                    child: Text(
                      data,
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(55, 58, 64, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      how,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      gowsur,
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(255, 0, 0, 1)),
                    ))
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      count,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      size,
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(55, 58, 64, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 17),
                    child: Text(
                      "",
                      style: TextStyle(color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
                Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      "",
                      style: TextStyle(color: Color.fromRGBO(104, 109, 118, 1)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
