// To parse this JSON data, do
//
//     final brendPro = brendProFromJson(jsonString);

import 'dart:convert';

List<BrendPro> brendProFromJson(String str) => List<BrendPro>.from(json.decode(str).map((x) => BrendPro.fromJson(x)));

String brendProToJson(List<BrendPro> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrendPro {
  BrendPro({
  required  this.id,
  required  this.productId,
   required this.productCode,
   required this.productNameTm,
  required  this.productNameRu,
 required   this.productPreviewImage,
  required  this.productImage,
  required  this.productDescriptionTm,
  required  this.productDescriptionRu,
 required   this.productPrice,
 required   this.productPriceOld,
 required   this.productPriceTmt,
 required   this.productPriceTmtOld,
   required this.productPriceUsd,
 required   this.productPriceUsdOld,
  required  this.productDiscount,
  required  this.isActive,
  required  this.categoryId,
  required  this.subcategoryId,
  required  this.brandId,
  required  this.bannerId,
  required  this.createdAt,
  required  this.updatedAt,
  required  this.category,
  required  this.subcategory,
  required  this.productStock,
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
  double productPriceTmt;
  double? productPriceTmtOld;
  int? productPriceUsd;
  int? productPriceUsdOld;
  int? productDiscount;
  bool isActive;
  int categoryId;
  int? subcategoryId;
  int? brandId;
  int? bannerId;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;
  Subcategory? subcategory;
  ProductStock productStock;

  factory BrendPro.fromJson(Map<String, dynamic> json) => BrendPro(
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
    productPriceTmt: json["product_price_tmt"].toDouble(),
    productPriceTmtOld: json["product_price_tmt_old"] == null ? null : json["product_price_tmt_old"].toDouble(),
    productPriceUsd: json["product_price_usd"]== null ? null : json["product_price_usd"],
    productPriceUsdOld: json["product_price_usd_old"]== null ? null : json["product_price_usd_old"],
    productDiscount: json["product_discount"] == null ? null : json["product_discount"],
    isActive: json["isActive"],
    categoryId: json["categoryId"],
    subcategoryId: json["subcategoryId"] == null ? null : json["subcategoryId"],
    brandId: json["brandId"]== null ? null : json["brandId"],
    bannerId: json["bannerId"] == null ? null : json["bannerId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    category: Category.fromJson(json["category"]),
    subcategory: json["subcategory"] == null ? null : Subcategory.fromJson(json["subcategory"]),
    productStock: ProductStock.fromJson(json["product_stock"]),
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
    "product_price_tmt": productPriceTmt,
    "product_price_tmt_old": productPriceTmtOld == null ? null : productPriceTmtOld,
    "product_price_usd": productPriceUsd,
    "product_price_usd_old": productPriceUsdOld,
    "product_discount": productDiscount == null ? null : productDiscount,
    "isActive": isActive,
    "categoryId": categoryId,
    "subcategoryId": subcategoryId == null ? null : subcategoryId,
    "brandId": brandId,
    "bannerId": bannerId == null ? null : bannerId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "category": category.toJson(),
    "subcategory": subcategory == null ? null : subcategory!.toJson(),
    "product_stock": productStock.toJson(),
  };
}

class Category {
  Category({
  required  this.id,
  required  this.categoryId,
 required   this.categoryNameTm,
  required  this.categoryNameRu,
 required   this.createdAt,
  required  this.updatedAt,
  });

  int id;
  String categoryId;
  String categoryNameTm;
  String categoryNameRu;
  DateTime createdAt;
  DateTime updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    categoryId: json["category_id"],
    categoryNameTm: json["category_name_tm"],
    categoryNameRu: json["category_name_ru"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "category_name_tm": categoryNameTm,
    "category_name_ru": categoryNameRu,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class ProductStock {
  ProductStock({
 required   this.id,
 required   this.stockId,
 required   this.productId,
 required   this.stockQuantity,
 required   this.createdAt,
 required   this.updatedAt,
  });

  int id;
  String stockId;
  int productId;
  int stockQuantity;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductStock.fromJson(Map<String, dynamic> json) => ProductStock(
    id: json["id"],
    stockId: json["stock_id"],
    productId: json["productId"],
    stockQuantity: json["stock_quantity"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stock_id": stockId,
    "productId": productId,
    "stock_quantity": stockQuantity,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Subcategory {
  Subcategory({
  required  this.id,
  required  this.subcategoryId,
  required  this.categoryId,
 required  this.subcategoryNameTm,
  required  this.subcategoryNameRu,
  required  this.createdAt,
 required   this.updatedAt,
  });

  int id;
  String subcategoryId;
  int categoryId;
  String subcategoryNameTm;
  String subcategoryNameRu;
  DateTime createdAt;
  DateTime updatedAt;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"],
    subcategoryId: json["subcategory_id"],
    categoryId: json["categoryId"],
    subcategoryNameTm: json["subcategory_name_tm"],
    subcategoryNameRu: json["subcategory_name_ru"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subcategory_id": subcategoryId,
    "categoryId": categoryId,
    "subcategory_name_tm": subcategoryNameTm,
    "subcategory_name_ru": subcategoryNameRu,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
