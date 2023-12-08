
class Patch {

  String user_name;
  String user_address;

	Patch.fromJsonMap(Map<String, dynamic> map): 
		user_name = map["user_name"],
		user_address = map["user_address"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_name'] = user_name;
		data['user_address'] = user_address;
		return data;
	}
}
