import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';

import '../config/locator.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class EventRepository {
  late RestAuthenticatedClient _client;

  EventRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> findAllDiscotheques(int index) async {
    String url = "/discotheque/?page=${index}";

    var response = await _client.get(url);

    if (response is NotFoundException) {
      String aux = "No se ha encontrado ninguna discoteca...";
      return aux;
    }

    return GetEventDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> findAllFestivals(int index) async {
    String url = "/festival/?page=${index}";

    var response = await _client.get(url);
    if (response is NotFoundException) {
      String aux = "No se ha encontrado ningún festival...";
      return aux;
    }

    return GetEventDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> findAllEvents(int index) async {
    String url = "/event/?page=${index}";

    var response = await _client.get(url);
    if (response is NotFoundException) {
      String aux = "No se ha encontrado ningún evento...";
      return aux;
    }

    return GetEventDtoResponse.fromJson(jsonDecode(response));
  }
}
