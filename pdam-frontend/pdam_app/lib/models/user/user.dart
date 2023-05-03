/*class User {
  final String name;
  final String email;
  final String accessToken;
  final String? avatar;

  User({required this.name, required this.email, required this.accessToken, this.avatar});

  @override
  String toString() => 'User { name: $name, email: $email}';
}*/

import 'package:pdam_app/models/login.dart';

class User {
  String? id;
  String? username;
  String? avatar;
  String? fullName;

  User({this.id, this.username, this.avatar, this.fullName});

  User.fromLoginResponse(LoginResponse response) {
    this.id = response.id;
    this.username = response.userName;
    this.avatar = response.imgPath;
    this.fullName = response.fullName;
  }
}

class UserResponse extends User {
  UserResponse(id, username, fullName, avatar)
      : super(id: id, username: username, fullName: fullName, avatar: avatar);

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
    fullName = json['fullName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    return data;
  }
}

class RegisterRequest {
  String? username;
  String? password;
  String? verifyPassword;
  String? email;
  String? phoneNumber;
  String? fullName;
  int? cityId;
  int? genderId;

  RegisterRequest(
      {this.username,
      this.password,
      this.verifyPassword,
      this.email,
      this.phoneNumber,
      this.fullName,
      this.cityId,
      this.genderId});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    cityId = json['cityId'];
    genderId = json['genderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['verifyPassword'] = this.verifyPassword;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['fullName'] = this.fullName;
    data['cityId'] = this.cityId;
    data['genderId'] = this.genderId;
    return data;
  }
}
