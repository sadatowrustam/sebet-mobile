import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sebet/Brend_cate/brend_cate.dart';
import 'package:sebet/Sub-Categor/SubCategorPro.dart';
import 'package:sebet/categor_product/categor.dart';
import 'package:sebet/models/Brends.dart';
import 'package:http/http.dart' as http;

import 'package:sebet/models/categor.dart';
import 'package:sebet/models/language/Language.dart';

import '../IpAddress.dart';

class Kategoriya extends StatefulWidget {
  final int initialIndex;

  Kategoriya({
    required this.initialIndex,
  });

  @override
  _KategoriyaState createState() => _KategoriyaState();
}

class _KategoriyaState extends State<Kategoriya>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Future<List<Brends>>? veri;
  Future<List<Categories>>? cate;

  @override
  void initState() {
    veri = fetchAlbum();
    cate = categor();
    Langu = languageAlbum();
    super.initState();
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  Future<List<Brends>> fetchAlbum() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
    ioClient.post(Uri.parse("${IpAddres().ipAddress}/public/brands?limit=1400"));
    final response =
        await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/brands?limit=1400"));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return (json.decode(response.body) as List)
          .map((e) => Brends.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Categories>> categor() async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);

    final response = await ioClient.get(Uri.parse("${IpAddres().ipAddress}/public/categories"));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return (json.decode(response.body) as List)
          .map((e) => Categories.fromJson(e))
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

  Future<File> languageFileWrite(String yaz) async {
    var myDosya = await languageFileCreate;
    return myDosya.writeAsString(yaz);
  }

  Language? language;

  Future<Language> languageAlbum() async {
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

  Future<Language>? Langu;
  double expend = 0;
  double rotation = 0;
  int selected = 0;
  List? arrey;

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Langu,
        builder: (context, AsyncSnapshot<Language> Languag) {
          if (Languag.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white10,
                  elevation: 0,
                  toolbarHeight: 50,
                  leadingWidth: MediaQuery.of(context).size.width,
                  leading: Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: SvgPicture.asset(
                      "assets/logo/Sebet.svg",
                    ),
                  ),
                  bottom: TabBar(
                    labelColor: Color.fromRGBO(255, 0, 0, 1),
                    controller: tabController,
                    unselectedLabelColor: Color.fromRGBO(104, 109, 118, 1),
                    indicatorColor: Color.fromRGBO(255, 0, 0, 1),
                    tabs: <Tab>[
                      Tab(
                        text: Languag.data!.home.kategor,
                      ),
                      Tab(
                        text: Languag.data!.brend,
                      ),
                    ],
                  ),
                ),
                body: TabBarView(controller: tabController, children: [
                  FutureBuilder(
                      future: cate,
                      builder:
                          (context, AsyncSnapshot<List<Categories>> sonuc) {
                        if (sonuc.hasData) {
                          return ListView.builder(
                            itemCount: sonuc.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final date = sonuc.data![index];
                              final resaltLeng = 50 *
                                  (date.categorySubcategories.length.toInt());
                              return ExpansionTile(
                                textColor: Colors.black,
                                iconColor: Colors.black,
                                initiallyExpanded: false,
                                title: Text(
                                  url == 'ru'
                                      ? date.categoryNameRu
                                      : date.categoryNameTm,
                                ),
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CateProduct(
                                                      ady: url == 'ru'
                                                          ? date.categoryNameRu
                                                          : date.categoryNameTm,
                                                      tertip: 'Tertip',
                                                      id: date.categoryId,
                                                    )));
                                      },
                                      child: Container(
                                          height: 50,
                                          padding: EdgeInsets.only(left: 40),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            Languag.data!.gosmaca.hemmeSayla,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red),
                                          ))),
                                  Container(
                                    height: resaltLeng.toDouble(),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            date.categorySubcategories.length,
                                        itemBuilder: (BuildContext context,
                                            int indexCate) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: false)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          SybCate(
                                                            ady: url == 'ru'
                                                                ? date
                                                                    .categorySubcategories[
                                                                        indexCate]
                                                                    .subcategoryNameRu
                                                                : date
                                                                    .categorySubcategories[
                                                                        indexCate]
                                                                    .subcategoryNameTm,
                                                            tertip: 'Tertip',
                                                            id: date
                                                                .categorySubcategories[
                                                                    indexCate]
                                                                .subcategoryId,
                                                          )));
                                            },
                                            child: Container(
                                              height: 50,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 40),
                                                    child: Text(
                                                      url == 'ru'
                                                          ? date
                                                              .categorySubcategories[
                                                                  indexCate]
                                                              .subcategoryNameRu
                                                          : date
                                                              .categorySubcategories[
                                                                  indexCate]
                                                              .subcategoryNameTm,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: Container(
                                  child: CircularProgressIndicator(
                            color: Colors.red,
                          )));
                        }
                      }),
                  Container(
                    child: FutureBuilder(
                        future: veri,
                        builder: (context, AsyncSnapshot<List<Brends>> sonuc) {
                          if (sonuc.hasData) {
                            return FutureBuilder(
                                future: cate,
                                builder: (context,
                                    AsyncSnapshot<List<Categories>> Categor) {
                                  if (sonuc.hasData) {
                                    return GridView.count(
                                        crossAxisCount: 4,
                                        childAspectRatio: 0.8,
                                        children: List.generate(
                                          sonuc.data!.length,
                                          (san) {
                                            final date = sonuc.data![san];
                                            return Column(
                                              children: [
                                                InkWell(
                                                  child: newBrend(
                                                      date.brandPreviewImage
                                                          .toString(),
                                                      url == 'ru'
                                                          ? date.brandNameRu
                                                          : date.brandNameTm),
                                                  onTap: () {
                                                    Navigator.of(context,
                                                            rootNavigator:
                                                                false)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          BrendCate(
                                                              ady: url == 'ru'
                                                                  ? date
                                                                      .brandNameRu
                                                                  : date
                                                                      .brandNameTm,
                                                              id: date.brandId,
                                                              tertip: 'Tertip'),
                                                    ));
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ));
                                  } else {
                                    return Center(
                                        child: Container(
                                            child: CircularProgressIndicator(
                                      color: Colors.red,
                                    )));
                                  }
                                });
                          } else
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator(
                              color: Colors.red,
                            )));
                        }),
                  )
                ]));
          } else {
            return Center(
                child: Container(
                    child: CircularProgressIndicator(
              color: Colors.red,
            )));
          }
        });
  }

  Container newBrend(String img, String ady) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 0),
            color: Color.fromRGBO(221, 221, 221, 0.5))
      ]),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                child: (img.toString() != null.toString())
                    ? CachedNetworkImage(
                width: 80,height: 65,
                  imageUrl:     "${IpAddres().ipAddress}/" + img,
                  fit: BoxFit.contain,

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
                    : Image.asset("assets/images/1.jpg",width: 80,height: 65,)),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                ady,
                style: TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
