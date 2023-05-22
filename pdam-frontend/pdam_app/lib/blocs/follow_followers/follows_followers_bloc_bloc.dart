import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/models/user/FollowsAndFollowersResponse.dart';
import 'package:pdam_app/services/user_service.dart';

part 'follows_followers_bloc_event.dart';
part 'follows_followers_bloc_state.dart';

class FollowsFollowersBloc
    extends Bloc<FollowsFollowersEvent, FollowsFollowersState> {
  int it = 0;
  int itF = 0;
  var hasReachedMax = false;
  var hasReachedMaxF = false;
  dynamic fetchedFollows;
  dynamic fetchedFollowers;
  final UserService _userService;
  final String id;

  FollowsFollowersBloc(UserService userService, this.id)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService,
        super(FollowsFollowersBlocInitial()) {
    on<FollowsFollowersInitialEvent>((event, emit) async {
      await _fetchAll(event, emit);
    });

    on<FollowsFollowersFollowEvent>(
      (event, emit) async {
        await _followUser(event.userName);
        await _fetchAll(event, emit);
      },
    );
  }

  Future<void> _fetchAll(
    FollowsFollowersEvent event,
    Emitter<FollowsFollowersState> emit,
  ) async {
    try {
      final response = await _getUserFollows(id, it);
      final responseF = await _getUserFollowers(id, itF);

      if (responseF is FollowsAndFollowersResponse) {
        hasReachedMaxF = responseF.last!;
        fetchedFollowers = responseF.content;
        if (responseF.last != true) itF += 1;
      } else if (responseF is String) {
        fetchedFollowers = responseF;
      }

      if (response is FollowsAndFollowersResponse) {
        hasReachedMax = response.last!;
        fetchedFollows = response.content;
        if (response.last != true) it += 1;
      } else if (response is String) {
        fetchedFollows = response;
      }

      emit(
        FollowsFollowersSuccess(
          follows: fetchedFollows,
          followers: fetchedFollowers,
        ),
      );
    } catch (_) {
      print(_);
      emit(FollowsFollowersFailure(error: "${_}"));
    }
  }

  Future<void> _onScrollFollows(
    FollowsFollowersEvent event,
    Emitter<FollowsFollowersState> emit,
  ) async {
    if (hasReachedMax == false) {
      final response = await _getUserFollows(id, it);
      response.content.isEmpty
          ? hasReachedMax = true
          : {
              emit(FollowsFollowersSuccess(
                  follows: List.of(fetchedFollows)..addAll(response.content),
                  followers: fetchedFollowers)),
              hasReachedMax = response.last,
              if (response.last != true) it += 1
            };
    }
  }

  Future<void> _onScrollFollowers(
    FollowsFollowersEvent event,
    Emitter<FollowsFollowersState> emit,
  ) async {
    if (hasReachedMaxF == false) {
      final responseF = await _getUserFollowers(id, itF);
      responseF.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(FollowsFollowersSuccess(
                  follows: fetchedFollows,
                  followers: List.of(fetchedFollowers)
                    ..addAll(responseF.content))),
              hasReachedMaxF = responseF.last,
              if (responseF.last != true) itF += 1
            };
    }
  }

  Future<dynamic> _getUserFollows(String id, int it) async {
    return await _userService.getUserFollows(id, it);
  }

  Future<dynamic> _getUserFollowers(String id, int it) async {
    return await _userService.getUserFollowers(id, it);
  }

  Future<dynamic> _followUser(String userName) async {
    return await _userService.follow(userName);
  }
}
