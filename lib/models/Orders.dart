// To parse this JSON data, do
//
//     final sargytlar = sargytlarFromJson(jsonString);

import 'dart:convert';

List<Sargytlar> sargytlarFromJson(String str) => List<Sargytlar>.from(json.decode(str).map((x) => Sargytlar.fromJson(x)));

String sargytlarToJson(List<Sargytlar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sargytlar {
  Sargytlar({
  required  this.id,
  required  this.orderId,
   required this.userId,
  required  this.totalPrice,
  required  this.totalQuantity,
  required  this.userName,
  required  this.userPhone,
  required  this.paymentType,
 required   this.iTake,
  required  this.address,
  required  this.status,
  required  this.deliveryTime,
  required  this.note,
  required  this.createdAt,
  required  this.updatedAt,
  });

  int id;
  String orderId;
  int userId;
  double totalPrice;
  int totalQuantity;
  String userName;
  String userPhone;
  int paymentType;
  bool iTake;
  String address;
  int status;
  int deliveryTime;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  factory Sargytlar.fromJson(Map<String, dynamic> json) => Sargytlar(
    id: json["id"],
    orderId: json["order_id"],
    userId: json["userId"],
    totalPrice: json["total_price"].toDouble(),
    totalQuantity: json["total_quantity"],
    userName: json["user_name"],
    userPhone: json["user_phone"],
    paymentType: json["payment_type"],
    iTake: json["i_take"],
    address: json["address"],
    status: json["status"],
    deliveryTime: json["delivery_time"],
    note: json["note"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "userId": userId,
    "total_price": totalPrice,
    "total_quantity": totalQuantity,
    "user_name": userName,
    "user_phone": userPhone,
    "payment_type": paymentType,
    "i_take": iTake,
    "address": address,
    "status": status,
    "delivery_time": deliveryTime,
    "note": note,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
