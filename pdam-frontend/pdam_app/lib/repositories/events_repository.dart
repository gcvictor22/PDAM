import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:pdam_app/models/event/GetFestivalDto.dart';
import 'package:pdam_app/models/event/GetPartiesResponse.dart';

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

  Future<dynamic> findAllEvents(int index, [dynamic name]) async {
    String url;

    switch (name != null) {
      case true:
        url = "/event/?page=$index&s=name:$name";
        break;
      default:
        url = "/event/?page=$index";
    }

    var response = await _client.get(url);
    if (response is NotFoundException) {
      String aux = "No se ha encontrado ningún evento...";
      return aux;
    }

    return GetEventDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> findAllDiscothequeParties(int id, int it) async {
    String url = "/party/$id?page=$it";

    var response = await _client.get(url);
    return GetPartiesResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> buyParty(int id) async {
    String url = "/party/buy/$id";

    var response = await _client.post(url);
    return GetPartyDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> confirmPartyBuy(String stripeId) async {
    String url = "/party/confirm/$stripeId";
    await _client.post(url);
  }

  Future<dynamic> cancelPartyBuy(String stripeId) async {
    String url = "/party/cancel/$stripeId";
    await _client.post(url);
  }

  Future<dynamic> buyFestival(int id) async {
    String url = "/festival/buy/$id";

    var response = await _client.post(url);
    return GetFestivalDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> confirmFestivalBuy(String stripeId) async {
    String url = "/festival/confirm/$stripeId";
    await _client.post(url);
  }

  Future<dynamic> cancelFestivalBuy(String stripeId) async {
    String url = "/festival/cancel/$stripeId";
    await _client.post(url);
  }

  Future<dynamic> findFestival(int id) async {
    String url = "/festival/$id";
    var response = await _client.get(url);
    return GetFestivalDto.fromJson(jsonDecode(response));
  }
}
