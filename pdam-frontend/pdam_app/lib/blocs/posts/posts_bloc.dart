import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../models/post/GetPostDto.dart';
import '../../models/post/GetPostDtoResponse.dart';
import '../../services/localstorage_service.dart';

part 'posts_event.dart';
part 'posts_state.dart';

List<GetPostDto> fetchedPosts = [];
List<GetPostDto> fetchedFollowedPosts = [];

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  int it = 0;
  int itF = 0;
  var hasReachedMax = false;
  var hasReachedMaxF = false;

  PostsBloc({required this.httpClient}) : super(PostsInitial()) {
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
  }

  final http.Client httpClient;

  Future<void> _onPostsFetched(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      if (state is PostsInitial) {
        final response = await _fetchPosts(it);
        final responseF = await _fetchFollowedPosts(itF);
        emit(PostsSucces(
            posts: response.content, followedPosts: responseF.content));
        hasReachedMax = response.last;
        hasReachedMaxF = responseF.last;
        fetchedPosts = response.content;
        fetchedFollowedPosts = responseF.content;
        if (response.last != true) it += 1;
        if (responseF.last != true) itF += 1;
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
    response.content.isEmpty
        ? hasReachedMaxF = true
        : {
            emit(PostsSucces(
                posts: response.content, followedPosts: fetchedFollowedPosts)),
            hasReachedMax = response.last,
            fetchedPosts = response.content,
          };
  }

  Future<void> _onFollowedPostsRefresh(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final responseF = await _fetchFollowedPosts(0);
    responseF.content.isEmpty
        ? hasReachedMaxF = true
        : {
            emit(PostsSucces(
                posts: responseF.content, followedPosts: fetchedFollowedPosts)),
            hasReachedMaxF = responseF.last,
            fetchedFollowedPosts = responseF.content,
          };
  }

  Future<GetPostDtoResponse> _fetchFollowedPosts(int startIndex) async {
    late LocalStorageService _localStorageService = LocalStorageService();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);

    var aux;
    var token = await _localStorageService.getFromDisk("user_token");

    await httpClient.get(
        Uri.parse('http://localhost:8080/post/followsPosts?page=$startIndex'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + token,
          "Charset": "UTF-8"
        }).then((value) {
      aux = GetPostDtoResponse.fromJson(
        jsonDecode(
          Utf8Decoder().convert(value.body.codeUnits),
        ),
      );
      // ignore: invalid_return_type_for_catch_error
    }).catchError((e) => print(e));
    return aux;
  }

  Future<GetPostDtoResponse> _fetchPosts(int startIndex) async {
    late LocalStorageService _localStorageService = LocalStorageService();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);

    var aux;
    var token = await _localStorageService.getFromDisk("user_token");

    await httpClient.get(
        Uri.parse('http://localhost:8080/post/?page=$startIndex'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer " + token,
          "Charset": "UTF-8"
        }).then((value) {
      aux = GetPostDtoResponse.fromJson(
        jsonDecode(
          Utf8Decoder().convert(value.body.codeUnits),
        ),
      );
      // ignore: invalid_return_type_for_catch_error
    }).catchError((e) => print(e));
    return aux;
  }
}
