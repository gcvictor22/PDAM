import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/models/user/GetUserDto.dart';
import 'package:pdam_app/models/user/GetUserResponse.dart';
import 'package:pdam_app/models/user/user.dart';

import '../config/locator.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class UserRepository {
  late RestAuthenticatedClient _client;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> profile() async {
    String url = "/user/profile/";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> findAll(String search) async {
    String url = "/user/?s=userName:$search";

    var jsonResponse = await _client.get(url);
    return GetUserResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> follow(String userName) async {
    String url = "/user/follow/$userName";

    var jsonResponse = await _client.post(url);
    return GetUserDto.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> loadProfile([int? it]) async {
    String url = "/user/profile/?page=$it";

    var jsonResponse = await _client.get(url);
    return GetProfileDto.fromJson(jsonDecode(jsonResponse));
  }
}
