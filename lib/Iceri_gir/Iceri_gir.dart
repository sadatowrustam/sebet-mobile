import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/Agza/Agza_bol.dart';
import 'package:sebet/forgot_password/forgot_pasword.dart';
import 'package:sebet/main.dart';
import 'package:sebet/models/input/LogIn.dart';
import 'package:http/http.dart' as http;
import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';

class Iceri extends StatefulWidget {
  const Iceri({Key? key}) : super(key: key);

  @override
  _IceriState createState() => _IceriState();
}

class _IceriState extends State<Iceri> {
  int? rescode;

  int checked = 0;

  Future<LogIn> createUser(String name, String pasword) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await  ioClient.post( Uri.parse(
      "${IpAddres().ipAddress}/users/login",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Basic token"
        },
        body: jsonEncode(
            <String, String>{"user_phone": name, "user_password": pasword}));
    final responseJson = json.decode(response.body);
    rescode = response.statusCode.toInt();
    var a = jsonDecode(response.body)['token'];
    checked = response.statusCode.toInt();

    if (response.statusCode == 200) {
      idwrite(json.decode(response.body)['data']['user']['id'].toString());
      dosyaYaz(true.toString());
      tokenDosyaYaz(json.decode(response.body)['token']);
      _showToast('', response.statusCode);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp(5)),
        (Route<dynamic> route) => false,
      );

      return responseJson;
    } else {
      debugPrint(response.statusCode.toString());
      dosyaYaz(false.toString());
      return _showToast("", response.statusCode);
    }
  }

  final _formkey = GlobalKey<FormState>();
  LogIn? _logIn;

  bool otomatikKontrol = false;
  final TextEditingController phoneControl = TextEditingController();
  final TextEditingController pasword = TextEditingController();

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
      return 'Hata Cikti $exception';
    }
  }

  Future<File> idwrite(String yaz) async {
    var myDosya = await createId;
    return myDosya.writeAsString(yaz);
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
      fToast = FToast();
      fToast.init(context);
    });
  }

  String checkedKod = '';
  String Allcheck = '';
  String incorrect = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  return ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(top: 15, left: 14),
                            child: InkWell(
                              onTap: () {
                                yzaCyk();
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icon/left.svg"),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Text(
                                      sonuc.data!.register.iceri,
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
                                sonuc.data!.register.iceri,
                                style: TextStyle(fontSize: 24),
                              )),
                          newForm(
                            sonuc.data!.login.telefon,
                            sonuc.data!.login.acar,
                            sonuc.data!.gosmaca.doldur,
                            sonuc.data!.gosmaca.az,
                            sonuc.data!.gosmaca.telefon,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Password()));
                            },
                            child: Container(
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.only(
                                    top: 15, left: 13, right: 13, bottom: 15),
                                child: Text(
                                  sonuc.data!.login.forgetKey,
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              girisBilgi();
                              checkedKod = sonuc.data!.gosmaca.ulgam;
                              incorrect = sonuc.data!.gosmaca.incorrect;
                              _showToast(sonuc.data!.gosmaca.garasmak, 100);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                left: 14,
                                right: 14,
                              ),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Text(sonuc.data!.login.iceriGir,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Agza()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(sonuc.data!.login.signUp,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  )),
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
                  )));
                }
              }),
        ),
      ),
    );
  }

  yzaCyk() {
    Navigator.pop(context);
  }

  late FToast fToast;

  _showToast(String barla, int status) {
    if (status == 401) {
      Allcheck = incorrect;
    } else if (status == 200) {
      Allcheck = checkedKod;
    } else {
      Allcheck = barla;
    }
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Allcheck,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  newForm(String phone, String key, String full, String barla, String work) {
    return Theme(
      data: Theme.of(context).copyWith(errorColor: Colors.red),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 14, left: 14),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            phone,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: phoneControl,
                        maxLength: 7,
                        keyboardType: TextInputType.number,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
                            prefixText: "+9936",
                            hintText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Color.fromRGBO(230, 230, 230, 1)),
                        validator: (jog) {
                          int a = jog!.length;
                          if (a == 0) {
                            return full;
                          } else if (a == 7) {
                            return null;
                          } else {
                            return work;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            key,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: pasword,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Color.fromRGBO(230, 230, 230, 1)),
                        validator: (jog) {
                          if (jog!.length == 0) {
                            return full;
                          } else if (jog.length < 6) {
                            return barla;
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
          )
        ],
      ),
    );
  }

  void girisBilgi() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      final String phone = "+9936" + phoneControl.text;
      final String pas = pasword.text;
      final LogIn _Login = await createUser(phone, pas);

      setState(() {
        _logIn = _Login;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
// method to Encrypt String Password

}
