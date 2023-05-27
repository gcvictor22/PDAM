class GetUserDto {
  late String id;
  late String userName;
  late String fullName;
  late String imgPath;
  late int followers;
  late int countOfPosts;
  late bool verified;
  late bool followedByUser;
  late String createdAt;

  GetUserDto(
      {required this.id,
      required this.userName,
      required this.fullName,
      required this.imgPath,
      required this.followers,
      required this.countOfPosts,
      required this.verified,
      required this.followedByUser,
      required this.createdAt});

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
