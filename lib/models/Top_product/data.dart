import 'package:sebet/models/Top_product/products_with_discount.dart';
import 'package:sebet/models/Top_product/new_products.dart';

class Data {

  List<Products_with_discount> products_with_discount;
  List<New_products> new_products;

	Data.fromJsonMap(Map<String, dynamic> map): 
		products_with_discount = List<Products_with_discount>.from(map["products_with_discount"].map((it) => Products_with_discount.fromJsonMap(it))),
		new_products = List<New_products>.from(map["new_products"].map((it) => New_products.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['products_with_discount'] = products_with_discount != null ? 
			this.products_with_discount.map((v) => v.toJson()).toList()
			: null;
		data['new_products'] = new_products != null ? 
			this.new_products.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
