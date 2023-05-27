import '../user/GetProfile.dart';

class GetPostDto {
  late int id;
  late String? affair;
  late String content;
  late List<String> imgPath;
  late UserWhoPost userWhoPost;
  late int usersWhoLiked;
  late int comments;
  late bool likedByUser;
  late String postDate;

  GetPostDto(
      {required this.id,
      this.affair,
      required this.content,
      required this.imgPath,
      required this.userWhoPost,
      required this.usersWhoLiked,
      required this.comments,
      required this.likedByUser,
      required this.postDate});

  GetPostDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    affair = json['affair'];
    content = json['content'];
    imgPath = json['imgPath'].cast<String>();
    userWhoPost = (json['userWhoPost'] != null
        ? new UserWhoPost.fromJson(json['userWhoPost'])
        : null)!;
    usersWhoLiked = json['usersWhoLiked'];
    comments = json['comments'];
    likedByUser = json['likedByUser'];
    postDate = json['postDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['affair'] = this.affair;
    data['content'] = this.content;
    data['imgPath'] = this.imgPath;
    data['userWhoPost'] = this.userWhoPost.toJson();
    data['usersWhoLiked'] = this.usersWhoLiked;
    data['comments'] = this.comments;
    data['likedByUser'] = this.likedByUser;
    data['postDate'] = this.postDate;
    return data;
  }
}
