class LoginResponse {
  String? id;
  String? userName;
  String? fullName;
  String? imgPath;
  int? followers;
  int? countOfPosts;
  bool? verified;
  bool? followedByUser;
  String? createdAt;
  String? token;

  LoginResponse(
      {this.id,
      this.userName,
      this.fullName,
      this.imgPath,
      this.followers,
      this.countOfPosts,
      this.verified,
      this.followedByUser,
      this.createdAt,
      this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    imgPath = json['imgPath'];
    followers = json['followers'];
    countOfPosts = json['countOfPosts'];
    verified = json['verified'];
    followedByUser = json['followedByUser'];
    createdAt = json['createdAt'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['imgPath'] = this.imgPath;
    data['followers'] = this.followers;
    data['countOfPosts'] = this.countOfPosts;
    data['verified'] = this.verified;
    data['followedByUser'] = this.followedByUser;
    data['createdAt'] = this.createdAt;
    data['token'] = this.token;
    return data;
  }
}

class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
