import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sebet/forgot_password/changeNewPassword.dart';
import 'package:sebet/models/input/changePassword.dart';
import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String? encryptedS, decryptedS;
  var password = "null";

  int? bcypt, dec;
  int? barla;
  String token = '';
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
    // TODO: implement initState
    super.initState();
    setState(() {
      veri = fetchAlbum();
      fToast = FToast();
      fToast.init(context);
    });
  }

  Future<ChangePassword> createUser(String phone) async {
    await tokenDosyaOku().then((value) {
      token = value;
    });
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.patch( Uri.parse(
      "${IpAddres().ipAddress}/users/forgot-password",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(<String, String>{
          "user_phone": phone,
        }));
    barla = response.statusCode;
    bcypt = jsonDecode(response.body)['id'];
debugPrint(response.body);
    if (response.statusCode == 200) {
      showAlertDialog(context);
      return ChangePassword.fromJsonMap(jsonDecode(response.body));
    } else {
      return _showToast(response.statusCode.toString());
    }
  }

  String? _tel;
  final _formkey = GlobalKey<FormState>();
  bool otomatikKontrol = false;
  final TextEditingController _phoneControl = TextEditingController();
  final TextEditingController _key = TextEditingController();
  ChangePassword? _changePassword;
  var key = "null";

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

  String bellik = '';
  String kod = '';
  String ugrat = '';
  String wrong = '';
  String have = '';

  @override
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
                               exit();
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
                          newForm(
                              sonuc.data!.accont.telefon,
                              sonuc.data!.gosmaca.doldur,
                              sonuc.data!.gosmaca.telefon),
                          InkWell(
                            onTap: () async {
                              girisBilgi();
                              _showToast(sonuc.data!.gosmaca.garasmak);
                              bellik = sonuc.data!.gosmaca.giriz;
                              kod = sonuc.data!.gosmaca.kody;
                              ugrat = sonuc.data!.gosmaca.ugrat;
                              wrong = sonuc.data!.gosmaca.kod;
                              have = sonuc.data!.gosmaca.alynmadyk;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 14, right: 14, top: 15),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromRGBO(255, 0, 0, 1)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(sonuc.data!.gosmaca.taze,
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
                  )));
                }
              }),
        ),
      ),
    );
  }
exit(){
  Navigator.of(context).pop();
}
  newForm(String tel, String full, String correct) {
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
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            tel,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: _phoneControl,
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
                          if (jog!.length == 0) {
                            return full;
                          } else if (jog.length < 3) {
                            return correct;
                          } else if (jog.length == 7) {
                            return null;
                          } else {
                            return correct;
                          }
                        },
                        onSaved: (deger) => _tel = deger,
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              bellik,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        kod,
                        style: TextStyle(fontSize: 14),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 14, left: 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _key,
                        keyboardType: TextInputType.number,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        textAlignVertical: TextAlignVertical.bottom,
                        textInputAction: TextInputAction.done,
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
                      ),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  if (_key.text == bcypt.toString()) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewPassword("+9936"+_phoneControl.text)));
                  } else {
                    _showToast(wrong);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 14, right: 14, top: 25),
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
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(ugrat,
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
          );
        });
  }

  late FToast fToast;

  _showToast(String cykar) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Text(
            cykar == 400.toString() ? have : cykar,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void girisBilgi() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      final String phone ='+9936'+_phoneControl.text;
      final ChangePassword changePassword = await createUser(phone);
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
