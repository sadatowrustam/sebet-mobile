
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/IpAddress.dart';

import 'package:sebet/Log_In_Profil/profil.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/Profil/profil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sebet/models/Yuk.dart';

import 'kategoriyalar/kategorya.dart';
import 'models/DatabaseHelper/databaseHelper.dart';
import 'models/language/Language.dart';
import 'sebet/sebet.dart';
import 'Anasayfa/body.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true; }}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  List<Map<String, dynamic>> son = await DatabasHelper.instance.tumProduct();
  double sana = 0;
  for (int i = 0; i < son.length; i++) {
    sana = sana + son[i]["Price"] * son[i]["SANY"];
  }
  debugPrint(sana.toString());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
       providers: [
         ChangeNotifierProvider<Counter>(
           create: (
             BuildContext context,
           ) =>
               Counter(son.length),
         ),
        ChangeNotifierProvider<Price>(
           create: (BuildContext context) => Price(sana),
         ),

       ],

      child: MaterialApp(
           theme: ThemeData(
             fontFamily: 'Avenir',
           ),
    debugShowCheckedModeBanner: false,
           home: Sceen()),
     ),
  );
}

class Sceen extends StatefulWidget {
  const Sceen({Key? key}) : super(key: key);

  @override
  _SceenState createState() => _SceenState();
}

class _SceenState extends State<Sceen> {
  Future<List<AllProduct>>? veri;

  @override
  void initState() {
    setState(() {
      LAN = fetchAlbum();
    });
    veri = ProductAlbom();
    GetConnect();
    super.initState();
  }

  AllProduct? _allProduct;

  Future<List<AllProduct>> ProductAlbom() async {
    debugPrint("fdsfdf");
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response =
        await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/products"),);
debugPrint(response.body);
debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      // return Yuk.fromJsonMap(jsonDecode(response.body));
// debugPrint(response.body);
      return (json.decode(response.body) as List)
          .map((e) => AllProduct.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  bool iswificonnected = false;
  bool isInternetOn = true;
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
    return myDosya.writeAsString("tm");
  }

  Language? language;

  Future<Language> fetchAlbum() async {
    await LanguageFileRead().then((value) {
      url = value;
    });

    var giveJson = await DefaultAssetBundle.of(context).loadString(
        url == "ru" ? "assets/language/ru.json" : "assets/language/tk.json");
    var decodedJson = json.decode(giveJson);
    language = Language.fromJson(decodedJson);

    return language!;
  }

  Future<Language>? LAN;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: FutureBuilder(
                future: veri,
                builder: (context, AsyncSnapshot<List<AllProduct>> sonuc) {
                  if (isInternetOn == false) {
                    return FutureBuilder(
                        future: LAN,
                        builder: (context, AsyncSnapshot<Language> sonuc) {
                          if (sonuc.hasData) {
                            return Container(
                              padding: EdgeInsets.only(
                                  top:
                                      (MediaQuery.of(context).size.height / 2) /
                                              2 +
                                          50),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AlertDialog(
                                    title: Text(sonuc.data!.gosmaca.duydurys),
                                    // To display the title it is optional
                                    content: Text(sonuc.data!.gosmaca.tazeden),
                                    // Message which will be pop up on the screen
                                    // Action widget which will provide the user to acknowledge the choice
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            // FlatButton widget is used to make a text to work like a button
                                            
                                            onPressed: () {
                                              SystemNavigator.pop();
                                            },
                                            // function used to perform after pressing the button
                                            child: Text(
                                              sonuc.data!.gosmaca.goybulsun,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                            child: TextButton(
                                              
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Sceen()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              },
                                              child: Text(
                                                sonuc.data!.gosmaca.gaytadan,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(bottom: 30),
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
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
                    if (sonuc.hasData) {
                      return MyApp(0);
                    } else {
                      return Container(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height / 2) - 50),
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset('assets/logo/Sebet.svg'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    child: CircularProgressIndicator(
                                  color: Colors.red,
                                ))
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  }
                })),
      ),
    );
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
    }
  }
}

class MyApp extends StatefulWidget {
  int san = 0;

  MyApp(this.san);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return myDosya.writeAsString("tm");
  }

  Language? language;

  Future<Language> fetchAlbum() async {
    await LanguageFileRead().then((value) {
      url = value;
    });

    var giveJson = await DefaultAssetBundle.of(context).loadString(
        url == "ru" ? "assets/language/ru.json" : "assets/language/tk.json");
    var decodedJson = json.decode(giveJson);
    language = Language.fromJson(decodedJson);

    return language!;
  }

  Future<Language>? veri;

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

  int saylanan = 0;
  List hemmeSah = [];
  var keyAnaEkran = PageStorageKey("key_ana_sayfa");

  int inde = 0;

  var bar;
  List<Map<String, dynamic>>? son;
  int leng = 0;

  refreshNotes() async {
    leng = await DatabasHelper.instance.getLenght();
    debugPrint(son.toString());
    return son;
  }

  @override
  void initState() {
    setState(() {
      veri = fetchAlbum();
    });
    super.initState();

    if (widget.san == 2) {
      inde = 0;
    } else if (widget.san == 3) {
      inde = 1;
      widget.san = 2;
    }
    AnaEkran sayfa1 = AnaEkran(keyAnaEkran);
    Kategoriya sayfa2 = Kategoriya(
      initialIndex: inde,
    );
    Sebet sayfa3 = Sebet();
    LogOut sayfa4 = LogOut();
    LogInProfil safya5 = LogInProfil();
    hemmeSah = [sayfa1, sayfa2, sayfa3, sayfa4];
    dosyaOku().then((value) {
      if (value.toString().length == 4) {
        debugPrint(value.toString());
        hemmeSah = [sayfa1, sayfa2, sayfa3, safya5];
      } else {
        debugPrint(value.toString());
        hemmeSah = [sayfa1, sayfa2, sayfa3, sayfa4];
      }
    });
  }

  String? lan;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final mycount = Provider.of<Counter>(context);
    final myprice = Provider.of<Price>(context);
    return FutureBuilder(
        future: veri,
        builder: (context, AsyncSnapshot<Language> sonuc) {
          if (sonuc.hasData) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  child: widget.san == 2 ? hemmeSah[1] : hemmeSah[saylanan],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icon/dom.svg',
                          width: 18,
                          height: 18,
                        ),
                        label: sonuc.data!.gosmaca.basSahypa),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icon/catog.svg',
                          width: 18,
                          height: 18,
                        ),
                        label: sonuc.data!.home.kategor),
                    BottomNavigationBarItem(
                        icon: Container(
                          width: 25,
                          height: 25,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: SvgPicture.asset(
                                  'assets/icon/sebet.svg',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 5,
                                child: CircleAvatar(
                                    radius: 7,
                                    backgroundColor: Colors.red,
                                    child: FutureBuilder(
                                        future: refreshNotes(),
                                        builder: (context, sonuc) {
                                          return Text(
                                            mycount.count.toString(),
                                            style: TextStyle(fontSize: 8),
                                          );
                                        })),
                              ),
                            ],
                          ),
                        ),
                        label: myprice.sana>0?myprice.sana.toStringAsFixed(1)+" "+"m":sonuc.data!.home.sebet),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icon/profil.svg',
                          width: 18,
                          height: 18,
                        ),
                        label: sonuc.data!.gosmaca.hasabym),
                  ],
                  fixedColor: Color.fromRGBO(55, 58, 64, 1),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: widget.san == 2 ? saylanan = 1 : saylanan,
                  onTap: ((index) {
                    setState(
                      () {
                        if (widget.san == 2) {
                          widget.san = 0;
                          saylanan = index;
                        } else
                          saylanan = index;
                      },
                    );
                  }),
                ));
          } else {
            return Center(
                child: Container(
                    child: CircularProgressIndicator(
              color: Colors.red,
            )));
          }
        
        });
  }
}
