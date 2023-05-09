//import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/verificationToken.dart';

import '../config/locator.dart';
import '../models/login.dart';
import '../models/user/GetUserDto.dart';
import '../models/user/user.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/user_repository.dart';
import 'localstorage_service.dart';

//import '../exceptions/exceptions.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<GetUserDto> register(
      String username,
      String password,
      String verifyPassword,
      String email,
      String phoneNumber,
      String fullName,
      int cityId,
      int genderId);
}

@Order(2)
//@Singleton(as: AuthenticationService)
@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  late LocalStorageService _localStorageService;
  late UserRepository _userRepository;

  JwtAuthenticationService() {
    _authenticationRepository = getIt<AuthenticationRepository>();
    _userRepository = getIt<UserRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    print("get current user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserResponse response = await _userRepository.profile();
      return response;
    }
    return null;
  }

  Future<VerificationToken?> verifyToken(
      String userName, String verificationNumber) async {
    VerificationToken response = await _authenticationRepository
        .registerVerification(userName, verificationNumber);
    return response;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    LoginResponse response =
        await _authenticationRepository.doLogin(email, password);
    //await _localStorageService.saveToDisk('user', jsonEncode(response.toJson()));
    await _localStorageService.saveToDisk('user_token', response.token);
    await _localStorageService.saveToDisk(
        'user_refresh_token', response.refreshToken);
    return User.fromLoginResponse(response);
  }

  @override
  Future<void> signOut() async {
    print("borrando token");
    await _localStorageService.deleteFromDisk("user_token");
    await _localStorageService.deleteFromDisk("user_refresh_token");
  }

  @override
  Future<GetUserDto> register(
      String username,
      String password,
      String verifyPassword,
      String email,
      String phoneNumber,
      String fullName,
      int cityId,
      int genderId) async {
    GetUserDto response = await _authenticationRepository.create(
        username,
        password,
        verifyPassword,
        email,
        phoneNumber,
        fullName,
        cityId,
        genderId);
    return GetUserDto.fromRegisterReqest(response);
  }
}
