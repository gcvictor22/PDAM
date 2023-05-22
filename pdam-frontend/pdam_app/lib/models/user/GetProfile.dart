import 'package:pdam_app/models/post/GetPostDto.dart';

class GetProfileDto {
  String? id;
  String? userName;
  String? fullName;
  String? imgPath;
  String? email;
  String? phoneNumber;
  int? follows;
  int? followers;
  PublishedPosts? publishedPosts;
  bool? followedByUser;
  bool? verified;
  String? city;
  AuthEvent? authEvent;
  bool? authorized;
  String? createdAt;
  bool? loggedUser;

  GetProfileDto(
      {this.id,
      this.userName,
      this.fullName,
      this.imgPath,
      this.email,
      this.phoneNumber,
      this.follows,
      this.followers,
      this.publishedPosts,
      this.followedByUser,
      this.verified,
      this.city,
      this.authEvent,
      this.authorized,
      this.createdAt,
      this.loggedUser});

  GetProfileDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    imgPath = json['imgPath'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    follows = json['follows'];
    followers = json['followers'];
    publishedPosts = json['publishedPosts'] != null
        ? new PublishedPosts.fromJson(json['publishedPosts'])
        : null;
    followedByUser = json['followedByUser'];
    verified = json['verified'];
    city = json['city'];
    authEvent = json['authEvent'] != null
        ? new AuthEvent.fromJson(json['authEvent'])
        : null;
    authorized = json['authorized'];
    createdAt = json['createdAt'];
    loggedUser = json['loggedUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['imgPath'] = this.imgPath;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['follows'] = this.follows;
    data['followers'] = this.followers;
    if (this.publishedPosts != null) {
      data['publishedPosts'] = this.publishedPosts!.toJson();
    }
    data['followedByUser'] = this.followedByUser;
    data['verified'] = this.verified;
    data['city'] = this.city;
    if (this.authEvent != null) {
      data['authEvent'] = this.authEvent!.toJson();
    }
    data['authorized'] = this.authorized;
    data['createdAt'] = this.createdAt;
    data['isLoggedUser'] = this.loggedUser;
    return data;
  }
}

class PublishedPosts {
  List<GetPostDto>? content;
  int? currentPage;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;

  PublishedPosts(
      {this.content,
      this.currentPage,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements});

  PublishedPosts.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GetPostDto>[];
      json['content'].forEach((v) {
        content!.add(new GetPostDto.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    last = json['last'];
    first = json['first'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['last'] = this.last;
    data['first'] = this.first;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class UserWhoPost {
  String? userName;
  String? imgPath;
  bool? verified;
  bool? followedByUser;
  bool? loggedUser;

  UserWhoPost(
      {this.userName,
      this.imgPath,
      this.verified,
      this.followedByUser,
      this.loggedUser});

  UserWhoPost.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    imgPath = json['imgPath'];
    verified = json['verified'];
    followedByUser = json['followedByUser'];
    loggedUser = json['loggedUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['imgPath'] = this.imgPath;
    data['verified'] = this.verified;
    data['followedByUser'] = this.followedByUser;
    data['loggedUser'] = this.loggedUser;
    return data;
  }
}

class AuthEvent {
  int? id;
  String? name;
  String? location;
  String? city;
  int? popularity;
  String? imgPath;
  String? type;

  AuthEvent(
      {this.id,
      this.name,
      this.location,
      this.city,
      this.popularity,
      this.imgPath,
      this.type});

  AuthEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    city = json['city'];
    popularity = json['popularity'];
    imgPath = json['imgPath'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['city'] = this.city;
    data['popularity'] = this.popularity;
    data['imgPath'] = this.imgPath;
    data['type'] = this.type;
    return data;
  }
}
