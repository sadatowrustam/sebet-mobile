import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/models/input/Contact_us.dart';
import 'package:http/http.dart' as http;
import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';

class Habarlas extends StatefulWidget {
  const Habarlas({Key? key}) : super(key: key);
  @override
  _HabarlasState createState() => _HabarlasState();
}

class _HabarlasState extends State<Habarlas> {
  Future<ContactUs> createUser(String name, String number, String text) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.post(Uri.parse(
      "${IpAddres().ipAddress}/public/contact-us",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(
            <String, String>{"name": name, "email": number, "text": text}));
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      _showToast();
      Navigator.pop(context);

      return ContactUs.fromJsonMap(jsonDecode(response.body));
    } else {
      throw Exception("faild");
    }
  }

  bool check = false;
  String? _ad, _tel, _acar, _acar2,checked;
  final _formkey = GlobalKey<FormState>();
  String? barla;
  bool otomatikKontrol = false;
  List b = [];
  final TextEditingController _nameControl = TextEditingController();
  final TextEditingController _phoneControl = TextEditingController();
  final TextEditingController _habar = TextEditingController();
  ContactUs? _contactUs;

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

  late FToast fToast;

  _showToast() {
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
           checked.toString(),
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

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Avenir',
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SafeArea(
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
                                padding:
                                    const EdgeInsets.only(top: 20, left: 14),
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icon/left.svg"),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(
                                        sonuc.data!.gosmaca.habarlas,
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
                                sonuc.data!.gosmaca.habarlas,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            newForm(sonuc.data!.register.ady,sonuc.data!.register.tel,sonuc.data!.gosmaca.hat,sonuc.data!.gosmaca.doldur,sonuc.data!.gosmaca.telefon,),
                            InkWell(
                              onTap: () {
                                girisBilgi();
                                checked=sonuc.data!.gosmaca.kabul;
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(sonuc.data!.gosmaca.ugrat,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              )),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 13, top: 32),
                              child: Text( sonuc.data!.habarlas,style: TextStyle(fontSize: 16, height: 1.5),)

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
                            ))
                    );
                  }

                }),
          ),
        ),
      ),
    );
  }
  yzaCyk() {
    Navigator.pop(context);
  }
  newForm(String ady, String telefon,String haty, String full,String correct) {
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
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            ady,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: _nameControl,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red),
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
                          } else {
                            return null;
                          }
                        },
                        onSaved: (deger) => _ad = deger,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 10, top: 5),
                          child: Text(
                            telefon,
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
                          int a = jog!.length;
                          if (a == 0) {
                            return full;
                          } else if (a == 8 ) {
                            return null;
                          } else {
                            return correct;
                          }
                        },
                        onSaved: (deger) => _tel = deger,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(
                           haty,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: _habar,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
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
                          } else {
                            return null;
                          }
                        },
                        onSaved: (deger) => _acar = deger,
                        maxLines: 4,
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
      debugPrint(_acar);
      final String name = _nameControl.text;
      final String phone = "+9936"+_phoneControl.text;
      final String hab = _habar.text;
      final ContactUs _login = await createUser(name, phone, hab);

      setState(() {
        _contactUs = _login;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
}
