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
