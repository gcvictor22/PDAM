import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../config/locator.dart';
import '../models/user.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class UserRepository {
  late RestAuthenticatedClient _client;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> profile() async {
    String url = "/user/profile";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }
}
