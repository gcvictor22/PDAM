import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:pdam_app/models/event/GetFestivalDto.dart';
import 'package:pdam_app/models/event/GetPartiesResponse.dart';
import 'package:pdam_app/repositories/events_repository.dart';
import 'package:pdam_app/services/services.dart';

@Order(2)
@singleton
class EventService {
  late EventRepository _eventRepository;
  late LocalStorageService _localStorageService;

  EventService() {
    _eventRepository = getIt<EventRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<dynamic> findAllDiscotheques(int index) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetEventDtoResponse response =
          await _eventRepository.findAllDiscotheques(index);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> findAllFestivals(int index) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetEventDtoResponse response =
          await _eventRepository.findAllFestivals(index);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> findAll(int index, [dynamic name]) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetEventDtoResponse response =
          await _eventRepository.findAllEvents(index, name);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> findAllPartiesFromDiscotheques(int id, int it) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetPartiesResponse response =
          await _eventRepository.findAllDiscothequeParties(id, it);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<GetPartyDto> buyParty(int id) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetPartyDto response = await _eventRepository.buyParty(id);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> confirmPartyBuy(String stripeId) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      return await _eventRepository.confirmPartyBuy(stripeId);
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> cancelPartyBuy(String stripeId) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      return await _eventRepository.cancelPartyBuy(stripeId);
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<GetFestivalDto> buyFestival(int id) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetFestivalDto response = await _eventRepository.buyFestival(id);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> confirmFestivalBuy(String stripeId) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      return await _eventRepository.confirmFestivalBuy(stripeId);
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> cancelFestivalBuy(String stripeId) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      return await _eventRepository.cancelFestivalBuy(stripeId);
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<GetFestivalDto> findFestival(int id) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      return await _eventRepository.findFestival(id);
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }
}
