import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/models/DatabaseHelper/databaseHelper.dart';
import 'package:sebet/models/DatabaseHelper/note.dart';
import 'package:sebet/models/Top_product/top_product.dart';
import 'package:sebet/models/Yuk.dart';
import 'package:sebet/models/language/Language.dart';
import 'package:sebet/payment/payment.dart';

import '../IpAddress.dart';


class Sebet extends StatefulWidget {
  _SebetState createState() => _SebetState();
}

class _SebetState extends State<Sebet> {
  List newData = [];
  double san = 0;
  int surRaz = 0;
  List<AllProduct>? veri;
  TopProduct? topProduct;

  @override
  void initState() {
    // check();
    Langu = LanguageAlbum();
refreshNotes();
    super.initState();
  }

  List? liste;
  List<AllProduct>? arr;

  getVeri(List<AllProduct> products) async {
    arr = [];
    liste = [];
    var son = await refreshNotes();
    for (var product in products) {
      for (var dbProduct in son!) {
        if (product.id == dbProduct['ID']) {
          arr!.add(product);
          liste!.add(dbProduct['SANY']);

          break;
        }
      }
    }
    return arr;
  }

  Future<List<AllProduct>> productAlbum() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response =
    await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/products"));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      List<AllProduct> productList =
      body.map<AllProduct>((json) => AllProduct.fromJson(json)).toList();

      return await getVeri(productList);
    } else {
      throw Exception('Failed to load album');
    }
  }

  int sana = 0;
  late List<Note> notes;
  late int sa;
  bool isLoading = false;
  String? delete;

  get product => null;
  List<Map<String, dynamic>>? son;

  refreshNotes() async {
    son = await DatabasHelper.instance.tumProduct();
    debugPrint(son.toString());
    return son;
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

  Language? language;

  Future<Language> LanguageAlbum() async {
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

  Future<Language>? Langu;
  double baha = 0;

  double prices = 0;

  @override
  Widget build(BuildContext context) {

    final mycount = Provider.of<Counter>(context);
    prices = 0;
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: FutureBuilder<List<AllProduct>>(
              future: productAlbum(),
              builder: (context, sonuc) {
                // TODO: error
                // TODO: empty
                // TODO: loading...

                if (sonuc.hasData) {
                  return FutureBuilder(
                      future: Langu,
                      builder: (context, AsyncSnapshot<Language> Lan) {
                        if (Lan.hasData) {
                          return Column(


                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 13, bottom: 15),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    Lan.data!.cart.sebedim +
                                        ": " +
                                        son!.length.toString() +
                                        " " +
                                        Lan.data!.gosmaca.haryt,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height - 200,
                                child: ListView.builder(
                                    itemCount: son!.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      var product = son![index];

                                      // myCount.addpro((product.productPrice * liste![index]));
                                      if (product['SANY'] >
                                          product['Stok']) {
                                        final note = Note(
                                            price: product['Price'],
                                            idPro: product[""],
                                            index: product["ProductId"],
                                            indexpro:
                                            product['Stok']);
                                        DatabasHelper.instance.update(note);
                                      }
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 13,
                                                right: 13,
                                                bottom: 10),
                                            child: Card(
                                              elevation: 2,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          width: 127,
                                                          height: 125,
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 5,
                                                              right: 5),
                                                          child: (product ['Surat']!=
                                                              null)
                                                              ?
                                                          CachedNetworkImage(
                                                            imageUrl:     "${IpAddres().ipAddress}/" + product['Surat'].toString(),
                                                            fit: BoxFit.contain,
                                                            height: 50,
                                                            placeholder: (context, url)=>Container(
                                                                alignment: Alignment.center,
                                                                child:
                                                                CircularProgressIndicator(
                                                                  color: Colors.red,
                                                                )),
                                                            errorWidget: (context, url, error) =>
                                                                Image.asset(
                                                                    "assets/images/1.jpg"),
                                                          )


                                                              : Image.asset(
                                                              "assets/images/1.jpg")),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(left: 17),
                                                            child: Text(
                                                              url == 'ru'
                                                                  ? product["Brand"]
                                                                  : product["Ady"],
                                                              style: TextStyle(
                                                                  fontSize: 11),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 19,
                                                                left: 17),
                                                            child: Text(

                                                              url == 'ru'
                                                                  ? product["NameRu"]
                                                                  : product["Ady"],


                                                                style: TextStyle(
                                                                  fontSize: 14)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Counters(
                                                    edit: Lan.data!.perewod
                                                        .change,
                                                    stok:
                                                    Lan.data!.perewod.end,
                                                    url: url.toString(),
                                                    manat: Lan.data!.home.manat,
                                                    index: index,
                                                    arrey:product,
                                                    itemCount: product["SANY"] >
                                                        product["Stok"]
                                                        ? product["Stok"]
                                                        : product["SANY"],
                                                    delet: Lan.data!.perewod
                                                        .delete,
                                                    onpress: setSt,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              Myprice(add: Lan.data!.details.gos,
                                manat: Lan.data!.home.manat, duydur: Lan.data!.gosmaca.duydurys, jemi: Lan.data!.perewod.duydur, jemiBaha:  Lan.data!.cart.jemi,),
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
        ));
  }

  setSt() {
    setState(() {

    });
  }

  void _showToastDelete(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(delete.toString()),
      ),
    );
  }


}

class Myprice extends StatefulWidget {
  String manat;
  String add;
String duydur;
String jemi;
  String jemiBaha;
  Myprice({required this.jemiBaha,required this.jemi,required this.duydur,required this.add, required this.manat,});

  @override
  _MypriceState createState() => _MypriceState();
}

class _MypriceState extends State<Myprice> {


  @override
  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
height: 55,
          width: MediaQuery.of(context).size.width/2,
          
          child: Card(
            child: Container(

              padding: EdgeInsets.only(left: 15, bottom: 10),
              alignment: Alignment.bottomLeft,
              child: Text(
                myprice.sana>0?myprice.sana.toStringAsFixed(1) + " " + widget.manat:"0.0 "+widget.manat,
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(255, 0, 0, 1)),
              ),
            ),
          ),
        ),
        Container(

          child: InkWell(
            onTap: () async {
              myprice.sana<150?showAlertDialog(context): NaviPayment();
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(255, 0, 0, 1),
              ),
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10),
                      child: Text(widget.add,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white)),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
  void showAlertDialog(
      context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              widget.duydur,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        widget.jemi,
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding:
                              EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                              child: Text(
                                "OK",
                                style: TextStyle(fontSize: 16),
                              ))))
                ],
              ),
            ],
          );
        });
  }
  NaviPayment() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PaymentProduct()));
  }
}


class Counters extends StatefulWidget {
  Map<String,dynamic> arrey;
  int index;
  String manat;
  String url;
  int itemCount;
  String edit;
  String stok;
  String delet;
  Function onpress;

  Counters({
    required this.onpress,
    required this.delet,
    required this.edit,
    required this.stok,
    required this.url,
    required this.itemCount,
    required this.manat,
    required this.index,
    required this.arrey,
  });

  @override
  _CountersState createState() => _CountersState();
}

class _CountersState extends State<Counters> {
  late int sa;

  double prices = 0;
  int allPrice = 0;

  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    final mycount = Provider.of<Counter>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 130,
          height: 40,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                widget.itemCount != 1
                    ? new IconButton(
                    icon: new Icon(
                      Icons.remove,
                      color: Colors.red,
                      size: 14,
                    ),
                    onPressed: () async {
                      setState(() {
                        widget.itemCount--;
                      });

                      this.sa = (await DatabasHelper.instance
                          .getCount(widget.arrey["ID"]))!;
                      if (sa != 0) {
                        final note = Note(
                            price: widget.arrey["Price"],
                            idPro: widget.arrey["ProductId"],
                            index: widget.arrey["ID"],
                            indexpro: widget.itemCount,
                          name: widget.arrey["Ady"],
                          nameRu: widget.arrey["NameRu"],
                          brandName: widget.arrey["BrandRu"],
                          brandNameRu: widget.arrey["Brand"],
                          stok: widget.arrey["Stok"],
                          img: widget.arrey["Surat"],);
                        await DatabasHelper.instance.update(note);
                        // _showToastEdit(context);
                        _showToastEdit(context);
                        myprice.removePro(
                            widget.arrey["Price"]);
                      }
                    })
                    : new Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: new Icon(
                    Icons.remove,
                    color: Colors.black54,
                    size: 14,
                  ),
                ),
                new Text(widget.itemCount.toString()),
                widget.arrey["Stok"] >
                    widget.itemCount
                    ? new IconButton(
                    icon: new Icon(
                      Icons.add,
                      color: Colors.red,
                      size: 14,
                    ),
                    onPressed: () async {
                      setState(() {
                        widget.itemCount++;
                      });

                      if ( widget.arrey["Stok"] ==
                          widget.itemCount) {
                        _showToastEnd(context);
                      } else {
                        // _showToastEdit(context);
                        _showToastEdit(context);
                      }
                      // _showToast('Harydyň mukdary üýtgedildi');
                      this.sa = (await DatabasHelper.instance
                          .getCount( widget.arrey["ID"]))!;
                      if (sa != 0) {
                        final note = Note(
                          price: widget.arrey["Price"],
                          idPro: widget.arrey["ProductId"],
                          index: widget.arrey["ID"],
                          indexpro: widget.itemCount,
                          name: widget.arrey["Ady"],
                          nameRu: widget.arrey["NameRu"],
                          brandName: widget.arrey["BrandRu"],
                          brandNameRu: widget.arrey["Brand"],
                          stok: widget.arrey["Stok"],
                          img: widget.arrey["Surat"],);
                        await DatabasHelper.instance.update(note);
                        myprice.addpro(widget.arrey["Price"]);
                      }
                    })
                    : new Container(
                  padding: EdgeInsets.only(left: 17, right: 15),
                  child: new Icon(
                    Icons.add,
                    color: Colors.black54,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(

          child: Text(
            (widget.arrey["Price"] * widget.itemCount)
                .toStringAsFixed(1) + " " +
                widget.manat,
            style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
          ),
        ),
        InkWell(
          onTap: () async {
            widget.onpress();
            mycount.remove();
            myprice.removePro(
                widget.arrey["Price"] * widget.itemCount);
            _showToastDelet(context);
            await DatabasHelper
                .instance
                .delete((widget.arrey["ID"]),);
          },
          child: Container(
              padding:
              const EdgeInsets
                  .only(
                  right: 14),
              child:
              Icon(Icons.delete)),
        )
      ],
    );
  }

  void _showToastEdit(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(

        margin: EdgeInsets.only(bottom: 120),
        duration: Duration(milliseconds: 500),
        content: Container(width:MediaQuery.of(context).size.width,child: Text(widget.edit.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showToastDelet(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 120),
        duration: Duration(milliseconds: 500),
        content: Container(width:MediaQuery.of(context).size.width,child: Text(widget.delet.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showToastEnd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 120),
        duration: Duration(milliseconds: 500),
        content: Container(width:MediaQuery.of(context).size.width,child: Text(widget.stok.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
