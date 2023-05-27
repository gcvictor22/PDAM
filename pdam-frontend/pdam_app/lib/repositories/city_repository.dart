import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pdam_app/rest/rest_client.dart';

import '../config/locator.dart';
import '../models/city.dart';

@Order(-1)
@singleton
class CityRepository {
  late RestClient _client;

  CityRepository() {
    _client = getIt<RestClient>();
  }

  Future<List<GetCityDto>> findAll() async {
    String url = "/city/";

    var response = await _client.get(url);
    var jsonList = jsonDecode(response) as List;
    return List.from(jsonList.map((cityJson) => GetCityDto.fromJson(cityJson)));
  }
}
