import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/models/post/GetPostDtoResponse.dart';
import 'package:pdam_app/models/post/MultiPartFilesRequest.dart';
import 'package:pdam_app/models/post/NewPostDto.dart';

import '../models/post/GetPostDto.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class PostRepository {
  late RestAuthenticatedClient _client;

  PostRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> findAll(int index) async {
    String url = "/post/?page=${index}";

    var response = await _client.get(url);

    if (response is NotFoundException) {
      String aux = "No se ha encontrado ningún post en esta página de...";
      return aux;
    }

    return GetPostDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> findFollowedPosts(int index) async {
    String url = "/post/followsPosts?page=${index}";

    var response = await _client.get(url);

    if (response is NotFoundException) {
      String aux = "No se ha encontrado ningún post en esta página...";
      return aux;
    }

    return GetPostDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> likePost(int postId) async {
    String url = "/post/like/${postId}";

    var response = await _client.post(url);
    return GetPostDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> create(NewPostDto post) async {
    String url = "/post/";

    var response = await _client.post(url, post);
    return GetPostDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> uploadFile(List<XFile> files, int postId) async {
    String url = "/post/$postId/upload";

    StreamedResponse response = await _client.postMultipart(url, files);
    var stringResponse = await response.stream.bytesToString();

    return MultiPartFilesRequest.fromJson(jsonDecode(stringResponse));
  }
}
