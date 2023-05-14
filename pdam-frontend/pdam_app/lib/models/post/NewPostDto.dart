class NewPostDto {
  late String? affair;
  late String content;

  NewPostDto({this.affair, required this.content});

  NewPostDto.fromJson(Map<String, dynamic> json) {
    affair = json['affair'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['affair'] = this.affair;
    data['content'] = this.content;
    return data;
  }
}
