import 'package:sebet/models/Hasabym/user.dart';

class Data {

  User user;

	Data.fromJsonMap(Map<String, dynamic> map): 
		user = User.fromJsonMap(map["user"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user'] = user == null ? null : user.toJson();
		return data;
	}
}
