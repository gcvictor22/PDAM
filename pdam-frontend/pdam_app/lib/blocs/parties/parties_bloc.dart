import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/services/event_service.dart';

import '../../models/event/GetPartiesResponse.dart';

part 'parties_event.dart';
part 'parties_state.dart';

class PartiesBloc extends Bloc<PartiesEvent, PartiesState> {
  final int id;
  final EventService _eventService;
  var it = 0;
  var hasReachedMax;
  var fetchedParties;

  PartiesBloc(EventService eventService, this.id)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService,
        super(PartiesInitial()) {
    on<PartiesInitialEvent>((event, emit) async {
      await _onPartiesFetched(event, emit);
    });

    on<PartiesScrollEvent>((event, emit) async {
      await _onScrollPosts(event, emit);
    });
  }

  Future<void> _onPartiesFetched(
      PartiesEvent event, Emitter<PartiesState> emit) async {
    try {
      GetPartiesResponse response = await _fetchParties(id, 0);

      hasReachedMax = response.last;
      fetchedParties = response.content;
      if (!response.last!) it += 1;

      emit(PartiesSuccess(parties: response.content!));
    } catch (e) {
      emit(PartiesFailure(error: e.toString()));
    }
  }

  Future<void> _onScrollPosts(
      PartiesEvent event, Emitter<PartiesState> emit) async {
    if (hasReachedMax == false) {
      GetPartiesResponse response = await _fetchParties(id, it);
      response.content!.isEmpty
          ? hasReachedMax = true
          : {
              emit(
                PartiesSuccess(
                  parties: List.of(fetchedParties)..addAll(response.content!),
                ),
              ),
              hasReachedMax = response.last,
              fetchedParties = List.of(fetchedParties)
                ..addAll(response.content!),
              if (response.last != true) it += 1
            };
    }
  }

  Future<dynamic> _fetchParties(int id, int it) async {
    return await _eventService.findAllPartiesFromDiscotheques(id, it);
  }
}
