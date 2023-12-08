// To parse this JSON data, do
//
//     final addProduct = addProductFromJson(jsonString);

import 'dart:convert';

List<AddProduct> addProductFromJson(String str) => List<AddProduct>.from(json.decode(str).map((x) => AddProduct.fromJson(x)));

String addProductToJson(List<AddProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddProduct {
  AddProduct({
    required this.sn,
  required  this.id,
  required  this.sany,
  });

  int sn;
  int id;
  int sany;

  factory AddProduct.fromJson(Map<String, dynamic> json) => AddProduct(
    sn: json["sn"],
    id: json["ID"],
    sany: json["SANY"],
  );

  Map<String, dynamic> toJson() => {
    "sn": sn,
    "ID": id,
    "SANY": sany,
  };
}
