import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:pdam_app/models/user/GetUserResponse.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/user_service.dart';
part 'search_event.dart';
part 'search_state.dart';

const throttleDuration = Duration(milliseconds: 500);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserService _userService;
  final EventService _eventService;
  final TextEditingController _controller;
  dynamic users;
  dynamic events;

  SearchBloc(
      this._controller, UserService userService, EventService eventService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null, eventService != null),
        _userService = userService,
        _eventService = eventService,
        super(SearchInitial()) {
    on<SearchInitialEvent>((event, emit) async {
      await _onInit(event, emit);
    });

    on<SearchWriteEvent>(
      (event, emit) async {
        await _fetchResponse(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<SearchFollowEvent>((event, emit) async {
      await _follow(event.userName);
    });
  }

  _onInit(
    SearchEvent event,
    Emitter<SearchState> emit,
  ) {
    users = false;
    events = false;
    emit(SearchSuccess(users: users, events: events));
  }

  Future<void> _fetchResponse(
    SearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      var userResponse = await _fetchUsers(_controller.text);
      var eventResponse = await _fetchEvents(_controller.text);

      if (userResponse is GetUserResponse) {
        if (userResponse.content!.isEmpty) {
          users = false;
        } else {
          users = userResponse.content;
        }
      }

      if (eventResponse is GetEventDtoResponse) {
        if (eventResponse.content.isEmpty) {
          events = false;
        } else {
          events = eventResponse.content;
        }
      }

      emit(SearchSuccess(users: users, events: events));
    } on Exception catch (_) {
      emit(SearchFailure());
    }
  }

  Future<dynamic> _fetchUsers(String search) async {
    return await _userService.findAll(search);
  }

  Future<dynamic> _fetchEvents(String search) async {
    return await _eventService.findAll(0, search);
  }

  Future<dynamic> _follow(String userName) async {
    return await _userService.follow(userName);
  }
}
