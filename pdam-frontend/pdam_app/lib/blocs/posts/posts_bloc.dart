import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/services/post_service.dart';

import '../../models/post/GetPostDto.dart';
import '../../models/post/GetPostDtoResponse.dart';

part 'posts_event.dart';
part 'posts_state.dart';

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
        } else {
          fetchedPosts = "No hay ningún post en esta página...";
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
    final response = await _fetchPosts(it);
    response.content.isEmpty || hasReachedMax
        ? hasReachedMax = true
        : {
            emit(PostsSucces(
                posts: List.of(fetchedPosts)..addAll(response.content),
                followedPosts: fetchedFollowedPosts)),
            hasReachedMax = response.last,
            if (response.last != true) it += 1
          };
  }

  Future<void> _onScrollFollowedPosts(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final responseF = await _fetchFollowedPosts(itF);
    responseF.content.isEmpty || hasReachedMaxF
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
              it = 0,
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
                  posts: responseF.content,
                  followedPosts: fetchedFollowedPosts,
                ),
              ),
              itF = 0,
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
    // late LocalStorageService _localStorageService = LocalStorageService();
    // GetIt.I
    //     .getAsync<LocalStorageService>()
    //     .then((value) => _localStorageService = value);

    // var aux;
    // var token = await _localStorageService.getFromDisk("user_token");

    // final response = await httpClient.get(
    //     Uri.parse('http://localhost:8080/post/?page=$startIndex'),
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Accept": "application/json",
    //       "Authorization": "Bearer " + token,
    //       "Charset": "UTF-8"
    //     });

    // if (response.statusCode == 200) {
    //   aux = GetPostDtoResponse.fromJson(
    //     jsonDecode(
    //       Utf8Decoder().convert(response.body.codeUnits),
    //     ),
    //   );
    // } else if (response.statusCode == 404) {
    //   aux = BadRequestException.fromJson(jsonDecode(response.body));
    // }
    // return aux;

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
