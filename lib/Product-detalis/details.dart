import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sebet/Count.dart';
import 'package:sebet/IpAddress.dart';
import 'package:sebet/Price.dart';
import 'package:sebet/models/DatabaseHelper/databaseHelper.dart';
import 'package:sebet/models/DatabaseHelper/note.dart';
import 'package:sebet/models/language/Language.dart';
import 'package:sebet/photo/photo.dart';

class DetailAll extends StatefulWidget {
  var pro;
  int indexpro;
String? BrendName;
  DetailAll({required this.pro, required this.indexpro,this.BrendName});

  @override
  _DetailAllState createState() => _DetailAllState();
}

class _DetailAllState extends State<DetailAll> {
  int _itemCount = 0;
  List? search;
  Future? work;

  Future<List<Map>> fetchEmployeesFromDatabase() async {
    return await DatabasHelper.instance.getCountList(widget.pro.id);
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
              child: DetailsProduct(
                indexpro: widget.indexpro,
                pro: widget.pro,
                indexCount: _itemCount,
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

class DetailsProduct extends StatefulWidget {
  var pro;
  int indexpro;
  int indexCount;

  DetailsProduct(
      {required this.indexCount, required this.pro, required this.indexpro});

  @override
  _DetailsProductState createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  @override
  late Note notes;
  late int sa;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    veri = fetchAlbum();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    this.sa = (await DatabasHelper.instance.getCount(widget.indexpro))!;
    setState(() {
      isLoading = false;
    });
  }

  Future<Language>? veri;
  int sany = 0;
  bool dog = false;
  int san = 0;

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

  String? url;

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

  String? add;
  String? edit;
  String? delete;
  String? stok;

  @override
  Widget build(BuildContext context) {
    final myprice = Provider.of<Price>(context);
    final mycount = Provider.of<Counter>(context);

    return Scaffold(
        body: FutureBuilder(
            future: veri,
            builder: (context, AsyncSnapshot<Language> sonuc) {
              if (sonuc.hasData) {
                return ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 21, left: 14),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icon/left.svg"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(url == "ru"
                                        ? widget.pro.productNameRu
                                        : widget.pro.productNameTm),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Photo(name: url == "ru"
                                          ? widget.pro.productNameRu
                                          : widget.pro.productNameTm, img: widget.pro.productImage,
                                          )));
                            },
                            child: Container(
                                height: 340,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    top: 26, left: 14, right: 16, bottom: 16),
                                child: (widget.pro.productImage != null)
                                    ? CachedNetworkImage(
                                        imageUrl: "${IpAddres().ipAddress}/" +
                                            widget.pro.productImage,
                                        height: 350,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => Container(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              color: Colors.red,
                                            )),
                                        errorWidget: (context, url, error) =>
                                            Image.asset("assets/images/1.jpg"),
                                      )
                                    : Image.asset("assets/images/1.jpg")),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  url == 'ru'
                                      ? widget.pro.productDescriptionRu
                                      : widget.pro.productDescriptionTm,
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 30),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  url == 'ru'
                                      ? widget.pro.productNameRu
                                      : widget.pro.productNameTm,
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 14, top: 30),
                            child: Row(
                              children: [
                                Text(
                                  widget.pro.productPrice.toStringAsFixed(1) + " m",
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      fontSize: 24),
                                ),
                                widget.pro.productPriceOld.toString() != "null"
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: Text(
                                          widget.pro.productPriceOld
                                                  .toStringAsFixed(1) +
                                              " m",
                                          style: TextStyle(
                                              fontSize: 20,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),

                          Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 16, top: 30),
                              width: MediaQuery.of(context).size.width,
                              child: widget.indexCount != 0
                                  ? Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          new IconButton(
                                              icon: new Icon(
                                                Icons.remove,
                                                color: Colors.red,
                                                size: 12,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  widget.indexCount--;
                                                });
                                                add =
                                                    sonuc.data!.perewod.addcard;
                                                edit =
                                                    sonuc.data!.perewod.change;
                                                delete =
                                                    sonuc.data!.perewod.delete;
                                                stok = sonuc.data!.perewod.end;
                                                if (widget.indexCount != 0) {
                                                  _showToastEdit(context);
                                                  // _showToast(
                                                  //     'Harydyň mukdary üýtgedildi');
                                                }

                                                this.sa = (await DatabasHelper
                                                    .instance
                                                    .getCount(
                                                        widget.indexpro))!;
                                                if (sa != 0) {
                                                  final note = Note(
                                                      name: widget.pro.productNameTm,
                                                      nameRu: widget.pro.productNameRu,
                                                      brandName: widget.pro.brand.brandNameTm,
                                                      brandNameRu: widget.pro.brand.brandNameRu,
                                                      stok: widget.pro.productStock.stockQuantity,
                                                      img: widget.pro.productImage,
                                                      price:   widget.pro.productPrice,
                                                      idPro: widget.pro.productId,
                                                      index: widget.indexpro,
                                                      indexpro: widget.indexCount);
                                                  await DatabasHelper.instance
                                                      .update(note);
                                                  myprice.removePro(
                                                    widget.pro.productPrice,
                                                  );
                                                }

                                                if (widget.indexCount == 0) {
                                                  await DatabasHelper.instance
                                                      .delete(widget.indexpro);

                                                  _showToastDelete(context);
                                                  mycount.remove();
                                                  // _showToast('Haryt Sebetden ayryldy');
                                                }
                                              }),
                                          new Text(
                                              widget.indexCount.toString()),
                                          widget.pro.productStock
                                                      .stockQuantity >
                                                  widget.indexCount
                                              ? new IconButton(
                                                  icon: new Icon(
                                                    Icons.add,
                                                    color: Colors.red,
                                                    size: 12,
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      widget.indexCount++;
                                                    });
                                                    if (widget.pro.productStock
                                                            .stockQuantity ==
                                                        widget.indexCount) {
                                                      _showToastEnd(context);
                                                    } else {
                                                      _showToastEdit(context);
                                                    }
                                                    add = sonuc
                                                        .data!.perewod.addcard;
                                                    edit = sonuc
                                                        .data!.perewod.change;
                                                    delete = sonuc
                                                        .data!.perewod.delete;
                                                    stok =
                                                        sonuc.data!.perewod.end;
                                                    this.sa =
                                                        (await DatabasHelper
                                                            .instance
                                                            .getCount(widget
                                                                .indexpro))!;
                                                    if (sa != 0) {
                                                      final note = Note(
                                                          name: widget.pro.productNameTm,
                                                          nameRu: widget.pro.productNameRu,
                                                          brandName: widget.pro.brand.brandNameTm,
                                                          brandNameRu: widget.pro.brand.brandNameRu,
                                                          stok: widget.pro.productStock.stockQuantity,
                                                          img: widget.pro.productImage,
                                                          price:   widget.pro.productPrice,
                                                          idPro: widget.pro.productId,
                                                          index: widget.indexpro,
                                                          indexpro: widget.indexCount);
                                                      await DatabasHelper
                                                          .instance
                                                          .update(note);
                                                      myprice.addpro(
                                                        widget.pro.productPrice,
                                                      );
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
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        setState(() {
                                          widget.indexCount = 1;
                                        });
                                        add = sonuc.data!.perewod.addcard;
                                        edit = sonuc.data!.perewod.change;
                                        delete = sonuc.data!.perewod.delete;
                                        stok = sonuc.data!.perewod.end;
                                        this.sa = (await DatabasHelper.instance
                                            .getCount(widget.indexpro))!;
                                        if (sa == 0) {
                                          final note = Note(
                                              name: widget.pro.productNameTm,
                                              nameRu: widget.pro.productNameRu,
                                              brandName: widget.pro.brand.brandNameTm,
                                              brandNameRu: widget.pro.brand.brandNameRu,
                                              stok: widget.pro.productStock.stockQuantity,
                                              img: widget.pro.productImage,
                                              price:   widget.pro.productPrice,
                                              idPro: widget.pro.productId,
                                              index: widget.indexpro,
                                              indexpro: widget.indexCount
                                          );
                                          await DatabasHelper.instance
                                              .insert(note);
                                          mycount.addpro();
                                          myprice.addpro(
                                            widget.pro.productPrice,
                                          );
                                          _showToastAdd(context);
                                        }
                                      },
                                      child: Card(
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        elevation: 1,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                25,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icon/aksebet.svg"),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                      sonuc.data!.perewod.add,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                )
                                              ],
                                            )),
                                      ),
                                    ))
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
            }));
  }

  void _showToastEdit(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(edit.toString()),
      ),
    );
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

  void _showToastAdd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(add.toString()),
      ),
    );
  }

  void _showToastEnd(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(stok.toString()),
      ),
    );
  }
}
