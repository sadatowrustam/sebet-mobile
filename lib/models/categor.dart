// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

List<Categories> categoriesFromJson(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categories {
  Categories({
  required  this.id,
  required  this.categoryId,
  required  this.categoryNameTm,
  required  this.categoryNameRu,
  required  this.createdAt,
   required this.updatedAt,
 required   this.categoryBrands,
  required  this.categorySubcategories,
  });

  int id;
  String categoryId;
  String categoryNameTm;
  String categoryNameRu;
  DateTime createdAt;
  DateTime updatedAt;
  List<CategoryBrand> categoryBrands;
  List<CategorySubcategory> categorySubcategories;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    id: json["id"],
    categoryId: json["category_id"],
    categoryNameTm: json["category_name_tm"],
    categoryNameRu: json["category_name_ru"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    categoryBrands: List<CategoryBrand>.from(json["category_brands"].map((x) => CategoryBrand.fromJson(x))),
    categorySubcategories: List<CategorySubcategory>.from(json["category_subcategories"].map((x) => CategorySubcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "category_name_tm": categoryNameTm,
    "category_name_ru": categoryNameRu,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "category_brands": List<dynamic>.from(categoryBrands.map((x) => x.toJson())),
    "category_subcategories": List<dynamic>.from(categorySubcategories.map((x) => x.toJson())),
  };
}

class CategoryBrand {
  CategoryBrand({
  required  this.id,
  required  this.brandId,
  required  this.brandNameTm,
  required  this.brandNameRu,
 required   this.brandPreviewImage,
 required   this.createdAt,
  required  this.updatedAt,
 required   this.categoriesbrands,
  });

  int id;
  String brandId;
  String brandNameTm;
  String brandNameRu;
  String? brandPreviewImage;
  DateTime createdAt;
  DateTime updatedAt;
  Categoriesbrands categoriesbrands;

  factory CategoryBrand.fromJson(Map<String, dynamic> json) => CategoryBrand(
    id: json["id"],
    brandId: json["brand_id"],
    brandNameTm: json["brand_name_tm"],
    brandNameRu: json["brand_name_ru"],
    brandPreviewImage: json["brand_preview_image"] == null ? null : json["brand_preview_image"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    categoriesbrands: Categoriesbrands.fromJson(json["Categoriesbrands"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "brand_name_tm": brandNameTm,
    "brand_name_ru": brandNameRu,
    "brand_preview_image": brandPreviewImage == null ? null : brandPreviewImage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Categoriesbrands": categoriesbrands.toJson(),
  };
}

class Categoriesbrands {
  Categoriesbrands({
  required  this.brandId,
  required  this.categoryId,
  required  this.createdAt,
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

class CategorySubcategory {
  CategorySubcategory({
  required  this.id,
  required  this.subcategoryId,
  required  this.categoryId,
  required  this.subcategoryNameTm,
 required   this.subcategoryNameRu,
  required  this.createdAt,
  required  this.updatedAt,
  });

  int id;
  String subcategoryId;
  int categoryId;
  String subcategoryNameTm;
  String subcategoryNameRu;
  DateTime createdAt;
  DateTime updatedAt;

  factory CategorySubcategory.fromJson(Map<String, dynamic> json) => CategorySubcategory(
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
