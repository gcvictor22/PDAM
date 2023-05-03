class VerificationToken {
  String? userName;
  String? verificationNumber;

  VerificationToken({this.userName, this.verificationNumber});

  VerificationToken.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    verificationNumber = json['verificationNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['verificationNumber'] = this.verificationNumber;
    return data;
  }
}
