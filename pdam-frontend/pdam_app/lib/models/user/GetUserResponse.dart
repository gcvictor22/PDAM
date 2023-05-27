import 'package:pdam_app/models/user/GetUserDto.dart';

class GetUserResponse {
  List<GetUserDto>? content;
  int? currentPage;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;

  GetUserResponse(
      {this.content,
      this.currentPage,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements});

  GetUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GetUserDto>[];
      json['content'].forEach((v) {
        content!.add(new GetUserDto.fromJson(v));
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
