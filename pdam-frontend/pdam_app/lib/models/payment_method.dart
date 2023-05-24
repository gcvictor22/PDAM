class PaymentMethodResponse {
  List<GetPaymentMethodDto>? content;

  PaymentMethodResponse({this.content});

  PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <GetPaymentMethodDto>[];
      json['content'].forEach((v) {
        content!.add(new GetPaymentMethodDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetPaymentMethodDto {
  int? id;
  String? number;
  String? holder;
  String? expiredDate;
  bool? active;
  String? type;

  GetPaymentMethodDto(
      {this.id,
      this.number,
      this.holder,
      this.expiredDate,
      this.active,
      this.type});

  GetPaymentMethodDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    holder = json['holder'];
    expiredDate = json['expiredDate'];
    active = json['active'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['holder'] = this.holder;
    data['expiredDate'] = this.expiredDate;
    data['active'] = this.active;
    data['type'] = this.type;
    return data;
  }
}

class NewPaymentMethodDto {
  String? number;
  String? holder;
  String? expiredDate;
  String? cvv;

  NewPaymentMethodDto({this.number, this.holder, this.expiredDate, this.cvv});

  NewPaymentMethodDto.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    holder = json['holder'];
    expiredDate = json['expiredDate'];
    cvv = json['cvv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['holder'] = this.holder;
    data['expiredDate'] = this.expiredDate;
    data['cvv'] = this.cvv;
    return data;
  }
}
