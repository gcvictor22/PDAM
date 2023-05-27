import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/models/post/GetPostDto.dart';
import 'package:pdam_app/models/post/GetPostDtoResponse.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/services/user_service.dart';

part 'liked_posts_event.dart';
part 'liked_posts_state.dart';

class LikedPostsBloc extends Bloc<LikedPostsEvent, LikedPostsState> {
  final String id;
  var it = 0;
  var fetchedPosts;
  var hasReachedMax;
  final UserService _userService;
  final PostService _postService;

  LikedPostsBloc(UserService userService, PostService postService, this.id)
      // ignore: unnecessary_null_comparison
      : assert(userService != null, postService != null),
        _userService = userService,
        _postService = postService,
        super(LikedPostsInitial()) {
    on<LikedPostsInitialEvent>((event, emit) async {
      await _onInitialFetch(event, emit, id);
    });

    on<LikedPostsScrollEvent>((event, emit) async {
      await _onScrollPosts(event, emit, id);
    });

    on<LikedPostsLikeEvent>((event, emit) async {
      await _likeAPost(event.id);
    });
  }

  Future<void> _onInitialFetch(
    LikedPostsEvent event,
    Emitter<LikedPostsState> emit,
    String id,
  ) async {
    try {
      GetPostDtoResponse response = await _fetchPosts(id, it);

      hasReachedMax = response.last;
      fetchedPosts = response.content;
      if (response.last != true) it += 1;

      emit(LikedPostsSuccess(likedPosts: response.content));
    } catch (e) {
      emit(LikedPostsFailure(error: e.toString()));
    }
  }

  Future<void> _onScrollPosts(
    LikedPostsEvent event,
    Emitter<LikedPostsState> emit,
    String id,
  ) async {
    if (hasReachedMax == false) {
      GetPostDtoResponse response = await _fetchPosts(id, it);
      response.content.isEmpty
          ? hasReachedMax = true
          : {
              emit(
                LikedPostsSuccess(
                  likedPosts: List.of(fetchedPosts)..addAll(response.content),
                ),
              ),
              hasReachedMax = response.last,
              fetchedPosts = List.of(fetchedPosts)..addAll(response.content),
              if (response.last != true) it += 1
            };
    }
  }

  Future<dynamic> _fetchPosts(String id, int it) async {
    return await _userService.getUserLikedPosts(id, it);
  }

  Future<dynamic> _likeAPost(int id) async {
    return await _postService.likePost(id);
  }
}
