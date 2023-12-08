import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/models/AddOrder.dart';
import 'package:sebet/models/DatabaseHelper/databaseHelper.dart';
import 'package:sebet/models/Hasabym/DecodHasap.dart';
import 'package:sebet/models/language/Language.dart';
import 'package:http/http.dart' as http;

import '../IpAddress.dart';
import '../main.dart';

class PaymentProduct extends StatefulWidget {
  const PaymentProduct({Key? key}) : super(key: key);

  @override
  _PaymentProductState createState() => _PaymentProductState();
}

class _PaymentProductState extends State<PaymentProduct> {
  bool check = false;
  String gor = '1';
  String wagt = '';
  int grvalue = 1;
  String wagt2 = '';
  String? _ad, _tel, _acar, _acar2;
  final _formkey = GlobalKey<FormState>();
  String? barla;
  bool otomatikKontrol = false;
  List b = [];

  String? url;

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

  String? idPr;
  Future<Language>? veri;
  List? work;
  String? kabul;

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

  String token = "";

  Future<DecodHasap> userId() async {
    await tokenDosyaOku().then((value) {
      token = value;
    });
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.get(Uri.parse("http://185.128.213.46:5001/users/my-account"),
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

// void checkpro(){
//
// }
  Future<DecodHasap>? userToken;

  Future<AddOrder> createUser(
      String note,
      bool i_take,
      int payment_type,
      String user_phone,
      String user_name,
      String addres,
      int delivery_time,
      BuildContext context) async {
    var son = await refreshNotes();
    List arrey = [];
    for (var dbProduct in son!) {
      Map<String, dynamic> data = {
        "product_id": dbProduct["ProductId"],
        "quantity": dbProduct["SANY"]
      };
      arrey.add(data);
    }
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await  ioClient.post( Uri.parse(
      "${IpAddres().ipAddress}/users/my-orders/add",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, dynamic>{
            "address": addres,
            "delivery_time": delivery_time,
            "user_name": user_name,
            "user_phone": user_phone,
            "payment_type": payment_type,
            "i_take": i_take,
            "note": note,
            "order_products": arrey
          },
        ));
    debugPrint(response.body + "sfsdf");
    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      await DatabasHelper.instance.deleteAll();
      Provider.of<Price>(context, listen: false).nola();
      Provider.of<Counter>(context, listen: false).nully();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp(5)),
        (Route<dynamic> route) => false,
      );

      _showToastEdit(context);
      return AddOrder.fromJson(jsonDecode(response.body));
    } else {
      return _showToast();
    }
  }

  Future<AddOrder> createUserLogin(
      String note,
      bool i_take,
      int payment_type,
      String user_phone,
      String user_name,
      String addres,
      int delivery_time,
      BuildContext context) async {
    var son = await refreshNotes();
    List arrey = [];
    for (var dbProduct in son!) {
      Map<String, dynamic> data = {
        "product_id": dbProduct["ProductId"],
        "quantity": dbProduct["SANY"]
      };
      arrey.add(data);
    }
    await idread().then((value) {
      idPr = value;
    });
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.post( Uri.parse(
      "${IpAddres().ipAddress}/users/my-orders/add",
    ),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, dynamic>{
            "address": addres,
            "delivery_time": delivery_time,
            "user_name": user_name,
            "user_phone": user_phone,
            "payment_type": payment_type,
            "i_take": i_take,
            "note": note,
            "userId": idPr,
            "order_products": arrey
          },
        ));
    debugPrint(response.body + "sfsdf");
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      await DatabasHelper.instance.deleteAll();
      Provider.of<Price>(context, listen: false).nola();
      Provider.of<Counter>(context, listen: false).nully();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyApp(5)),
        (Route<dynamic> route) => false,
      );

      _showToastEdit(context);
      return AddOrder.fromJson(jsonDecode(response.body));
    } else {
      return _showToast();
    }
  }

  void initState() {
    getVeri();
    // TODO: implement initState
    super.initState();
    setState(() {
      takeId();
      userToken = userId();
      veri = fetchAlbum();
      fToast = FToast();
      fToast.init(context);
    });
  }

  takeId() async {
    await idread().then((value) {
      idPr = value;
    });
  }

  List<OrderProduct>? liste;
  List<OrderProduct>? arr;
  double? price;

  getVeri() async {
    var son = refreshNotes();

    for (var dbProduct in son!) {
      price = price! + dbProduct["SANY"] * dbProduct["Price"];
    }
  }

  DateTime now = DateTime.now();
  List<Map<String, dynamic>>? son;

  refreshNotes() async {
    son = await DatabasHelper.instance.tumProduct();

    return son;
  }

  String? info;
  TextEditingController name = TextEditingController();
  TextEditingController salgy = TextEditingController();
  TextEditingController phoneControl = TextEditingController();
  TextEditingController comment = TextEditingController();
  @override
  int bar = 0;

  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    debugPrint(idPr);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Avenir',
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: veri,
                builder: (context, AsyncSnapshot<Language> sonuc) {
                  if (sonuc.hasData) {
                    return idPr == false.toString()
                        ? Container(
                            color: Colors.white60,
                            child: ListView(children: [
                              Column(children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: InkWell(
                                      onTap: () {
                                        yza();
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/left.svg"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Text(
                                              sonuc.data!.cart.sargyt,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left: 12, top: 32),
                                    child: Text(
                                      sonuc.data!.payment.tolegSek,
                                      style: TextStyle(fontSize: 18),
                                    )),
                                RadioListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 5, top: 30),
                                  value: "1",
                                  groupValue: gor,
                                  onChanged: (deger) {
                                    setState(() {
                                      gor = deger.toString();
                                      bar = 1;
                                    });
                                  },
                                  title: Text(
                                    sonuc.data!.payment.nagt,
                                  ),
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(
                                    left: 5,
                                  ),
                                  value: "2",
                                  groupValue: gor,
                                  onChanged: (deger) {
                                    setState(() {
                                      gor = deger.toString();
                                      bar = 2;
                                    });
                                  },
                                  title: Text(
                                    sonuc.data!.payment.toleg,
                                  ),
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.only(left: 5),
                                  value: "3",
                                  groupValue: gor,
                                  onChanged: (deger) {
                                    // setState(() {
                                    //   gor = deger.toString();
                                    //   bar = 3;
                                    // });
                                  },
                                  title: Text(sonuc.data!.payment.onlaynToleg),
                                ),
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.only(left: 5),
                                  value: check,
                                  onChanged: (secildi) {
                                    setState(() {
                                      check = secildi!;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(sonuc.data!.payment.aljak),
                                ),
                                Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 51, left: 12),
                                    child: Text(
                                      check == true
                                          ? sonuc.data!.perewod.time
                                          : sonuc.data!.payment.wagty,
                                      style: TextStyle(fontSize: 18),
                                    )),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 30),
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        backgroundColor: Colors.white,
                                        thumbColor:
                                            Color.fromRGBO(230, 230, 230, 1),
                                        children: {
                                          1: Container(
                                              alignment: Alignment.center,
                                              width: 96,
                                              height: 36,
                                              child: Text(
                                                sonuc.data!.payment.suGun,
                                                style: TextStyle(fontSize: 14),
                                              )),
                                          2: Container(
                                              alignment: Alignment.center,
                                              width: 96,
                                              height: 36,
                                              child: Text(
                                                sonuc.data!.payment.ertir,
                                                style: TextStyle(fontSize: 14),
                                              ))
                                        },
                                        onValueChanged: (int? value) {
                                          setState(
                                            () {
                                              grvalue = value!;
                                            },
                                          );
                                        },
                                        groupValue: grvalue,
                                      )),
                                ),
                                grvalue == 1 ? TimeToday() : Time(),
                                newForm(
                                    sonuc.data!.register.ady,
                                    sonuc.data!.payment.salgynyz,
                                    sonuc.data!.register.tel,
                                    sonuc.data!.payment.bellik,
                                    sonuc.data!.gosmaca.doldur,
                                    sonuc.data!.gosmaca.telefon),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 13, top: 50),
                                    child: Text(
                                      "- " + sonuc.data!.payment.tasslyk,
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 13, top: 10),
                                    child: Text(
                                      "- " + sonuc.data!.payment.tabsyr,
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Column(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15, bottom: 10, top: 20),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      sonuc.data!.orders.jemi,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 15, bottom: 30),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      myprice.sana.toStringAsFixed(1) +
                                          " " +
                                          sonuc.data!.home.manat,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromRGBO(255, 0, 0, 1)),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 16),
                                      child: InkWell(
                                        onTap: () {
                                          kabul = sonuc.data!.perewod.kabul;
                                          info = sonuc.data!.perewod.doly;

                                          girisBilgi(context);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                        sonuc.data!.details.gos,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      )),
                                ]),
                              ])
                            ]))
                        : FutureBuilder(
                            future: userToken,
                            builder: (context, AsyncSnapshot<DecodHasap> id) {
                              if (id.hasData) {
                                String bol = id.data!.user_phone.substring(5);
                                return Container(
                                  color: Colors.white60,
                                  child: ListView(children: [
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: InkWell(
                                            onTap: () {
                                              yza();
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icon/left.svg"),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text(
                                                    sonuc.data!.cart.sargyt,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          padding: EdgeInsets.only(
                                              left: 12, top: 32),
                                          child: Text(
                                            sonuc.data!.payment.tolegSek,
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      RadioListTile(
                                        contentPadding:
                                            EdgeInsets.only(left: 5, top: 30),
                                        value: "1",
                                        groupValue: gor,
                                        onChanged: (deger) {
                                          setState(() {
                                            gor = deger.toString();
                                            bar = 1;
                                          });
                                        },
                                        title: Text(
                                          sonuc.data!.payment.nagt,
                                        ),
                                      ),
                                      RadioListTile(
                                        contentPadding: EdgeInsets.only(
                                          left: 5,
                                        ),
                                        value: "2",
                                        groupValue: gor,
                                        onChanged: (deger) {
                                          setState(() {
                                            gor = deger.toString();
                                            bar = 2;
                                          });
                                        },
                                        title: Text(
                                          sonuc.data!.payment.toleg,
                                        ),
                                      ),
                                      RadioListTile(
                                        contentPadding:
                                            EdgeInsets.only(left: 5),
                                        value: "3",
                                        groupValue: gor,
                                        onChanged: (deger) {
                                          // setState(() {
                                          //   gor = deger.toString();
                                          //   bar = 3;
                                          // });
                                        },
                                        title: Text(
                                            sonuc.data!.payment.onlaynToleg),
                                      ),
                                      CheckboxListTile(
                                        contentPadding:
                                            EdgeInsets.only(left: 5),
                                        value: check,
                                        onChanged: (secildi) {
                                          setState(() {
                                            check = secildi!;
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(sonuc.data!.payment.aljak),
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.only(
                                              top: 51, left: 12),
                                          child: Text(
                                            check == true
                                                ? sonuc.data!.perewod.time
                                                : sonuc.data!.payment.wagty,
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, top: 30),
                                            child:
                                                CupertinoSlidingSegmentedControl<
                                                    int>(
                                              backgroundColor: Colors.white,
                                              thumbColor: Color.fromRGBO(
                                                  230, 230, 230, 1),
                                              children: {
                                                1: Container(
                                                    alignment: Alignment.center,
                                                    width: 96,
                                                    height: 36,
                                                    child: Text(
                                                      sonuc.data!.payment.suGun,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    )),
                                                2: Container(
                                                    alignment: Alignment.center,
                                                    width: 96,
                                                    height: 36,
                                                    child: Text(
                                                      sonuc.data!.payment.ertir,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ))
                                              },
                                              onValueChanged: (int? value) {
                                                setState(
                                                  () {
                                                    grvalue = value!;
                                                  },
                                                );
                                              },
                                              groupValue: grvalue,
                                            )),
                                      ),
                                      grvalue == 1 ? TimeToday() : Time(),
                                      // newForm(
                                      //     sonuc.data!.register.ady,
                                      //     sonuc.data!.payment.salgynyz,
                                      //     sonuc.data!.register.tel,
                                      //     sonuc.data!.payment.bellik,
                                      //     sonuc.data!.gosmaca.doldur,
                                      //     sonuc.data!.gosmaca.telefon),
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
                                                    // ignore: deprecated_member_use
                                                    autovalidateMode: AutovalidateMode.always,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 15),
                                                            child: Text(
                                                              sonuc.data!
                                                                  .register.ady,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            )),
                                                        TextFormField(
                                                          controller: name =
                                                              TextEditingController(
                                                                  text: id.data!
                                                                      .user_name
                                                                      .toString()),
                                                          cursorColor:
                                                              Color.fromRGBO(
                                                                  104,
                                                                  109,
                                                                  118,
                                                                  1),
                                                          decoration:
                                                              InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      color: Colors
                                                                          .red),
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
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none),
                                                                  filled: true,
                                                                  fillColor: Color
                                                                      .fromRGBO(
                                                                          230,
                                                                          230,
                                                                          230,
                                                                          1)),
                                                          validator: (jog) {
                                                            if (jog!.length ==
                                                                0) {
                                                              return sonuc
                                                                  .data!
                                                                  .gosmaca
                                                                  .doldur;
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          onSaved: (deger) =>
                                                              _ad = deger,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    bottom: 10),
                                                            child: Text(
                                                              sonuc
                                                                  .data!
                                                                  .payment
                                                                  .salgynyz,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            )),
                                                        TextFormField(
                                                          controller: salgy =
                                                              TextEditingController(
                                                                  text: id.data!
                                                                      .user_address),
                                                          cursorColor:
                                                              Color.fromRGBO(
                                                                  104,
                                                                  109,
                                                                  118,
                                                                  1),
                                                          maxLines: 2,
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
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none),
                                                                  filled: true,
                                                                  fillColor: Color
                                                                      .fromRGBO(
                                                                          230,
                                                                          230,
                                                                          230,
                                                                          1)),
                                                          validator: (jog) {
                                                            if (jog!.length ==
                                                                0) {
                                                              return sonuc
                                                                  .data!
                                                                  .gosmaca
                                                                  .doldur;
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          onSaved: (deger) =>
                                                              _acar = deger,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    top: 5),
                                                            child: Text(
                                                              sonuc.data!
                                                                  .register.tel,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            )),
                                                        TextFormField(
                                                          controller: phoneControl =
                                                              TextEditingController(
                                                                  text:
                                                                      "${bol}"),
                                                          maxLength: 7,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          cursorColor:
                                                              Color.fromRGBO(
                                                                  104,
                                                                  109,
                                                                  118,
                                                                  1),
                                                          decoration:
                                                              InputDecoration(
                                                                  errorStyle: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                  prefixText:
                                                                      "+9936",
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
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide: BorderSide
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
                                                              return sonuc
                                                                  .data!
                                                                  .gosmaca
                                                                  .doldur;
                                                            } else if (a == 7) {
                                                              return null;
                                                            } else {
                                                              return sonuc
                                                                  .data!
                                                                  .gosmaca
                                                                  .telefon;
                                                            }
                                                          },
                                                          onSaved: (deger) =>
                                                              _tel = deger,
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    bottom: 10),
                                                            child: Text(
                                                              sonuc
                                                                  .data!
                                                                  .payment
                                                                  .bellik,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            )),
                                                        TextFormField(
                                                          controller: comment,
                                                          cursorColor:
                                                              Color.fromRGBO(
                                                                  104,
                                                                  109,
                                                                  118,
                                                                  1),
                                                          maxLines: 2,
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
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none),
                                                                  focusColor:
                                                                      Colors
                                                                          .red,
                                                                  filled: true,
                                                                  fillColor: Color
                                                                      .fromRGBO(
                                                                          230,
                                                                          230,
                                                                          230,
                                                                          1)),
                                                          onSaved: (deger) =>
                                                              _acar2 = deger,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 13, top: 50),
                                          child: Text(
                                            "- " + sonuc.data!.payment.tasslyk,
                                            style: TextStyle(fontSize: 16),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 13, top: 10),
                                          child: Text(
                                            "- " + sonuc.data!.payment.tabsyr,
                                            style: TextStyle(fontSize: 16),
                                          )),
                                      Column(children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15, bottom: 10, top: 20),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            sonuc.data!.orders.jemi,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15, bottom: 30),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            myprice.sana.toStringAsFixed(1) +
                                                " " +
                                                sonuc.data!.home.manat,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1)),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 16),
                                            child: InkWell(
                                              onTap: () {
                                                kabul =
                                                    sonuc.data!.perewod.kabul;
                                                info = sonuc.data!.perewod.doly;

                                                girisBilgi(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Color.fromRGBO(
                                                        255, 0, 0, 1),
                                                  ),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                              sonuc.data!
                                                                  .details.gos,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white)),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            )),
                                      ]),
                                    ])
                                  ]),
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
                })),
      ),
    );
  }

  yza() {
    Navigator.of(context).pop();
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
            info.toString(),
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

  int timeCheck = 0;

  TimeToday() {
    if (now.hour < 9) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            child: RadioListTile(
              controlAffinity: ListTileControlAffinity.platform,
              contentPadding: EdgeInsets.only(left: 5),
              value: "11",
              groupValue: wagt,
              onChanged: (deger) {
                setState(() {
                  timeCheck = 11;
                  wagt = deger.toString();
                });
              },
              title: Text("9:00-12:00"),
            ),
          ),
          Container(
            height: 50,
            child: RadioListTile(
              controlAffinity: ListTileControlAffinity.platform,
              contentPadding: EdgeInsets.only(left: 5),
              value: "12",
              groupValue: wagt,
              onChanged: (deger) {
                setState(() {
                  timeCheck = 12;
                  wagt = deger.toString();
                });
              },
              title: Text("12:00-17:00"),
            ),
          ),
          Container(
            height: 50,
            child: RadioListTile(
              controlAffinity: ListTileControlAffinity.platform,
              contentPadding: EdgeInsets.only(left: 5),
              value: "13",
              groupValue: wagt,
              onChanged: (deger) {
                setState(() {
                  timeCheck = 13;
                  wagt = deger.toString();
                });
              },
              title: Text("17:00-20:00"),
            ),
          ),
        ],
      );
    } else if (now.hour < 12) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            child: RadioListTile(
              controlAffinity: ListTileControlAffinity.platform,
              contentPadding: EdgeInsets.only(left: 5),
              value: "12",
              groupValue: wagt,
              onChanged: (deger) {
                setState(() {
                  timeCheck = 12;
                  wagt = deger.toString();
                });
              },
              title: Text("12:00-15:00"),
            ),
          ),
          Container(
            height: 50,
            child: RadioListTile(
              controlAffinity: ListTileControlAffinity.platform,
              contentPadding: EdgeInsets.only(left: 5),
              value: "13",
              groupValue: wagt,
              onChanged: (deger) {
                setState(() {
                  timeCheck = 13;
                  wagt = deger.toString();
                });
              },
              title: Text("18:00-21:00"),
            ),
          ),
        ],
      );
    } else if (now.hour < 18) {
      return RadioListTile(
        contentPadding: EdgeInsets.only(left: 5),
        value: "13",
        groupValue: wagt,
        onChanged: (deger) {
          setState(() {
            timeCheck = 13;
            wagt = deger.toString();
          });
        },
        title: Text("18:00-21:00"),
      );
    } else if (now.hour >= 18) {
      return Container(
        padding: EdgeInsets.only(bottom: 20),
      );
    }
  }

  Time() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          child: RadioListTile(
            contentPadding: EdgeInsets.only(
              left: 5,
            ),
            value: "21",
            groupValue: wagt,
            onChanged: (deger) {
              setState(() {
                timeCheck = 21;
                wagt = deger.toString();
              });
            },
            title: Text("09:00-12:00"),
          ),
        ),
        Container(
          height: 50,
          child: RadioListTile(
            contentPadding: EdgeInsets.only(
              left: 5,
            ),
            value: "22",
            groupValue: wagt,
            onChanged: (deger) {
              setState(() {
                timeCheck = 22;
                wagt = deger.toString();
              });
            },
            title: Text("12:00-15:00"),
          ),
        ),
        Container(
          height: 50,
          child: RadioListTile(
            controlAffinity: ListTileControlAffinity.platform,
            contentPadding: EdgeInsets.only(left: 5),
            value: "23",
            groupValue: wagt,
            onChanged: (deger) {
              setState(() {
                timeCheck = 23;
                wagt = deger.toString();
              });
            },
            title: Text("18:00-21:00"),
          ),
        ),
      ],
    );
  }

  void _showToastEdit(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text("${kabul}"),
      ),
    );
  }

  void maglumat(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(info.toString()),
      ),
    );
  }

  newForm(String ady, String sal, String tel, String Bellik, String full,
      String phone) {
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
                            ady,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: name,
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
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(
                            sal,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: salgy,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        maxLines: 2,
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
                          } else {
                            return null;
                          }
                        },
                        onSaved: (deger) => _acar = deger,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 10, top: 5),
                          child: Text(
                            tel,
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
                            return phone;
                          }
                        },
                        onSaved: (deger) => _tel = deger,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Text(
                            Bellik,
                            style: TextStyle(fontSize: 16),
                          )),
                      TextFormField(
                        controller: comment,
                        cursorColor: Color.fromRGBO(104, 109, 118, 1),
                        maxLines: 2,
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
                        onSaved: (deger) => _acar2 = deger,
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  AddOrder? _orderProduct;

  void girisBilgi(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      await idread().then((value) {
        idPr = value;
      });
      _formkey.currentState!.save();
      final int toleg = bar;
      final bool checked = check;
      final int wagty = timeCheck;

      final String ad = name.text;
      final String sal = salgy.text;
      final String phone = "+9936" + phoneControl.text;
      final String com = comment.text;
      final AddOrder _Login = idPr == "false"
          ? await createUser(
              com, checked, toleg, phone, ad, sal, wagty, context)
          : await createUserLogin(
              com, checked, toleg, phone, ad, sal, wagty, context);
      setState(() {
        _orderProduct = _Login;
      });
    } else {
      setState(() {
        otomatikKontrol = true;
      });
    }
  }
}
