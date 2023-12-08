// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'dart:convert';

List<Search> searchFromJson(String str) => List<Search>.from(json.decode(str).map((x) => Search.fromJson(x)));

String searchToJson(List<Search> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Search {
  Search({
  required  this.id,
  required  this.productId,
  required  this.productCode,
  required  this.productNameTm,
  required  this.productNameRu,
  required  this.productPreviewImage,
  required  this.productImage,
  required  this.productDescriptionTm,
  required  this.productDescriptionRu,
  required  this.productPrice,
  required  this.productPriceOld,
  required  this.productPriceTmt,
  required  this.productPriceTmtOld,
 required   this.productPriceUsd,
    this.productPriceUsdOld,
  required  this.productDiscount,
  required  this.isActive,
  required  this.categoryId,
 required   this.subcategoryId,
  required  this.brandId,
    this.bannerId,
  required  this.createdAt,
  required  this.updatedAt,
  });

  int id;
  String productId;
  String productCode;
  String productNameTm;
  String productNameRu;
  String? productPreviewImage;
  String? productImage;
  String productDescriptionTm;
  String productDescriptionRu;
  double productPrice;
  double? productPriceOld;
  double? productPriceTmt;
  double? productPriceTmtOld;
  int? productPriceUsd;
  dynamic productPriceUsdOld;
  int? productDiscount;
  bool isActive;
  int? categoryId;
  int? subcategoryId;
  int? brandId;
  int? bannerId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    id: json["id"],
    productId: json["product_id"],
    productCode: json["product_code"],
    productNameTm: json["product_name_tm"],
    productNameRu: json["product_name_ru"],
    productPreviewImage: json["product_preview_image"]== null ? null : json["product_preview_image"].toString(),
    productImage: json["product_image"]== null ? null : json["product_image"].toString(),
    productDescriptionTm: json["product_description_tm"],
    productDescriptionRu: json["product_description_ru"],
    productPrice: json["product_price"].toDouble(),
    productPriceOld: json["product_price_old"] == null ? null : json["product_price_old"].toDouble(),
    productPriceTmt: json["product_price_tmt"] == null ? null : json["product_price_tmt"].toDouble(),
    productPriceTmtOld: json["product_price_tmt_old"] == null ? null : json["product_price_tmt_old"].toDouble(),
    productPriceUsd: json["product_price_usd"] == null ? null : json["product_price_usd"],
    productPriceUsdOld: json["product_price_usd_old"],
    productDiscount: json["product_discount"] == null ? null : json["product_discount"],
    isActive: json["isActive"],
    categoryId: json["categoryId"]== null ? null : json["categoryId"],
    subcategoryId: json["subcategoryId"]== null ? null : json["subcategoryId"],
    brandId: json["brandId"]== null ? null : json["brandId"],
    bannerId: json["bannerId"]== null ? null : json["bannerId"],
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
    "product_price_old": productPriceOld == null ? null : productPriceOld,
    "product_price_tmt": productPriceTmt == null ? null : productPriceTmt,
    "product_price_tmt_old": productPriceTmtOld == null ? null : productPriceTmtOld,
    "product_price_usd": productPriceUsd == null ? null : productPriceUsd,
    "product_price_usd_old": productPriceUsdOld,
    "product_discount": productDiscount == null ? null : productDiscount,
    "isActive": isActive,
    "categoryId": categoryId,
    "subcategoryId": subcategoryId,
    "brandId": brandId,
    "bannerId": bannerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
