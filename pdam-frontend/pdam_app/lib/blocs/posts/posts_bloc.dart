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

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  int it = 0;
  var hasReachedMax = false;

  PostsBloc({required this.httpClient}) : super(PostsInitial()) {
    on<PostsInitialEvent>((event, emit) async {
      await _onPostsFetched(event, emit);
    });

    on<PostsRefreshEvent>(
      (event, emit) async {
        await _onPostsRefresh(event, emit);
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
        emit(PostsSucces(posts: response.content));
        hasReachedMax = false;
        fetchedPosts = response.content;
        if (response.last != true) it += 1;
      } else if (state is PostsSucces && it > 0) {
        final response = await _fetchPosts(it);
        response.content.isEmpty
            ? hasReachedMax = true
            : {
                emit(PostsSucces(
                    posts: List.of(fetchedPosts)..addAll(response.content))),
                hasReachedMax = false,
                hasReachedMax = response.last,
                if (response.last != true) it += 1
              };
      }
    } catch (_) {
      print(_);
      emit(PostsFailure(error: "${_}"));
    }
  }

  Future<void> _onPostsRefresh(
    PostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final response = await _fetchPosts(0);
    response.content.isEmpty
        ? hasReachedMax = true
        : {
            emit(PostsSucces(posts: response.content)),
            hasReachedMax = response.last,
            fetchedPosts = response.content,
          };
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
