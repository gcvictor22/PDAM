class EditModelFullName {
  final String fullName;

  EditModelFullName({required this.fullName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    return data;
  }
}

class EditModelUserName {
  final String userName;

  EditModelUserName({required this.userName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    return data;
  }
}

class EditModelPhoneNumber {
  final String phoneNumber;

  EditModelPhoneNumber({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class EditModelEmail {
  final String email;

  EditModelEmail({required this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class EditModelPassword {
  final String oldPassword;
  final String newPassword;
  final String newPasswordVerify;

  EditModelPassword(
      {required this.oldPassword,
      required this.newPassword,
      required this.newPasswordVerify});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['newPasswordVerify'] = this.newPasswordVerify;
    return data;
  }
}
