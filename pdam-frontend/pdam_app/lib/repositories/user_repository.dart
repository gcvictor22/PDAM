import 'dart:convert';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pdam_app/models/payment_method.dart';
import 'package:pdam_app/models/post/MultiPartFilesRequest.dart';
import 'package:pdam_app/models/user/EditModel.dart';
import 'package:pdam_app/models/user/FollowsAndFollowersResponse.dart';
import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/models/user/GetUserDto.dart';
import 'package:pdam_app/models/user/GetUserResponse.dart';
import 'package:pdam_app/models/user/user.dart';

import '../config/locator.dart';
import '../models/post/GetPostDtoResponse.dart';
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

  Future<dynamic> updateFullName(String fullName) async {
    String url = "/user/edit/fullName";

    var jsonResponse =
        await _client.put(url, EditModelFullName(fullName: fullName));
    return GetUserDto.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> updateUserName(String userName) async {
    String url = "/user/edit/userName";

    var jsonResponse =
        await _client.put(url, EditModelUserName(userName: userName));
    return GetUserDto.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> updatePhoneNumber(String phoneNumber) async {
    String url = "/user/edit/phoneNumber";

    var jsonResponse =
        await _client.put(url, EditModelPhoneNumber(phoneNumber: phoneNumber));
    return GetUserDto.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> updateProfileImg(XFile file) async {
    String url = "/user/upload";

    StreamedResponse response = await _client.postProfileImg(url, file);
    var stringResponse = await response.stream.bytesToString();
    return MultiPartFileRequest.fromJson(jsonDecode(stringResponse));
  }

  Future<dynamic> updateEmail(String email) async {
    String url = "/user/edit/email";

    var response = await _client.put(url, EditModelEmail(email: email));
    return GetUserDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> updatePasswords(
      String oldPassword, String newPassword, String newPasswordVerify) async {
    String url = "/user/edit/password";

    var response = await _client.put(
      url,
      EditModelPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordVerify: newPasswordVerify,
      ),
    );
    return GetUserDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> getUserByUserName(int it, String userName) async {
    String url = "/user/userName/$userName?page=$it";

    var response = await _client.get(url);
    return GetProfileDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> getUserFollows(String id, int it) async {
    String url = "/user/follows/$id?page=$it";

    var response = await _client.get(url);
    return FollowsAndFollowersResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> getUserFollowers(String id, int it) async {
    String url = "/user/followers/$id?page=$it";

    var response = await _client.get(url);
    return FollowsAndFollowersResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> getUserPaymentMethods() async {
    String url = "/payment/";

    var response = await _client.get(url);
    return PaymentMethodResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> newPaymentMethod(
      NewPaymentMethodDto newPaymentMethodDto) async {
    String url = "/payment/";

    var response = await _client.post(url, newPaymentMethodDto);
    return GetPaymentMethodDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> updateActiveMethod(int id) async {
    String url = "/payment/activate/$id";

    var response = await _client.put(url);
    return GetPaymentMethodDto.fromJson(jsonDecode(response));
  }

  Future<dynamic> getLikedPosts(String id, int it) async {
    String url = "/user/likedPosts/$id?page=$it";

    var response = await _client.get(url);
    return GetPostDtoResponse.fromJson(jsonDecode(response));
  }

  Future<dynamic> deleteAccount() async {
    await _client.delete("/user/delete");
  }
}
