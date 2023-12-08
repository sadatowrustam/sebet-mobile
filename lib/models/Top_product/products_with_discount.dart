class Products_with_discount {
  int? id;
  String? product_id;
  String? product_code;
  String? product_name_tm;
  String? product_name_ru;
  Object? product_preview_image;
  Object? product_image;
  String? product_description_tm;
  String? product_description_ru=null;
  int? product_price=null;
  int? product_price_old;
  int? product_price_tmt;
  int? product_price_tmt_old;
  Object? product_price_usd;
  Object? product_price_usd_old;
  int? product_discount;
  int? categoryId;
  int? brandId;
  String? createdAt;
  String? updatedAt;

  Products_with_discount.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        product_id = map["product_id"],
        product_code = map["product_code"],
        product_name_tm = map["product_name_tm"],
        product_name_ru = map["product_name_ru"],
        product_preview_image = map["product_preview_image"],
        product_image = map["product_image"],
        product_description_tm = map["product_description_tm"],
        product_description_ru = map["product_description_ru"],
        product_price = map["product_price"],
        product_price_old = map["product_price_old"],
        product_price_tmt = map["product_price_tmt"],
        product_price_tmt_old = map["product_price_tmt_old"],
        product_price_usd = map["product_price_usd"],
        product_price_usd_old = map["product_price_usd_old"],
        product_discount = map["product_discount"],
        categoryId = map["categoryId"],
        brandId = map["brandId"],
        createdAt = map["createdAt"],
        updatedAt = map["updatedAt"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['product_id'] = product_id;
    data['product_code'] = product_code;
    data['product_name_tm'] = product_name_tm;
    data['product_name_ru'] = product_name_ru;
    data['product_preview_image'] = product_preview_image;
    data['product_image'] = product_image;
    data['product_description_tm'] = product_description_tm;
    data['product_description_ru'] = product_description_ru;
    data['product_price'] = product_price;
    data['product_price_old'] = product_price_old;
    data['product_price_tmt'] = product_price_tmt;
    data['product_price_tmt_old'] = product_price_tmt_old;
    data['product_price_usd'] = product_price_usd;
    data['product_price_usd_old'] = product_price_usd_old;
    data['product_discount'] = product_discount;
    data['categoryId'] = categoryId;
    data['brandId'] = brandId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
