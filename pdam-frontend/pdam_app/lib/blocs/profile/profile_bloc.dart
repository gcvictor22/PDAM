import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/models/post/GetPostDto.dart';
import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:stream_transform/stream_transform.dart';

part 'profile_event.dart';
part 'profile_state.dart';

const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  var it = 0;
  var hasReachedMax = false;
  var fetchedPosts;

  final UserService _userService;
  final PostService _postService;
  ProfileBloc(UserService userService, PostService postService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null, postService != null),
        _userService = userService,
        _postService = postService,
        super(ProfileInitial()) {
    on<ProfileInitialEvent>((event, emit) async {
      await _onProfileFetched(event, emit);
    });

    on<ProfileFollowEvent>((event, emit) async {
      await _followUser(event.userName);
    });

    on<ProfileLikeAPost>((event, emit) async {
      await _likeAPost(event.id);
    });

    on<ProfileScrollPostsEvent>((event, emit) async {
      await _onScrollPosts(event, emit);
    }, transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onProfileFetched(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      GetProfileDto response = await _fethProfile(it);
      hasReachedMax = response.publishedPosts!.last!;
      fetchedPosts = response.publishedPosts!.content!;
      if (response.publishedPosts!.last! != true) it += 1;

      emit(ProfileSucces(
          profile: response, posts: response.publishedPosts!.content!));
    } catch (_) {
      emit(ProfileFailure(error: "No se ha podido cargar el perfil"));
    }
  }

  Future<void> _onScrollPosts(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (hasReachedMax == false) {
      GetProfileDto response = await _fethProfile(it);
      response.publishedPosts!.content!.isEmpty
          ? hasReachedMax = true
          : {
              emit(
                ProfileSucces(
                  profile: response,
                  posts: List.of(fetchedPosts)
                    ..addAll(response.publishedPosts!.content!),
                ),
              ),
              hasReachedMax = response.publishedPosts!.last!,
              if (response.publishedPosts!.last! != true) it += 1
            };
    }
  }

  Future<dynamic> _fethProfile(int it) async {
    return await _userService.getProfile(it);
  }

  Future<dynamic> _followUser(String userName) async {
    return await _userService.follow(userName);
  }

  Future<dynamic> _likeAPost(int id) async {
    return await _postService.likePost(id);
  }
}
