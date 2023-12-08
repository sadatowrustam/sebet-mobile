
class SignUp {

  String user_name;
  String user_phone;
  String user_password;
  String user_passwordConfirm;

	SignUp.fromJsonMap(Map<String, dynamic> map): 
		user_name = map["user_name"],
		user_phone = map["user_phone"],
		user_password = map["user_password"],
		user_passwordConfirm = map["user_passwordConfirm"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_name'] = user_name;
		data['user_phone'] = user_phone;
		data['user_password'] = user_password;
		data['user_passwordConfirm'] = user_passwordConfirm;
		return data;
	}
}
