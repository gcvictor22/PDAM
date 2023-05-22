import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/models/user/GetUserDto.dart';
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

  Future<dynamic> follow(String userName) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetUserDto response = await _userRepository.follow(userName);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> getProfile(int it) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      GetProfileDto response = await _userRepository.loadProfile(it);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updateFullName(String fullName) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updateFullName(fullName);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updateUserName(String userName) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updateUserName(userName);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updatePhoneNumber(String phoneNumber) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updatePhoneNumber(phoneNumber);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updateEmail(String email) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updateEmail(email);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updateProfileImg(XFile file) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updateProfileImg(file);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> updatePassword(
      String oldPassword, String newPassword, String newPasswordVerify) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.updatePasswords(
          oldPassword, newPassword, newPasswordVerify);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> getUserByUserName(int it, String userName) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.getUserByUserName(it, userName);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> getUserFollows(String id, int it) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.getUserFollows(id, it);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }

  Future<dynamic> getUserFollowers(String id, int it) async {
    String? token = await _localStorageService.getFromDisk("user_token");

    if (token != null) {
      var response = await _userRepository.getUserFollowers(id, it);
      return response;
    }
    throw new Exception("Ha ocurrido un error en el servicio");
  }
}
