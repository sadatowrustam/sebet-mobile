import 'package:sebet/models/Hasabym/data.dart';

class Token {

  String token;
  Data data;

	Token.fromJsonMap(Map<String, dynamic> map): 
		token = map["token"],
		data = Data.fromJsonMap(map["data"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['token'] = token;
		data['data'] = data;
		return data;
	}
}
