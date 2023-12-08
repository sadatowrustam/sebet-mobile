
class ContactUs {

  String name;
  String email;
  String text;

	ContactUs.fromJsonMap(Map<String, dynamic> map): 
		name = map["name"],
		email = map["email"],
		text = map["text"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['email'] = email;
		data['text'] = text;
		return data;
	}
}
