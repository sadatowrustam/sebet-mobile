import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sebet/Agza/code.dart';

import 'package:sebet/Iceri_gir/Iceri_gir.dart';

import 'package:http/http.dart' as http;
import 'package:sebet/IpAddress.dart';
import 'package:sebet/models/input/SignUp.dart';
import 'package:sebet/models/language/Language.dart';

class Agza extends StatefulWidget {
  @override
  _AgzaState createState() => _AgzaState();
}

class _AgzaState extends State<Agza> {
  String? encryptedS, decryptedS;
  var password = "null";

  int? bcypt, dec;
  int checkstatus = 0;

  Future<dynamic> createUser(String phone) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.post(Uri.parse(
      "${IpAddres().ipAddress}/users/signup",
    ), body:jsonEncode(<String, String>{
      "user_phone": phone,
    }),headers: <String, String>{
      "Content-Type": "application/json",
    },);
    bcypt = jsonDecode(response.body)['id'];

    debugPrint(bcypt.toString());
    if (response.statusCode == 200) {
      showAlertDialog(context);

      return SignUp.fromJsonMap(jsonDecode(response.body));
    } else {

      return _showToast('true');
    }
  }

  bool check = false;

  final _formkey = GlobalKey<FormState>();
  bool otomatikKontrol = false;
  final TextEditingController _phoneControl = TextEditingController();
  final TextEditingController _key = TextEditingController();
  SignUp? _signUp;
  var key = "null";
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
  String errorCheck = '';

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      veri = fetchAlbum();
      fToast = FToast();
      fToast.init(context);
    });
  }

  String? ugrat;
  String? kod;
  String? sent;
  String? incorrect;
  String? have;
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
                        Container(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding:
                                    const EdgeInsets.only(left: 14, top: 15),
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
                                          sonuc.data!.register.agza,
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
                                    sonuc.data!.register.agza,
                                    style: TextStyle(fontSize: 24),
                                  )),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(errorColor: Colors.red),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 13, left: 12),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Form(
                                            key: _formkey,
                                            autovalidateMode: AutovalidateMode.always,
                                            child: Column(
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    padding: EdgeInsets.only(
                                                        bottom: 15),
                                                    child: Text(
                                                      sonuc.data!.register.tel,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    )),
                                                TextFormField(
                                                  controller: _phoneControl,
                                                  maxLength: 7,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: Color.fromRGBO(
                                                      104, 109, 118, 1),
                                                  decoration: InputDecoration(
                                                      errorStyle: TextStyle(
                                                          color: Colors.red),
                                                      prefixText: "+9936",
                                                      hintText: "",
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(5),
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
                                                      fillColor: Color.fromRGBO(
                                                          230, 230, 230, 1)),
                                                  validator: (jog) {
                                                    if (jog!.length == 0) {
                                                      return sonuc
                                                          .data!.gosmaca.doldur;
                                                    } else if (jog.length < 3) {
                                                      return sonuc.data!.gosmaca
                                                          .telefon;
                                                    } else if (jog.length == 7) {
                                                      return null;
                                                    } else {
                                                      return sonuc.data!.gosmaca
                                                          .telefon;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, top: 15),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.only(),
                                  value: check,
                                  onChanged: (secildi) {
                                    setState(() {
                                      check = secildi!;
                                    });
                                    debugPrint(secildi.toString());
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Container(
                                      alignment: Alignment.bottomLeft,
                                      padding:
                                          EdgeInsets.only(top: 5, right: 15),
                                      child: Text(
                                        sonuc.data!.register.ulanys,
                                        style: TextStyle(fontSize: 14),
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (check.toString() == 'true') {
                                    girisBilgi();
                                    _showToast(sonuc.data!.gosmaca.garasmak);
                                  }
                                  ugrat = sonuc.data!.gosmaca.giriz;
                                  kod =sonuc.data!.gosmaca.kody;
                                  sent = sonuc.data!.gosmaca.ugrat;
                                  incorrect = sonuc.data!.gosmaca.kod;
                                  errorCheck = sonuc.data!.gosmaca.agzaBolan;
                                  have=sonuc.data!.perewod.have;
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (context) => Code()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 14, right: 14, top: 15),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: check.toString() == 'true'
                                          ? Color.fromRGBO(255, 0, 0, 1)
                                          : Colors.black38,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                sonuc.data!.register.agzaBol,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white)),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Iceri()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(sonuc.data!.register.iceri,
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                              // _gosul==null ? Container(child : Text('Islemedi')): Text(_gosul!.userName)
                            ],
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
                })),
      ),
    );
  }

  yzaCyk() {
    Navigator.pop(context);
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              ugrat.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        kod.toString(),
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
                        builder: (context) => CodeState("+9936"+_phoneControl.text)));
                  } else {
                    _showToast(incorrect.toString());

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
                            child: Text(sent.toString(),
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
            cykar == true.toString() ? errorCheck : cykar,
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

      final String phone = '+9936'+_phoneControl.text;
      final SignUp signUp = await createUser(phone);
      setState(() {
        _signUp = signUp;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
}
