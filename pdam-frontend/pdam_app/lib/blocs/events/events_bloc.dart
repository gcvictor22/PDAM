import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:stream_transform/stream_transform.dart';

part 'events_event.dart';
part 'events_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  int itD = 0;
  int itF = 0;
  int itA = 0;
  var hasReachedMaxD = false;
  var hasReachedMaxF = false;
  var hasReachedMaxA = false;
  dynamic fetchedDiscotheques;
  dynamic fetchedFestivals;
  dynamic fetchedEvents;
  final EventService _eventService;

  EventsBloc(EventService eventService)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService,
        super(EventsInitial()) {
    on<EventsEvent>(
      (event, emit) async {
        await _fetchAllEvents(event, emit);
      },
    );

    on<ScrollDiscothequesEvent>(
      (event, emit) async {
        await _onScrollDiscotheques(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<ScrollFestivalEvent>(
      (event, emit) async {
        await _onScrollFestivals(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<ScrollEventsEvent>(
      (event, emit) async {
        await _onScrollEvents(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<RefreshDiscothequesEvent>(
      (event, emit) async {
        await _onDiscothequesRefresh(event, emit);
      },
    );

    on<RefreshFestivalsEvent>(
      (event, emit) async {
        await _onFestivalsRefresh(event, emit);
      },
    );

    on<RefreshEventsEvent>(
      (event, emit) async {
        await _onEventsRefresh(event, emit);
      },
    );
  }

  Future<void> _fetchAllEvents(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (state is EventsInitial) {
        final responseD = await _fetchDiscotheques(itD);
        final responseF = await _fetchFestivals(itF);
        final responseA = await _fetchAll(itA);
        if (responseD is GetEventDtoResponse) {
          hasReachedMaxD = responseD.last;
          fetchedDiscotheques = responseD.content;
          if (responseD.last != true) itD += 1;
        } else if (responseD is String) {
          fetchedDiscotheques = responseD;
        }

        if (responseF is GetEventDtoResponse) {
          hasReachedMaxF = responseF.last;
          fetchedFestivals = responseF.content;
          if (responseF.last != true) itF += 1;
        } else if (responseF is String) {
          fetchedFestivals = responseF;
        }

        if (responseA is GetEventDtoResponse) {
          hasReachedMaxA = responseA.last;
          fetchedEvents = responseA.content;
          if (responseA.last != true) itA += 1;
        } else if (responseA is String) {
          fetchedEvents = responseA;
        }

        emit(
          EventsSuccess(
            discotheques: fetchedDiscotheques,
            events: fetchedEvents,
            festivals: fetchedFestivals,
          ),
        );
      }
    } catch (_) {
      print(_);
      emit(EventsFailure(error: "${_}"));
    }
  }

  Future<void> _onScrollDiscotheques(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (hasReachedMaxD == false) {
      final response = await _fetchDiscotheques(itD);
      response.content.isEmpty
          ? hasReachedMaxD = true
          : {
              emit(EventsSuccess(
                  discotheques: List.of(fetchedDiscotheques)
                    ..addAll(response.content),
                  events: fetchedEvents,
                  festivals: fetchedFestivals)),
              hasReachedMaxD = response.last,
              if (response.last != true) itD += 1
            };
    }
  }

  Future<void> _onScrollFestivals(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (hasReachedMaxF == false) {
      final response = await _fetchFestivals(itD);
      response.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(EventsSuccess(
                  discotheques: fetchedDiscotheques,
                  events: fetchedEvents,
                  festivals: List.of(fetchedFestivals)
                    ..addAll(response.content))),
              hasReachedMaxF = response.last,
              if (response.last != true) itF += 1
            };
    }
  }

  Future<void> _onScrollEvents(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (hasReachedMaxA == false) {
      final response = await _fetchAll(itA);
      response.content.isEmpty
          ? hasReachedMaxA = true
          : {
              emit(EventsSuccess(
                  discotheques: fetchedDiscotheques,
                  events: List.of(fetchedEvents)..addAll(response.content),
                  festivals: fetchedFestivals)),
              hasReachedMaxA = response.last,
              if (response.last != true) itA += 1
            };
    }
  }

  Future<void> _onDiscothequesRefresh(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    final response = await _fetchDiscotheques(0);

    if (response is GetEventDtoResponse) {
      response.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(
                EventsSuccess(
                    discotheques: response.content,
                    festivals: fetchedFestivals,
                    events: fetchedEvents),
              ),
              itD = 1,
              hasReachedMaxD = response.last,
              fetchedDiscotheques = response.content,
            };
    } else {
      emit(
        EventsSuccess(
            discotheques: fetchedDiscotheques,
            festivals: fetchedFestivals,
            events: fetchedEvents),
      );
    }
  }

  Future<void> _onFestivalsRefresh(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    final response = await _fetchFestivals(0);

    if (response is GetEventDtoResponse) {
      response.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(
                EventsSuccess(
                    discotheques: fetchedDiscotheques,
                    festivals: response.content,
                    events: fetchedEvents),
              ),
              itF = 1,
              hasReachedMaxF = response.last,
              fetchedFestivals = response.content,
            };
    } else {
      emit(
        EventsSuccess(
            discotheques: fetchedDiscotheques,
            festivals: fetchedFestivals,
            events: fetchedEvents),
      );
    }
  }

  Future<void> _onEventsRefresh(
    EventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    final response = await _fetchAll(0);

    if (response is GetEventDtoResponse) {
      response.content.isEmpty
          ? hasReachedMaxA = true
          : {
              emit(
                EventsSuccess(
                    discotheques: fetchedDiscotheques,
                    festivals: fetchedFestivals,
                    events: response.content),
              ),
              itA = 1,
              hasReachedMaxA = response.last,
              fetchedEvents = response.content,
            };
    } else {
      emit(
        EventsSuccess(
            discotheques: fetchedDiscotheques,
            festivals: fetchedFestivals,
            events: fetchedEvents),
      );
    }
  }

  Future<dynamic> _fetchDiscotheques(int index) async {
    final response = await _eventService.findAllDiscotheques(index);
    return response;
  }

  Future<dynamic> _fetchFestivals(int index) async {
    final response = await _eventService.findAllFestivals(index);
    return response;
  }

  Future<dynamic> _fetchAll(int index) async {
    final response = await _eventService.findAll(index);
    return response;
  }
}
