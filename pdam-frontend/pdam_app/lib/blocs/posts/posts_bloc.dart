import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/post/GetPostDto.dart';
import '../../models/post/GetPostDtoResponse.dart';

part 'posts_event.dart';
part 'posts_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  int it = 0;
  int itF = 0;
  var hasReachedMax = false;
  var hasReachedMaxF = false;
  dynamic fetchedPosts;
  dynamic fetchedFollowedPosts;
  final PostService _postService;

  PostsBloc(PostService postService)
      // ignore: unnecessary_null_comparison
      : assert(postService != null),
        _postService = postService,
        super(PostsInitial()) {
    on<PostsInitialEvent>((event, emit) async {
      await _onPostsFetched(event, emit);
    });

    on<PostsScrollEvent>(
      (event, emit) async {
        await _onScrollPosts(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<PostsRefreshEvent>(
      (event, emit) async {
        await _onPostsRefresh(event, emit);
      },
    );

    on<FollowedPostsScrollEvent>(
      (event, emit) async {
        await _onScrollFollowedPosts(event, emit);
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<FollowedPostsRefreshEvent>(
      (event, emit) async {
        await _onFollowedPostsRefresh(event, emit);
      },
    );

    on<LikeAPost>(
      (event, emit) async {
        await _likePost(event.postId);
      },
    );
  }

  Future<void> _onPostsFetched(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      if (state is PostsInitial) {
        final response = await _fetchPosts(it);
        final responseF = await _fetchFollowedPosts(itF);

        if (responseF is GetPostDtoResponse) {
          hasReachedMaxF = responseF.last;
          fetchedFollowedPosts = responseF.content;
          if (responseF.last != true) itF += 1;
        } else if (responseF is String) {
          fetchedFollowedPosts = responseF;
        }

        if (response is GetPostDtoResponse) {
          hasReachedMax = response.last;
          fetchedPosts = response.content;
          if (response.last != true) it += 1;
        } else if (response is String) {
          fetchedPosts = response;
        }

        emit(
          PostsSucces(
            posts: fetchedPosts,
            followedPosts: fetchedFollowedPosts,
          ),
        );
      }
    } catch (_) {
      print(_);
      emit(PostsFailure(error: "${_}"));
    }
  }

  Future<void> _onScrollPosts(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (hasReachedMax == false) {
      final response = await _fetchPosts(it);
      response.content.isEmpty
          ? hasReachedMax = true
          : {
              emit(PostsSucces(
                  posts: List.of(fetchedPosts)..addAll(response.content),
                  followedPosts: fetchedFollowedPosts)),
              hasReachedMax = response.last,
              if (response.last != true) it += 1
            };
    }
  }

  Future<void> _onScrollFollowedPosts(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (hasReachedMaxF == false) {
      final responseF = await _fetchFollowedPosts(itF);
      responseF.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(PostsSucces(
                  posts: fetchedPosts,
                  followedPosts: List.of(fetchedFollowedPosts)
                    ..addAll(responseF.content))),
              hasReachedMaxF = responseF.last,
              if (responseF.last != true) itF += 1
            };
    }
  }

  Future<void> _onPostsRefresh(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final response = await _fetchPosts(0);

    if (response is GetPostDtoResponse) {
      response.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(
                PostsSucces(
                  posts: response.content,
                  followedPosts: fetchedFollowedPosts,
                ),
              ),
              it = 1,
              hasReachedMax = response.last,
              fetchedPosts = response.content,
            };
    } else {
      emit(
        PostsSucces(
          posts: fetchedPosts,
          followedPosts: fetchedFollowedPosts,
        ),
      );
    }
  }

  Future<void> _onFollowedPostsRefresh(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final responseF = await _fetchFollowedPosts(0);
    if (responseF is GetPostDtoResponse) {
      responseF.content.isEmpty
          ? hasReachedMaxF = true
          : {
              emit(
                PostsSucces(
                  posts: fetchedPosts,
                  followedPosts: responseF.content,
                ),
              ),
              itF = 1,
              hasReachedMaxF = responseF.last,
              fetchedFollowedPosts = responseF.content,
            };
    } else {
      emit(
        PostsSucces(
          posts: fetchedPosts,
          followedPosts: fetchedFollowedPosts,
        ),
      );
    }
  }

  Future<dynamic> _fetchFollowedPosts(int startIndex) async {
    final response = await _postService.findFollowedPosts(startIndex);
    return response;
  }

  Future<dynamic> _fetchPosts(int startIndex) async {
    final response = await _postService.findAll(startIndex);
    return response;
  }

  Future<void> _likePost(int postId) async {
    final aux = await _postService.likePost(postId);

    for (var element in fetchedPosts) {
      if (element.id == aux.id) {
        element.likedByUser = aux.likedByUser;
        element.usersWhoLiked = aux.usersWhoLiked;
      }
    }

    if (fetchedFollowedPosts is List<GetPostDto>) {
      for (var element in fetchedFollowedPosts) {
        if (element.id == aux.id) {
          element.likedByUser = aux.likedByUser;
          element.usersWhoLiked = aux.usersWhoLiked;
        }
      }
    }
  }
}
