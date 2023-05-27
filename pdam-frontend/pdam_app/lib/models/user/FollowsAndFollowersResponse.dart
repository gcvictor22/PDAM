import 'GetProfile.dart';

class FollowsAndFollowersResponse {
  List<UserWhoPost>? content;
  int? currentPage;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;

  FollowsAndFollowersResponse(
      {this.content,
      this.currentPage,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements});

  FollowsAndFollowersResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <UserWhoPost>[];
      json['content'].forEach((v) {
        content!.add(new UserWhoPost.fromJson(v));
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
