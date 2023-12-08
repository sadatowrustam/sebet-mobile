
class NewPassword {

  String user_phone;

	NewPassword.fromJsonMap(Map<String, dynamic> map): 
		user_phone = map["user_phone"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_phone'] = user_phone;
		return data;
	}
}
