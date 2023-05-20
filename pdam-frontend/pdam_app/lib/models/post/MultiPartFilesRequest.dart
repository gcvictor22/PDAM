class MultiPartFilesRequest {
  late String name;
  late String uri;
  late String type;
  late int size;

  MultiPartFilesRequest(
      {required this.name,
      required this.uri,
      required this.type,
      required this.size});

  MultiPartFilesRequest.fromJson(List<dynamic> list) {
    for (var json in list) {
      name = json['name'];
      uri = json['uri'];
      type = json['type'];
      size = json['size'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uri'] = this.uri;
    data['type'] = this.type;
    data['size'] = this.size;
    return data;
  }
}

class MultiPartFileRequest {
  late String name;
  late String uri;
  late String type;
  late int size;

  MultiPartFileRequest(
      {required this.name,
      required this.uri,
      required this.type,
      required this.size});

  MultiPartFileRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uri = json['uri'];
    type = json['type'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uri'] = this.uri;
    data['type'] = this.type;
    data['size'] = this.size;
    return data;
  }
}
