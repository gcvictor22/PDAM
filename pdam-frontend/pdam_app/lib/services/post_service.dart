import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/models/post/GetPostDto.dart';
import 'package:pdam_app/models/post/GetPostDtoResponse.dart';
import 'package:pdam_app/repositories/post_repository.dart';
import 'package:pdam_app/services/services.dart';

@Order(2)
@singleton
class PostService {
  late PostRepository _postRepository;
  late LocalStorageService _localStorageService;

  PostService() {
    _postRepository = getIt<PostRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<dynamic> findAll(int index) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetPostDtoResponse response = await _postRepository.findAll(index);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> findFollowedPosts(int index) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      dynamic response = await _postRepository.findFollowedPosts(index);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<GetPostDto> likePost(int postId) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetPostDto response = await _postRepository.likePost(postId);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }
}
