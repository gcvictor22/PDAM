class GetPartiesResponse {
  List<GetPartyDto>? content;
  int? currentPage;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;

  GetPartiesResponse(
      {this.content,
      this.currentPage,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements});

  GetPartiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GetPartyDto>[];
      json['content'].forEach((v) {
        content!.add(new GetPartyDto.fromJson(v));
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

class GetPartyDto {
  int? id;
  String? name;
  String? description;
  String? discotheque;
  int? remainingTickets;
  String? startAt;
  String? endsAt;
  bool? adult;
  double? price;
  bool? drinkIncluded;
  int? numberOfDrinks;
  String? imgPath;
  String? paymentId;

  GetPartyDto(
      {this.id,
      this.name,
      this.description,
      this.discotheque,
      this.remainingTickets,
      this.startAt,
      this.endsAt,
      this.adult,
      this.price,
      this.drinkIncluded,
      this.numberOfDrinks,
      this.imgPath,
      this.paymentId});

  GetPartyDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    discotheque = json['discotheque'];
    remainingTickets = json['remainingTickets'];
    startAt = json['startAt'];
    endsAt = json['endsAt'];
    adult = json['adult'];
    price = json['price'];
    drinkIncluded = json['drinkIncluded'];
    numberOfDrinks = json['numberOfDrinks'];
    imgPath = json['imgPath'];
    paymentId = json['paymentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['discotheque'] = this.discotheque;
    data['remainingTickets'] = this.remainingTickets;
    data['startAt'] = this.startAt;
    data['endsAt'] = this.endsAt;
    data['adult'] = this.adult;
    data['price'] = this.price;
    data['drinkIncluded'] = this.drinkIncluded;
    data['numberOfDrinks'] = this.numberOfDrinks;
    data['imgPath'] = this.imgPath;
    data['paymentId'] = this.paymentId;
    return data;
  }
}
