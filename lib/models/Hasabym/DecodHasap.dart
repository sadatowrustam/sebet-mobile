
class DecodHasap {

  int id;
  String user_id;
  String user_name;
  String user_phone;
  String? user_address;
  String createdAt;
  String updatedAt;

	DecodHasap.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		user_id = map["user_id"],
		user_name = map["user_name"],
		user_phone = map["user_phone"],
		user_address = map["user_address"],
		createdAt = map["createdAt"],
		updatedAt = map["updatedAt"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['user_id'] = user_id;
		data['user_name'] = user_name;
		data['user_phone'] = user_phone;
		data['user_address'] = user_address;
		data['createdAt'] = createdAt;
		data['updatedAt'] = updatedAt;
		return data;
	}
}
