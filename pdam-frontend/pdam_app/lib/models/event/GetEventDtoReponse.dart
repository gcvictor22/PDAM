class GetEventDtoResponse {
  late List<GetEventDto> content;
  late int currentPage;
  late bool last;
  late bool first;
  late int totalPages;
  late int totalElements;

  GetEventDtoResponse(
      {required this.content,
      required this.currentPage,
      required this.last,
      required this.first,
      required this.totalPages,
      required this.totalElements});

  GetEventDtoResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GetEventDto>[];
      json['content'].forEach((v) {
        content.add(new GetEventDto.fromJson(v));
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
    data['content'] = this.content.map((v) => v.toJson()).toList();
    data['currentPage'] = this.currentPage;
    data['last'] = this.last;
    data['first'] = this.first;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class GetEventDto {
  late int id;
  late String name;
  late String location;
  late String city;
  late int popularity;
  late String imgPath;
  late String? type;

  GetEventDto(
      {required this.id,
      required this.name,
      required this.location,
      required this.city,
      required this.popularity,
      required this.imgPath,
      this.type});

  GetEventDto.fromJson(Map<String, dynamic> json) {
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
