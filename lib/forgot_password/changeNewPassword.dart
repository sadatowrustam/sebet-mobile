import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sebet/models/input/changePassword.dart';
import 'package:sebet/models/language/Language.dart';
import '../IpAddress.dart';
import '../main.dart';

class NewPassword extends StatefulWidget {
  String num;

  NewPassword(this.num);

  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
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
  String? url;

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

  @override
  void initState() {
    super.initState();
    veri = fetchAlbum();
    fToast = FToast();
    fToast.init(context);
  }

  int? rescode;
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

  Future<ChangePassword> createUser(
      String check, String pas, String secpas) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await  ioClient.patch(Uri.parse(
      "${IpAddres().ipAddress}/users/forgot-password",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, String>{
          "user_checked_phone": widget.num,
          'newPassword': pas,
          'newPasswordConfirm': secpas
        }));

    rescode = response.statusCode;
    if (response.statusCode == 200) {
      idwrite(json.decode(response.body)['data']['user']['id'].toString());
      tokenDosyaYaz(json.decode(response.body)['token']);
      dosyaYaz(true.toString());

      _showToast(response.statusCode.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp(5)),
            (Route<dynamic> route) => false,
      );
      return ChangePassword.fromJsonMap(jsonDecode(response.body));
    } else {
      return _showToast("Bu telefon belgi bilen agza bolan müsderi bar");
    }
  }

  Future<String> get dosyaYoly async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();
    debugPrint(dosyaPath.path);
    return dosyaPath.path;
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

  final _formkey = GlobalKey<FormState>();
  String? barla;
  bool otomatikKontrol = false;
  List b = [];

  final TextEditingController _keycontor = TextEditingController();
  final TextEditingController _newkeycontor = TextEditingController();
  ChangePassword? _changePassword;

 String? check;
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
                            padding: const EdgeInsets.only(left: 14, top: 15),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icon/left.svg"),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Text(
                                      sonuc.data!.gosmaca.taze,
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
                                  left: 14, top: 32, bottom: 15),
                              child: Text(
                                sonuc.data!.gosmaca.taze,
                                style: TextStyle(fontSize: 24),
                              )),
                          newForm(sonuc.data!.register.acar,
                            sonuc.data!.register.acarTasyk,
                            sonuc.data!.gosmaca.doldur,
                            sonuc.data!.gosmaca.az,
                            sonuc.data!.gosmaca.acar,  ),
                          InkWell(
                            onTap: () async {
                              girisBilgi();
                              check=sonuc.data!.gosmaca.tazelendi;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30, left: 14, right: 14, top: 15),
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
                                            const EdgeInsets.only(left: 10),
                                        child: Text(sonuc.data!.accont.acar,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      )
                                    ]),
                              ),
                            ),
                          ),
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

  late FToast fToast;

  _showToast(String haty) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
           check.toString() ,
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

  newForm( String pasword, String pasCon,String full, String count,String check) {
    return Theme(
      data: Theme.of(context).copyWith(errorColor: Colors.red),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 13, left: 12),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formkey,
                  // ignore: deprecated_member_use
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(
                            pasword,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: _keycontor,
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
                          barla = jog;
                          if (jog!.length == 0) {
                            return full;
                          } else if (jog.length < 6) {
                            return count;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(
                            pasCon,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: _newkeycontor,
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
                            focusColor: Colors.red,
                            filled: true,
                            fillColor: Color.fromRGBO(230, 230, 230, 1)),
                        validator: (jog) {
                          if (jog!.length == 0) {
                            return full;
                          } else if (jog.length < 6) {
                            return count;
                          } else if (barla != jog) {
                            return check;
                          } else {
                            return null;
                          }
                        },
                      )
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

      final String pas = _keycontor.text;
      final String secpas = _newkeycontor.text;

      final ChangePassword changePassword =
          await createUser(widget.num, pas, secpas);

      setState(() {
        _changePassword = changePassword;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
}
