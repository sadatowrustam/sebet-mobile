// To parse this JSON data, do
//
//     final brends = brendsFromJson(jsonString);

import 'dart:convert';

List<Brends> brendsFromJson(String str) => List<Brends>.from(json.decode(str).map((x) => Brends.fromJson(x)));

String brendsToJson(List<Brends> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Brends {
  Brends({
  required  this.id,
   required this.brandId,
  required  this.brandNameTm,
  required  this.brandNameRu,
  required  this.brandPreviewImage,
  required  this.createdAt,
  required  this.updatedAt,
  required  this.brandCategories,
  });

  int id;
  String brandId;
  String brandNameTm;
  String brandNameRu;
  String? brandPreviewImage;
  DateTime createdAt;
  DateTime updatedAt;
  List<BrandCategory> brandCategories;

  factory Brends.fromJson(Map<String, dynamic> json) => Brends(
    id: json["id"],
    brandId: json["brand_id"],
    brandNameTm: json["brand_name_tm"],
    brandNameRu: json["brand_name_ru"],
    brandPreviewImage: json["brand_preview_image"] == null ? null : json["brand_preview_image"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    brandCategories: List<BrandCategory>.from(json["brand_categories"].map((x) => BrandCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "brand_name_tm": brandNameTm,
    "brand_name_ru": brandNameRu,
    "brand_preview_image": brandPreviewImage == null ? null : brandPreviewImage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "brand_categories": List<dynamic>.from(brandCategories.map((x) => x.toJson())),
  };
}

class BrandCategory {
  BrandCategory({
  required  this.id,
  required  this.categoryId,
  required  this.categoryNameTm,
  required  this.categoryNameRu,
  required  this.createdAt,
 required   this.updatedAt,
  required  this.categoriesbrands,
  });

  int id;
  String categoryId;
  String categoryNameTm;
  String categoryNameRu;
  DateTime createdAt;
  DateTime updatedAt;
  Categoriesbrands categoriesbrands;

  factory BrandCategory.fromJson(Map<String, dynamic> json) => BrandCategory(
    id: json["id"],
    categoryId: json["category_id"],
    categoryNameTm: json["category_name_tm"],
    categoryNameRu: json["category_name_ru"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    categoriesbrands: Categoriesbrands.fromJson(json["Categoriesbrands"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "category_name_tm": categoryNameTm,
    "category_name_ru": categoryNameRu,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Categoriesbrands": categoriesbrands.toJson(),
  };
}

class Categoriesbrands {
  Categoriesbrands({
  required  this.brandId,
  required  this.categoryId,
 required   this.createdAt,
  required  this.updatedAt,
  });

  int brandId;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Categoriesbrands.fromJson(Map<String, dynamic> json) => Categoriesbrands(
    brandId: json["brandId"],
    categoryId: json["categoryId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "brandId": brandId,
    "categoryId": categoryId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
