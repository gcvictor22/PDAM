import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/user/GetUserResponse.dart';
import 'package:pdam_app/repositories/user_repository.dart';

import '../config/locator.dart';
import 'localstorage_service.dart';

@Order(2)
@singleton
class UserService {
  late UserRepository _userRepository;
  late LocalStorageService _localStorageService;

  UserService() {
    _userRepository = getIt<UserRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<dynamic> findAll(String search) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetUserResponse response = await _userRepository.findAll(search);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }
}
