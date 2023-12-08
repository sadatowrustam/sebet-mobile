// To parse this JSON data, do
//
//     final topProduct = topProductFromJson(jsonString);

import 'dart:convert';

TopProduct topProductFromJson(String str) => TopProduct.fromJson(json.decode(str));

String topProductToJson(TopProduct data) => json.encode(data.toJson());

class TopProduct {
	TopProduct({
	required	this.data,
	});

	Data data;

	factory TopProduct.fromJson(Map<String, dynamic> json) => TopProduct(
		data: Data.fromJson(json["data"]),
	);

	Map<String, dynamic> toJson() => {
		"data": data.toJson(),
	};
}

class Data {
	Data({
	required	this.productsWithDiscount,
	required	this.newProducts,
	});

	List<NewProduct> productsWithDiscount;
	List<NewProduct> newProducts;

	factory Data.fromJson(Map<String, dynamic> json) => Data(
		productsWithDiscount: List<NewProduct>.from(json["products_with_discount"].map((x) => NewProduct.fromJson(x))),
		newProducts: List<NewProduct>.from(json["new_products"].map((x) => NewProduct.fromJson(x))),
	);

	Map<String, dynamic> toJson() => {
		"products_with_discount": List<dynamic>.from(productsWithDiscount.map((x) => x.toJson())),
		"new_products": List<dynamic>.from(newProducts.map((x) => x.toJson())),
	};
}

class NewProduct {
	NewProduct({
	required	this.id,
	required	this.productId,
	required	this.productCode,
	required	this.productNameTm,
	required	this.productNameRu,
	required	this.productPreviewImage,
	required	this.productImage,
	required	this.productDescriptionTm,
	required	this.productDescriptionRu,
	required	this.productPrice,
	required	this.productDiscount,
	required	this.productPriceOld,
	required	this.category,
	required	this.subcategory,
	required	this.brand,
	required	this.productStock,
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
	int? productDiscount;
	double? productPriceOld;
	Category category;
	Subcategory? subcategory;
	Brand brand;
	ProductStock productStock;

	factory NewProduct.fromJson(Map<String, dynamic> json) => NewProduct(
		id: json["id"],
		productId: json["product_id"],
		productCode: json["product_code"],
		productNameTm: json["product_name_tm"],
		productNameRu: json["product_name_ru"],
		productPreviewImage: json["product_preview_image"]== null ? null : json["product_preview_image"],
		productImage: json["product_image"]== null ? null : json["product_image"],
		productDescriptionTm: json["product_description_tm"],
		productDescriptionRu: json["product_description_ru"],
		productPrice: json["product_price"].toDouble(),
		productDiscount: json["product_discount"] == null ? null : json["product_discount"],
		productPriceOld: json["product_price_old"] == null ? null : json["product_price_old"].toDouble(),
		category: Category.fromJson(json["category"]),
		subcategory: json["subcategory"] == null ? null : Subcategory.fromJson(json["subcategory"]),
		brand: Brand.fromJson(json["brand"]),
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
		"product_discount": productDiscount == null ? null : productDiscount,
		"product_price_old": productPriceOld == null ? null : productPriceOld,
		"category": category.toJson(),
		"subcategory": subcategory == null ? null : subcategory!.toJson(),
		"brand": brand.toJson(),
		"product_stock": productStock.toJson(),
	};
}

class Brand {
	Brand({
	required	this.id,
	required	this.brandId,
	required	this.brandNameTm,
	required	this.brandNameRu,
	required	this.brandPreviewImage,
	required	this.createdAt,
	required	this.updatedAt,
	});

	int id;
	String brandId;
	String brandNameTm;
	String brandNameRu;
	String brandPreviewImage;
	DateTime createdAt;
	DateTime updatedAt;

	factory Brand.fromJson(Map<String, dynamic> json) => Brand(
		id: json["id"],
		brandId: json["brand_id"],
		brandNameTm: json["brand_name_tm"],
		brandNameRu: json["brand_name_ru"],
		brandPreviewImage: json["brand_preview_image"],
		createdAt: DateTime.parse(json["createdAt"]),
		updatedAt: DateTime.parse(json["updatedAt"]),
	);

	Map<String, dynamic> toJson() => {
		"id": id,
		"brand_id": brandId,
		"brand_name_tm": brandNameTm,
		"brand_name_ru": brandNameRu,
		"brand_preview_image": brandPreviewImage,
		"createdAt": createdAt.toIso8601String(),
		"updatedAt": updatedAt.toIso8601String(),
	};
}

class Category {
	Category({
	required	this.id,
	required	this.categoryId,
	required	this.categoryNameTm,
	required	this.categoryNameRu,
	required	this.createdAt,
	required	this.updatedAt,
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
	required	this.id,
	required	this.stockId,
	required	this.productId,
	required	this.stockQuantity,
	required	this.createdAt,
	required	this.updatedAt,
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
	required	this.id,
	required	this.subcategoryId,
	required	this.categoryId,
	required	this.subcategoryNameTm,
required		this.subcategoryNameRu,
	required	this.createdAt,
	required	this.updatedAt,
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
