class GetFestivalDto {
  int? id;
  String? name;
  String? description;
  String? location;
  String? date;
  int? duration;
  int? remainingTickets;
  String? city;
  double? price;
  bool? drinkIncluded;
  int? numberOfDrinks;
  bool? adult;
  String? imgPath;
  String? stripeId;

  GetFestivalDto(
      {this.id,
      this.name,
      this.description,
      this.location,
      this.date,
      this.duration,
      this.remainingTickets,
      this.city,
      this.price,
      this.drinkIncluded,
      this.numberOfDrinks,
      this.adult,
      this.imgPath,
      this.stripeId});

  GetFestivalDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    date = json['date'];
    duration = json['duration'];
    remainingTickets = json['remainingTickets'];
    city = json['city'];
    price = json['price'];
    drinkIncluded = json['drinkIncluded'];
    numberOfDrinks = json['numberOfDrinks'];
    adult = json['adult'];
    imgPath = json['imgPath'];
    stripeId = json['stripeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['location'] = this.location;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['remainingTickets'] = this.remainingTickets;
    data['city'] = this.city;
    data['price'] = this.price;
    data['drinkIncluded'] = this.drinkIncluded;
    data['numberOfDrinks'] = this.numberOfDrinks;
    data['adult'] = this.adult;
    data['imgPath'] = this.imgPath;
    data['stripeId'] = this.stripeId;
    return data;
  }
}
