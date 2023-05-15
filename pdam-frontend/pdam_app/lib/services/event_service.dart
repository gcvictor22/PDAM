import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
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
}
