class GetUserDto {
  String? id;
  String? userName;
  String? fullName;
  String? imgPath;
  int? followers;
  int? countOfPosts;
  bool? verified;
  bool? followedByUser;
  String? createdAt;

  GetUserDto(
      {this.id,
      this.userName,
      this.fullName,
      this.imgPath,
      this.followers,
      this.countOfPosts,
      this.verified,
      this.followedByUser,
      this.createdAt});

  GetUserDto.fromRegisterReqest(GetUserDto getUserDto) {
    this.id = getUserDto.id;
    this.userName = getUserDto.userName;
    this.fullName = getUserDto.fullName;
    this.imgPath = getUserDto.imgPath;
    this.followers = getUserDto.followers;
    this.countOfPosts = getUserDto.countOfPosts;
    this.verified = getUserDto.verified;
    this.followedByUser = getUserDto.followedByUser;
    this.createdAt = getUserDto.createdAt;
  }

  GetUserDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    imgPath = json['imgPath'];
    followers = json['followers'];
    countOfPosts = json['countOfPosts'];
    verified = json['verified'];
    followedByUser = json['followedByUser'];
    createdAt = json['createdAt'];
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
    return data;
  }
}
