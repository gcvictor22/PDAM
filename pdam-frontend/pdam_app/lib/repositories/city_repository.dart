import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pdam_app/rest/rest_client.dart';

import '../models/city.dart';

@Order(-1)
@singleton
class CityRepository {
  final RestClient _client = RestClient();

  Future<List<GetCityDto>> findAll() async {
    String url = "/city/";

    var jsonResponse = await _client.get(url);
    var jsonList = jsonDecode(jsonResponse) as List;
    return List.from(jsonList.map((cityJson) => GetCityDto.fromJson(cityJson)));
  }
}
