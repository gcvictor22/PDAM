import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/verificationToken.dart';

import '../models/login.dart';
import '../models/user/GetUserDto.dart';
import '../models/user/user.dart';
import '../rest/rest_client.dart';
import 'package:http/http.dart' as http;

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/user/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> create(
      String username,
      String password,
      String verifyPassword,
      String email,
      String phoneNumber,
      String fullName,
      int cityId,
      int genderId) async {
    String url = "/user/register";

    var jsonResponse = await _client.post(
        url,
        RegisterRequest(
            username: username,
            password: password,
            verifyPassword: verifyPassword,
            email: email,
            phoneNumber: phoneNumber,
            fullName: fullName,
            cityId: cityId,
            genderId: genderId));
    return GetUserDto.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> registerVerification(
      String userName, String verificationNumber) async {
    String url = ApiConstants.baseUrl + "/user/verification";
    String body = jsonEncode(
        {"userName": userName, "verificationNumber": verificationNumber});
    Map<String, String> headers = {'Content-Type': 'application/json'};

    var response = await http.put(Uri.parse(url), body: body, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return VerificationToken.fromJson(jsonResponse);
    }
    throw Exception(response.body);
  }
}
