// To parse this JSON data, do
//
//     final addOrder = addOrderFromJson(jsonString);

import 'dart:convert';

AddOrder addOrderFromJson(String str) => AddOrder.fromJson(json.decode(str));

String addOrderToJson(AddOrder data) => json.encode(data.toJson());

class AddOrder {
  AddOrder({
  required  this.address,
 required   this.deliveryTime,
  required  this.userName,
 required   this.userPhone,
 required   this.paymentType,
 required   this.iTake,
 required   this.note,
  required  this.orderProducts,
  });

  String? address;
  int? deliveryTime;
  String? userName;
  String? userPhone;
  int? paymentType;
  bool? iTake;
  String? note;
  List<OrderProduct> orderProducts;

  factory AddOrder.fromJson(Map<String, dynamic> json) => AddOrder(
    address: json["address"],
    deliveryTime: json["delivery_time"],
    userName: json["user_name"],
    userPhone: json["user_phone"],
    paymentType: json["payment_type"],
    iTake: json["i_take"],
    note: json["note"],
    orderProducts: List<OrderProduct>.from(json["order_products"].map((x) => OrderProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "delivery_time": deliveryTime,
    "user_name": userName,
    "user_phone": userPhone,
    "payment_type": paymentType,
    "i_take": iTake,
    "note": note,
    "order_products": List<dynamic>.from(orderProducts.map((x) => x.toJson())),
  };
}

class OrderProduct {
  OrderProduct({
  required  this.productId,
  required  this.quantity,
  });

  String productId;
  int quantity;

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    productId: json["product_id"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "quantity": quantity,
  };
 List encondeToJson(List<OrderProduct> list) {
    List jsonList = [];
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
