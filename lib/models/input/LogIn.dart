
class LogIn {

  String user_phone;
  String user_password;

	LogIn.fromJsonMap(Map<String, dynamic> map): 
		user_phone = map["user_phone"],
		user_password = map["user_password"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_phone'] = user_phone;
		data['user_password'] = user_password;
		return data;
	}
}
