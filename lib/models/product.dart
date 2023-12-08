class Product {
  String adi;
  String img;
  String arzan;
  String bahasy;
  String arzbah;

  Product.fromJsonMap(Map<String, dynamic> map)
      : adi = map["adi"],
        img = map["img"],
        arzan = map["arzan"],
        bahasy = map["bahasy"],
        arzbah = map["arzbah"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adi'] = adi;
    data['img'] = img;
    data['arzan'] = arzan;
    data['bahasy'] = bahasy;
    data['arzbah'] = arzbah;
    return data;
  }
}
