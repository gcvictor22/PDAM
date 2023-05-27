import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/services/user_service.dart';

import '../../models/post/GetPostDto.dart';
import '../../models/user/GetProfile.dart';
import '../../services/post_service.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserService _userService;
  final PostService _postService;
  final String userName;
  var it = 0;
  var hasReachedMax = false;
  var fetchedPosts;

  UserDetailsBloc(
      UserService userService, PostService postService, this.userName)
      // ignore: unnecessary_null_comparison
      : assert(userService != null, postService != null),
        _postService = postService,
        _userService = userService,
        super(UserDetailsInitial()) {
    on<UserDetailsInitialEvent>((event, emit) async {
      await _loadUser(event, emit, userName);
    });

    on<UserDetailsScrollPostsEvent>(
      (event, emit) async {
        await _onScrollPosts(event, emit);
      },
    );

    on<UserDetailsLikeAPost>(
      (event, emit) async {
        await _likeAPost(event.id);
      },
    );

    on<UserDetailsFollowEvent>((event, emit) async {
      await _followUser(userName);
    });
  }

  Future<void> _loadUser(
    UserDetailsEvent event,
    Emitter<UserDetailsState> emit,
    String userName,
  ) async {
    try {
      GetProfileDto response = await _fethUser(0, userName);

      hasReachedMax = response.publishedPosts!.last!;
      fetchedPosts = response.publishedPosts!.content!;
      if (response.publishedPosts!.last! != true) it += 1;

      emit(
        UserDetailsSucces(
          profile: response,
          posts: response.publishedPosts!.content!,
        ),
      );
    } on Exception catch (_) {
      emit(UserDetailsFailure(
          error: "No ha sido posible cargar los datos del usuario"));
    }
  }

  Future<void> _onScrollPosts(
    UserDetailsEvent event,
    Emitter<UserDetailsState> emit,
  ) async {
    if (hasReachedMax == false) {
      GetProfileDto response = await _fethUser(it, userName);
      response.publishedPosts!.content!.isEmpty
          ? hasReachedMax = true
          : {
              emit(
                UserDetailsSucces(
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

  Future<dynamic> _fethUser(int it, String userName) async {
    return await _userService.getUserByUserName(it, userName);
  }

  Future<dynamic> _followUser(String userName) async {
    return await _userService.follow(userName);
  }

  Future<dynamic> _likeAPost(int id) async {
    return await _postService.likePost(id);
  }
}
