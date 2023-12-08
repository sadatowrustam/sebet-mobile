// To parse this JSON data, do
//
//     final bannerPro = bannerProFromJson(jsonString);

import 'dart:convert';

List<BannerPro> bannerProFromJson(String str) => List<BannerPro>.from(json.decode(str).map((x) => BannerPro.fromJson(x)));

String bannerProToJson(List<BannerPro> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerPro {
  BannerPro({
 required   this.id,
  required  this.bannerId,
 required   this.bannerImage,
 required   this.createdAt,
  required  this.updatedAt,
  required  this.bannerProducts,
  });

  int id;
  String bannerId;
  String bannerImage;
  DateTime createdAt;
  DateTime updatedAt;
  List<BannerProduct> bannerProducts;

  factory BannerPro.fromJson(Map<String, dynamic> json) => BannerPro(
    id: json["id"],
    bannerId: json["banner_id"],
    bannerImage: json["banner_image"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    bannerProducts: List<BannerProduct>.from(json["banner_products"].map((x) => BannerProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner_id": bannerId,
    "banner_image": bannerImage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "banner_products": List<dynamic>.from(bannerProducts.map((x) => x.toJson())),
  };
}

class BannerProduct {
  BannerProduct({
 required   this.id,
 required   this.productId,
 required   this.productCode,
  required  this.productNameTm,
 required   this.productNameRu,
 required   this.productPreviewImage,
 required   this.productImage,
 required   this.productDescriptionTm,
required    this.productDescriptionRu,
 required   this.productPrice,
 required   this.productPriceOld,
  required  this.productPriceTmt,
 required   this.productPriceTmtOld,
    required this.productPriceUsd,
 required   this.productPriceUsdOld,
 required   this.productDiscount,
  required  this.currency,
  required  this.isActive,
 required   this.categoryId,
  required  this.subcategoryId,
  required  this.brandId,
  required  this.bannerId,
  required  this.createdAt,
  required  this.updatedAt,
  });

  int id;
  String productId;
  String productCode;
  String productNameTm;
  String productNameRu;
  String productPreviewImage;
  String productImage;
  String productDescriptionTm;
  String productDescriptionRu;
  double productPrice;
  double? productPriceOld;
  double? productPriceTmt;
  double? productPriceTmtOld;
  double? productPriceUsd;
  double? productPriceUsdOld;
  double? productDiscount;
  double currency;
  bool isActive;
  int categoryId;
  int subcategoryId;
  int brandId;
  int bannerId;
  DateTime createdAt;
  DateTime updatedAt;

  factory BannerProduct.fromJson(Map<String, dynamic> json) => BannerProduct(
    id: json["id"],
    productId: json["product_id"],
    productCode: json["product_code"],
    productNameTm: json["product_name_tm"],
    productNameRu: json["product_name_ru"],
    productPreviewImage: json["product_preview_image"],
    productImage: json["product_image"],
    productDescriptionTm: json["product_description_tm"],
    productDescriptionRu: json["product_description_ru"],
    productPrice: json["product_price"].toDouble(),
    productPriceOld: json["product_price_old"]== null ? null : json["product_price_old"].toDouble(),
    productPriceTmt: json["product_price_tmt"].toDouble(),
    productPriceTmtOld: json["product_price_tmt_old"]== null ? null : json["product_price_tmt_old"].toDouble(),
    productPriceUsd: json["product_price_usd"]== null ? null : json["product_price_usd"].toDouble(),
    productPriceUsdOld: json["product_price_usd_old"]== null ? null : json["product_price_usd_old"].toDouble(),
    productDiscount: json["product_discount"]== null ? null : json["product_discount"].toDouble(),
    currency: json["currency"].toDouble(),
    isActive: json["isActive"],
    categoryId: json["categoryId"],
    subcategoryId: json["subcategoryId"],
    brandId: json["brandId"],
    bannerId: json["bannerId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "product_code": productCode,
    "product_name_tm": productNameTm,
    "product_name_ru": productNameRu,
    "product_preview_image": productPreviewImage,
    "product_image": productImage,
    "product_description_tm": productDescriptionTm,
    "product_description_ru": productDescriptionRu,
    "product_price": productPrice,
    "product_price_old": productPriceOld,
    "product_price_tmt": productPriceTmt,
    "product_price_tmt_old": productPriceTmtOld,
    "product_price_usd": productPriceUsd,
    "product_price_usd_old": productPriceUsdOld,
    "product_discount": productDiscount,
    "currency": currency,
    "isActive": isActive,
    "categoryId": categoryId,
    "subcategoryId": subcategoryId,
    "brandId": brandId,
    "bannerId": bannerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
