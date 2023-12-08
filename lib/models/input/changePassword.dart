
class ChangePassword {

  String? currentPassword;
  String newPassword;
  String newPasswordConfirm;

	ChangePassword.fromJsonMap(Map<String, dynamic> map): 
		currentPassword = map["currentPassword"],
		newPassword = map["newPassword"],
		newPasswordConfirm = map["newPasswordConfirm"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['currentPassword'] = currentPassword;
		data['newPassword'] = newPassword;
		data['newPasswordConfirm'] = newPasswordConfirm;
		return data;
	}
}
