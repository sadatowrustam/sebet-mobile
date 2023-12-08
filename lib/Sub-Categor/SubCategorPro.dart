import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/Product-detalis/details.dart';
import 'package:sebet/models/DatabaseHelper/databaseHelper.dart';
import 'package:sebet/models/DatabaseHelper/note.dart';
import 'package:sebet/models/SubCategorPro.dart';
import 'package:sebet/models/Top_product/top_product.dart';

import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';


class SybCate extends StatefulWidget {
  String id;
  String ady;

  String tertip;

  SybCate({required this.tertip, required this.ady, required this.id});

  _SybCateState createState() => _SybCateState();
}

class _SybCateState extends State<SybCate> {
  var _saylananTertip;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List newData = [];
  double san = 0;
  int surRaz = 0;
  Future<List<SubCatePro>>? veri;
  TopProduct? topProduct;
  String? url;

  late int sa;
  int? count;
  String? text;

  Future<String> get LanguageFile async {
    Directory dosyaPath = await getApplicationDocumentsDirectory();

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

  Future<Language>? Lang;
  var sayla;

  @override
  void initState() {
    debugPrint(widget.tertip);
    _saylananTertip = widget.tertip;
    Lang = LanguageAlbum();
    veri = fetchAlbum();

    text = widget.ady;
    super.initState();
  }

  String baha = "";

  Future<List<SubCatePro>> fetchAlbum() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await  ioClient.get(Uri.parse(widget.tertip == 'true'
        ? "${IpAddres().ipAddress}/public/sub-categories/products/${widget.id}?sort=0&limit=2000"
        : widget.tertip == 'false'
        ? "${IpAddres().ipAddress}/public/sub-categories/products/${widget.id}?sort=1&limit=2000"
        : "${IpAddres().ipAddress}/public/sub-categories/products/${widget.id}?limit=2000"));
    debugPrint(response.body);
    if (response.statusCode == 200) {
      // debugPrint(response.body);
      // return Yuk.fromJsonMap(jsonDecode(response.body));

      return (json.decode(response.body) as List)
          .map((e) => SubCatePro.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  int sana = 0;

  @override
  Widget build(BuildContext contex) {

    return SafeArea(
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        // endDrawer: DrawerMenu(),
        body: RefreshIndicator(
          onRefresh: _refrest,
          child: Container(
            color: Colors.white,
            child: FutureBuilder(
                future: Lang,
                builder: (context, AsyncSnapshot<Language> Langu) {
                  if (Langu.hasData) {
                    return Column(
                      children: [
                        Column(children: [
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 21, left: 13, bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset("assets/icon/left.svg"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(widget.ady),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder(
                                    future: veri,
                                    builder: (context,
                                        AsyncSnapshot<List<SubCatePro>> sonuc) {
                                      if (sonuc.hasData) {
                                        return Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Langu.data!.orders.jemi,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                sonuc.data!.length.toString() +
                                                    " " +
                                                    Langu.data!.perewod.sany +
                                                    " " +
                                                    Langu.data!.gosmaca.haryt.toLowerCase(),
                                                style: TextStyle(fontSize: 16),
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 13),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          30,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1)),
                                      child: DropdownButton(
                                        underline: DropdownButtonHideUnderline(
                                          child: Container(),
                                        ),
                                        items: [
                                          DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 10,
                                                            top: 12,
                                                            bottom: 14),
                                                    child: SvgPicture.asset(
                                                        "assets/icon/tertip.svg"),
                                                  ),
                                                  Text(
                                                    Langu.data!.tertip,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              value: 'Tertip'),
                                          DropdownMenuItem(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          top: 12,
                                                          bottom: 14),
                                                ),
                                                Text(
                                                  Langu.data!.gosmaca.arzan,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            value: 'true',
                                          ),
                                          DropdownMenuItem(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10,
                                                          top: 12,
                                                          bottom: 14),
                                                ),
                                                Text(
                                                  Langu.data!.gosmaca.gymmat,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )
                                              ],
                                            ),
                                            value: 'false',
                                          )
                                        ],
                                        onChanged: (val) {
                                          setState(() {
                                            _saylananTertip = val.toString();

                                            _refrest();
                                          });
                                        },
                                        hint: Text("Birini sayla"),
                                        value: _saylananTertip,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                        FutureBuilder(
                            future: veri,
                            builder: (context,
                                AsyncSnapshot<List<SubCatePro>> sonuc) {
                              debugPrint(sonuc.data.toString());
                              debugPrint(_saylananTertip);
                              if (sonuc.hasData) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height - 150,
                                  child: GridView.count(
                                  crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              children: List.generate(sonuc.data!.length, (index) {
                                      final date = sonuc.data![index];

                                      return InkWell(
                                        child:  Container(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 4),
                                                  child: CheckState(add:
                                                  Langu.data!.perewod.add,
                                                    delete: Langu
                                                        .data!.perewod.delete,
                                                    change: Langu
                                                        .data!.perewod.change,
                                                    end:
                                                    Langu.data!.perewod.end,
                                                    addcard: Langu
                                                        .data!.perewod.addcard,
                                                      id: date.id,
                                                      baharz: date
                                                          .productPriceOld
                                                          .toString(),
                                                      arz: date.productDiscount
                                                          .toString(),
                                                      img: date.productImage
                                                          .toString(),
                                                      baha: date.productPrice,
                                                      ady: url == "ru"
                                                          ? date.productNameRu
                                                          : date.productNameTm, idPro: date.productId, stok: date.productStock
                                                      .stockQuantity, arrey: date,),
                                                ),
                                              ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailAll(
                                                        pro: date,
                                                        indexpro:
                                                            date.id.toInt(),
                                                      )));
                                        },
                                      );
                                    },
                                  ),
                                ));
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height - 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: CircularProgressIndicator(
                                        color: Colors.red,
                                      )),
                                    ],
                                  ),
                                );
                              }
                            })
                      ],
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height - 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          )),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _refrest() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => SybCate(
                  ady: text.toString(),
                  tertip: _saylananTertip,
                  id: widget.id,
                ),
            transitionDuration: Duration(seconds: 0)));
  }
}

class CheckState extends StatefulWidget {
  String img;
  String arz;
  String ady;
  double baha;
  String baharz;
  int id;
 String idPro;
 int stok;String add;
  String change;
  String delete;
  String end;
  String addcard;
  SubCatePro arrey;
  CheckState(
      {required this.arrey,required this.delete,
        required this.end,
        required this.change,
        required this.addcard,
        required this.add,required this.idPro,required this.stok,required this.id,
      required this.baharz,
      required this.arz,
      required this.img,
      required this.baha,
      required this.ady});

  @override
  _CheckStateState createState() => _CheckStateState();
}

class _CheckStateState extends State<CheckState> {
  int _itemCount = 0;
  List? search;
  Future? work;

  Future<List<Map>> fetchEmployeesFromDatabase() async {
    return await DatabasHelper.instance.getCountList(widget.id);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Map>>(
        future: fetchEmployeesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _itemCount =
                snapshot.data!.length == 0 ? 0 : snapshot.data![0]['SANY'];
            return Container(
              child: SubProduct(add: widget.add,
                change: widget.change,
                delete: widget.delete,
                end: widget.end,
                addcard: widget.addcard,
                id: widget.id,
                baharz: widget.baharz,
                arz: widget.arz,
                img: widget.img,
                baha: widget.baha,
                itemCount: _itemCount,
                ady: widget.ady, stock: widget.stok, idPro: widget.idPro,
                arrey: widget.arrey,
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height - 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  )),
                ],
              ),
            );
          }
        });
  }
}

class SubProduct extends StatefulWidget {
  String img;
  String arz;
  String ady;
  double baha;
  String baharz;
  int id;
  int itemCount;
  String idPro;
  int stock;
  String add;
  String change;
  String delete;
  String end;
  String addcard;
  SubCatePro arrey;
  SubProduct(
      {required this.arrey,required this.delete,
        required this.end,
        required this.change,
        required this.addcard,
        required this.add,required this.idPro,
      required this.stock,
      required this.itemCount,
      required this.id,
      required this.baharz,
      required this.arz,
      required this.img,
      required this.baha,
      required this.ady});

  _SubProductState createState() => _SubProductState();
}

class _SubProductState extends State<SubProduct> {
  late int sa;

  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    final mycount=Provider.of<Counter>(context);
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 0),
            color: Color.fromRGBO(221, 221, 221, 0.5))
      ]),
      child: Center(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(
              elevation: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: (widget.img != null)
                                ? CachedNetworkImage(
                              imageUrl:     "${IpAddres().ipAddress}/" + widget.img,
                              fit: BoxFit.contain,
                              height: 170,
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
                                : Image.asset("assets/images/1.jpg")),
                        widget.arz != "null"
                            ? Positioned(
                                right: 10,
                                top: 11,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromRGBO(255, 0, 0, 1)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.arz+ "%",
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            widget.ady,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, left: 7, bottom: 10),
                          child: Text(
                            widget.baha.toStringAsFixed(1)+ " m",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.baharz != "null"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 12),
                                child: Text(
                                  widget.baharz+ " m",
                                  style: TextStyle(
                                      color: Color.fromRGBO(104, 109, 118, 1),
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 25,
                      height: 40,
                      child: widget.itemCount != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new IconButton(
                                    icon: new Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                      size: 12,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        widget.itemCount--;
                                      });
                                      if (widget.itemCount != 0) {
                                        _showToastEdit(context);
                                      }
                                      myprice.removePro(widget.baha);
                                      this.sa = (await DatabasHelper.instance
                                          .getCount(widget.id))!;
                                      if (sa != 0) {
                                        final note = Note(
                                          idPro: widget.idPro,
                                          index: widget.id,
                                          indexpro: widget.itemCount,
                                          price: widget.baha,
                                          name: widget.arrey.productNameTm,
                                          nameRu: widget.arrey.productNameRu,
                                          brandName: widget.arrey.brand.brandNameTm,
                                          brandNameRu: widget.arrey.brand.brandNameRu,
                                          stok: widget.arrey.productStock.stockQuantity,
                                          img: widget.arrey.productImage,);
                                        await DatabasHelper.instance
                                            .update(note);

                                      }
                                      if (widget.itemCount == 0) {
                                        await DatabasHelper.instance
                                            .delete(widget.id);
                                        _showToastDelete(context);
                                        mycount.remove();

                                      }
                                    }),
                                new Text(widget.itemCount.toString()),
                                widget.stock > widget.itemCount  ?    new IconButton(
                                    icon: new Icon(
                                      Icons.add,
                                      color: Colors.red,
                                      size: 12,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        widget.itemCount++;
                                      });
                                      if (widget.stock ==
                                          widget.itemCount) {
                                        _showToastEnd(context);
                                      } else {
                                        _showToastEdit(context);
                                      }
                                      this.sa = (await DatabasHelper.instance
                                          .getCount(widget.id))!;
                                      if (sa != 0) {
                                        final note = Note(
                                          idPro: widget.idPro,
                                          index: widget.id,
                                          indexpro: widget.itemCount,
                                          price: widget.baha,
                                          name: widget.arrey.productNameTm,
                                          nameRu: widget.arrey.productNameRu,
                                          brandName: widget.arrey.brand.brandNameTm,
                                          brandNameRu: widget.arrey.brand.brandNameRu,
                                          stok: widget.arrey.productStock.stockQuantity,
                                          img: widget.arrey.productImage,);
                                        await DatabasHelper.instance
                                            .update(note);
                                        myprice.addpro(widget.baha);

                                      }
                                    }):Container(
                                  padding: EdgeInsets.only(
                                      left: 17, right: 15),
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.black54,
                                    size: 14,
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  widget.itemCount = 1;
                                });
                                this.sa = (await DatabasHelper.instance
                                    .getCount(widget.id))!;
                                if (sa == 0) {
                                  final note = Note(
                                    idPro: widget.idPro,
                                    index: widget.id,
                                    indexpro: widget.itemCount,
                                    price: widget.baha,
                                    name: widget.arrey.productNameTm,
                                    nameRu: widget.arrey.productNameRu,
                                    brandName: widget.arrey.brand.brandNameTm,
                                    brandNameRu: widget.arrey.brand.brandNameRu,
                                    stok: widget.arrey.productStock.stockQuantity,
                                    img: widget.arrey.productImage,);
                                  await DatabasHelper.instance.insert(note);
                                  _showToastAdd(context);
                                  myprice.addpro(widget.baha);
                                  mycount.addpro();
                                }
                              },
                              child: Card(
                                elevation: 1,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            25,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_cart_rounded,
                                            color: Colors.red,size: 16,),
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              widget.add,
                                              style:
                                                  TextStyle(color: Colors.red,fontSize: 11),
                                            ))
                                      ],
                                    )),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showToastEdit(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(widget.change),

      ),
    );
  }

  void _showToastDelete(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(widget.delete),
      ),
    );
  }

  void _showToastAdd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(widget.add),
      ),
    );
  }

  void _showToastEnd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content:  Text(widget.end),
      ),
    );
  }
}
