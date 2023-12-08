import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/BannerProduct/BannerProduct.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/Product-detalis/details.dart';
import 'package:sebet/Search/Search.dart';
import 'package:sebet/arz/arzan.dart';
import 'package:http/http.dart' as http;
import 'package:sebet/main.dart';
import 'package:sebet/models/Banner.dart';
import 'package:sebet/models/DatabaseHelper/databaseHelper.dart';
import 'package:sebet/models/DatabaseHelper/note.dart';
import 'package:sebet/models/Top_product/top_product.dart';
import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';

class AnaEkran extends StatefulWidget {
  AnaEkran(Key k) : super(key: k);

  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  double san = 0;

  Future<TopProduct>? veri;
  Future<List<BannerPro>>? bannerProduct;

  @override
  void initState() {
    bannerProduct = bannerAlbum();
    lang = languageAlbum();
    veri = fetchAlbum();
    super.initState();
  }

  int a = 5;
  TopProduct? topProduct;

  Future<TopProduct> fetchAlbum() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/top-products"));

    var decodedJson = json.decode(response.body);
    topProduct = TopProduct.fromJson(decodedJson);

    return topProduct!;
  }

  int currentPos = 0;

  Future<List<BannerPro>> bannerAlbum() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response =
        await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/banners"));;

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => BannerPro.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
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

  Language? language;

  Future<Language> languageAlbum() async {
    await languageFileRead().then((value) {
      url = value;
    });
    var giveJson = await DefaultAssetBundle.of(context).loadString(
        url == "ru" ? "assets/language/ru.json" : "assets/language/tk.json");
    var decodedJson = json.decode(giveJson);
    language = Language.fromJson(decodedJson);

    return language!;
  }

  Future<Language>? lang;
  final TextEditingController _search = TextEditingController();

  @override
  refreshNotes() async {
    List<Map<String, dynamic>> son = await DatabasHelper.instance.tumProduct();
    debugPrint(son.toString());
    return son;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: FutureBuilder(
              future: veri,
              builder: (context, AsyncSnapshot<TopProduct> sonuc) {
                if (sonuc.hasData) {
                  return FutureBuilder(
                      future: lang,
                      builder: (context, AsyncSnapshot<Language> Lan) {
                        if (Lan.hasData) {
                          return CustomScrollView(slivers: [
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Column(children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 13,
                                            top: 15,
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/logo/Sebet.svg"),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          right: 10,
                                          left: 10,
                                          bottom: 10),
                                      child: TextField(
                                        enableSuggestions: false,
                                        
                                        enableInteractiveSelection: false,
                                        controller: _search,
                                        cursorColor:
                                            Color.fromRGBO(104, 109, 118, 1),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.search,
                                        autofocus: false,
                                        onEditingComplete: () {
                                          FocusManager.instance.primaryFocus!
                                              .unfocus();
                                          searchMettod();
                                        },
                                        decoration: InputDecoration(
                                            hintText: Lan.data!.home.haryt,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            suffixIcon: Icon(
                                              Icons.search,
                                              color: Color.fromRGBO(
                                                  104, 109, 118, 1),
                                            ),
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                230, 230, 230, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                                FutureBuilder(
                                    future: bannerProduct,
                                    builder: (context,
                                        AsyncSnapshot<List<BannerPro>> Banner) {
                                      if (Banner.hasData) {
                                        return Column(
                                          children: [
                                            CarouselSlider.builder(
                                              itemCount: Banner.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int itemIndex,
                                                          int pageViewIndex) =>
                                                      Container(
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: (Banner
                                                                .data![
                                                                    itemIndex]
                                                                .bannerImage !=
                                                            null)
                                                        ? InkWell(
                                                            onTap: () {
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          BannerProductAll(
                                                                            pro:
                                                                                Banner.data![itemIndex],
                                                                          )));
                                                            },
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: "${IpAddres().ipAddress}/" +
                                                                  Banner
                                                                      .data![
                                                                          itemIndex]
                                                                      .bannerImage,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .red,
                                                                      )),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                      "assets/images/1.jpg"),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            "assets/images/1.jpg")),
                                              ),
                                              options: CarouselOptions(
                                                viewportFraction: 1,
                                                height: 200,
                                                aspectRatio: 16 / 9,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    currentPos = index;
                                                  });
                                                },
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                reverse: false,
                                                autoPlay: true,
                                                autoPlayInterval:
                                                    Duration(seconds: 10),
                                                autoPlayAnimationDuration:
                                                    Duration(milliseconds: 800),
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enlargeCenterPage: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: Banner.data!.map((url) {
                                                int index =
                                                    Banner.data!.indexOf(url);
                                                return Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 3.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: currentPos == index
                                                        ? Color.fromRGBO(
                                                            0, 0, 0, 0.9)
                                                        : Color.fromRGBO(
                                                            0, 0, 0, 0.4),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              140,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: Colors.red,
                                              )),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyApp(2)),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: newBrend(Lan.data!.home.kategor,
                                            "assets/icon/catog.svg")),
                                    InkWell(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyApp(3)),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: newBrend(Lan.data!.brend,
                                            "assets/icon/brend.svg")),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 13, right: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Lan.data!.home.arzan,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => ArzBaha(
                                                        tertip: "Tertip",
                                                      )));
                                        },
                                        child: Row(children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              Lan.data!.home.ahlisi,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7, top: 8),
                                            child: Container(
                                                width: 7,
                                                height: 8,
                                                child: SvgPicture.asset(
                                                    "assets/icon/cyzyk.svg")),
                                          )
                                        ]),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ])),
                            SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65),
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                final date =
                                    sonuc.data!.data.newProducts[index];

                                return InkWell(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 9, right: 4),
                                      child: CheckStateBody(
                                        img: date.productImage.toString(),
                                        arz: date.productDiscount.toString(),
                                        ad: url == 'ru'
                                            ? date.productNameRu
                                            : date.productNameTm,
                                        id: date.id,
                                        baharz: date.productPriceOld.toString(),
                                        baha: date.productPrice.toDouble(),
                                        index: index,
                                        arrey: sonuc.data!.data.newProducts,
                                        stock: date.productStock.stockQuantity,
                                        productid: date.productId,
                                        add: Lan.data!.perewod.add,
                                        delete: Lan.data!.perewod.delete,
                                        change: Lan.data!.perewod.change,
                                        end: Lan.data!.perewod.end,
                                        addcard: Lan.data!.perewod.addcard,
                                      )),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => DetailAll(
                                                pro: date, indexpro: date.id)));
                                  },
                                );
                              },
                                  childCount:
                                      sonuc.data!.data.newProducts.length),
                            )
                          ]);
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
      ),
    );
  }

  searchMettod() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(
        builder: (context) => SearchClass(
              tertip: 'Tertip',
              control: _search.text,
            )));
  }

  Padding newBrend(String ady, String img) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 8, top: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(230, 230, 230, 1),
        ),
        height: 40,
        width: MediaQuery.of(context).size.width / 2 - 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(right: 10),
                child: SvgPicture.asset(
                  img,
                  alignment: Alignment.center,
                  width: 15,
                  height: 15,
                )),
            Container(
                child: Text(
              ady,
              style: TextStyle(fontSize: 12),
            )),
          ],
        ),
      ),
    );
  }
}

class CheckStateBody extends StatefulWidget {
  List<NewProduct> arrey;
  String img;
  String arz;
  String ad;
  double baha;
  int index;
  String baharz;
  int id;
  int stock;
  String productid;
  String add;
  String change;
  String delete;
  String end;
  String addcard;

  CheckStateBody(
      {required this.delete,
      required this.end,
      required this.change,
      required this.addcard,
      required this.add,
      required this.productid,
      required this.stock,
      required this.arrey,
      required this.index,
      required this.img,
      required this.arz,
      required this.ad,
      required this.baha,
      required this.id,
      required this.baharz});

  @override
  _CheckStateBodyState createState() => _CheckStateBodyState();
}

class _CheckStateBodyState extends State<CheckStateBody> {
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
              child: ProductCount(
                id: widget.id,
                baharz: widget.baharz,
                arz: widget.arz,
                img: widget.img,
                baha: widget.baha,
                ad: widget.ad,
                itemCount: _itemCount,
                index: widget.index,
                arrey: widget.arrey,
                stock: widget.stock,
                productId: widget.productid,
                add: widget.add,
                change: widget.change,
                delete: widget.delete,
                end: widget.end,
                addcard: widget.addcard,
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

class ProductCount extends StatefulWidget {
  List<NewProduct> arrey;
  String img;
  String arz;
  String ad;
  double baha;
  int index;
  String baharz;
  int id;
  int itemCount;
  int stock;
  String productId;
  String add;
  String change;
  String delete;
  String end;
  String addcard;

  ProductCount(
      {required this.delete,
      required this.end,
      required this.change,
      required this.addcard,
      required this.add,
      required this.productId,
      required this.stock,
      required this.itemCount,
      required this.arrey,
      required this.index,
      required this.img,
      required this.arz,
      required this.ad,
      required this.baha,
      required this.id,
      required this.baharz});

  @override
  _ProductCountState createState() => _ProductCountState();
}

class _ProductCountState extends State<ProductCount> {
  // List? son;
  Future? sal;

  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast.init(context);
  }

  List? son;

  late int sa;
  List? search;

  Future<List<Map>> fetchEmployeesFromDatabase() async {
    return await DatabasHelper.instance.getCountList(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    final mycount = Provider.of<Counter>(context);
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
                                    imageUrl: "${IpAddres().ipAddress}/" +
                                        widget.img,

                                    errorWidget: (context, url, error) =>
                                        Image.asset("assets/images/1.jpg"),
                                    height: 170,
                                    fit: BoxFit.contain,
                                  )
                                : Image.asset("assets/images/spinner.gif")),
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
                                      widget.arz + "%",
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
                            widget.ad,
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
                          padding:
                              const EdgeInsets.only(top: 8, left: 7, bottom: 5),
                          child: Text(
                            widget.baha.toStringAsFixed(1) + " m",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.baharz != "null"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 8, bottom: 5),
                                child: Text(
                                  widget.baharz + " m",
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
                                        // _showToast(
                                        //     'Harydyň mukdary üýtgedildi');
                                      }

                                      this.sa = (await DatabasHelper.instance
                                          .getCount(widget.id))!;
                                      if (sa != 0) {
                                        final note = Note(
                                          idPro: widget.productId,
                                          index: widget.id,
                                          indexpro: widget.itemCount,
                                          price: widget.baha,
                                          name: widget.arrey[widget.index]
                                              .productNameTm,
                                          nameRu: widget.arrey[widget.index]
                                              .productNameRu,
                                          brandName: widget.arrey[widget.index]
                                              .brand.brandNameTm,
                                          brandNameRu: widget
                                              .arrey[widget.index]
                                              .brand
                                              .brandNameRu,
                                          stok: widget.arrey[widget.index]
                                              .productStock.stockQuantity,
                                          img: widget
                                              .arrey[widget.index].productImage,
                                        );
                                        await DatabasHelper.instance
                                            .update(note);
                                      }
                                      myprice.removePro(widget.baha);
                                      if (widget.itemCount == 0) {
                                        await DatabasHelper.instance
                                            .delete(widget.id);

                                        _showToastDelete(context);
                                        mycount.remove();
                                        // _showToast('Haryt Sebetden ayryldy');
                                      }
                                    }),
                                new Text(widget.itemCount.toString()),
                                widget.stock > widget.itemCount
                                    ? new IconButton(
                                        icon: new Icon(
                                          Icons.add,
                                          color: Colors.red,
                                          size: 12,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            widget.itemCount++;
                                          });
                                          if (widget.arrey[widget.index]
                                                  .productStock.stockQuantity ==
                                              widget.itemCount) {
                                            _showToastEnd(context);
                                          } else {
                                            _showToastEdit(context);
                                          }

                                          this.sa = (await DatabasHelper
                                              .instance
                                              .getCount(widget.id))!;
                                          if (sa != 0) {
                                            final note = Note(
                                              idPro: widget.productId,
                                              index: widget.id,
                                              indexpro: widget.itemCount,
                                              price: widget.baha,
                                              name: widget.arrey[widget.index]
                                                  .productNameTm,
                                              nameRu: widget.arrey[widget.index]
                                                  .productNameRu,
                                              brandName: widget
                                                  .arrey[widget.index]
                                                  .brand
                                                  .brandNameTm,
                                              brandNameRu: widget
                                                  .arrey[widget.index]
                                                  .brand
                                                  .brandNameRu,
                                              stok: widget.arrey[widget.index]
                                                  .productStock.stockQuantity,
                                              img: widget.arrey[widget.index]
                                                  .productImage,
                                            );
                                            await DatabasHelper.instance
                                                .update(note);
                                            myprice.addpro(widget.baha);
                                            // 'Harydyň mukdary üýtgedildi');
                                          }
                                        })
                                    : Container(
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
                                    idPro: widget.productId,
                                    index: widget.id,
                                    indexpro: widget.itemCount,
                                    price: widget.baha,
                                    name: widget
                                        .arrey[widget.index].productNameTm,
                                    nameRu: widget
                                        .arrey[widget.index].productNameRu,
                                    brandName: widget
                                        .arrey[widget.index].brand.brandNameTm,
                                    brandNameRu: widget
                                        .arrey[widget.index].brand.brandNameRu,
                                    stok: widget.arrey[widget.index]
                                        .productStock.stockQuantity,
                                    img:
                                        widget.arrey[widget.index].productImage,
                                  );
                                  await DatabasHelper.instance.insert(note);
                                  mycount.addpro();
                                  myprice.addpro(widget.baha);
                                  _showToastAdd(context);
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
                                        Icon(
                                          Icons.shopping_cart_rounded,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              widget.add,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 11),
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
        margin: EdgeInsets.only(bottom: 50),
        duration: Duration(milliseconds: 500),
        content: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(widget.change.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showToastDelete(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 50),
        duration: Duration(milliseconds: 500),
        content: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(widget.delete.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showToastAdd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 50),
        duration: Duration(milliseconds: 500),
        content: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(widget.addcard.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showToastEnd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 50),
        duration: Duration(milliseconds: 500),
        content: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(widget.end.toString())),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
