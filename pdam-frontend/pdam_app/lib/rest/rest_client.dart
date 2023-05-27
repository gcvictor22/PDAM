import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:pdam_app/models/login.dart';
import 'package:pdam_app/services/localstorage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = "http://localhost:8080";
}

class HeadersApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
      data.headers["Accept"] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}

@Order(-10)
@singleton
class RestClient {
  var _httpClient;

  RestClient() {
    _httpClient =
        InterceptedClient.build(interceptors: [HeadersApiInterceptor()]);
  }

  RestClient.withInterceptors(List<InterceptorContract> interceptors) {
    // El interceptor con los encabezados sobre JSON se añade si no está incluido en la lista
    if (interceptors
        .where((element) => element is HeadersApiInterceptor)
        .isEmpty) interceptors..add(HeadersApiInterceptor());
    _httpClient = InterceptedClient.build(interceptors: interceptors);
  }

  //final _httpClient = http.Client();

  Future<dynamic> get(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.get(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw FetchDataException('No internet connection: ${ex.message}');
    }
  }

  Future<dynamic> post(String url, [dynamic body]) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.post(uri, body: jsonEncode(body));
      var responseJson = _response(response);
      return responseJson;

      /*} on SocketException catch(ex) {
      throw FetchDataException('No internet connection: ${ex.message}');
    }*/
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<dynamic> postMultipart(String url, List<XFile> files) async {
    late LocalStorageService _localStorageService;
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.baseUrl + url),
    );

    for (final file in files) {
      final bytes = await file.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'files',
        bytes,
        filename: file.name.substring(1, 10),
      ));
    }

    final headers = {
      'Authorization':
          'Bearer ${_localStorageService.getFromDisk("user_token")}'
    };
    request.headers.addAll(headers);

    try {
      final response = await request.send();
      return response;
    } catch (error) {
      throw new Exception("Error en el cliente");
    }
  }

  Future<dynamic> postProfileImg(String url, XFile file) async {
    late LocalStorageService _localStorageService;
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.baseUrl + url),
    );

    final bytes = await file.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: file.name,
    ));

    final headers = {
      'Authorization':
          'Bearer ${_localStorageService.getFromDisk("user_token")}'
    };
    request.headers.addAll(headers);

    try {
      final response = await request.send();
      return response;
    } catch (error) {
      throw new Exception("Error en el cliente");
    }
  }

  Future<dynamic> put(String url, [dynamic body]) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);
      final response = await _httpClient.put(uri, body: jsonEncode(body));
      var responseJson = _response(response);
      return responseJson;
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);
      final response = await _httpClient.delete(uri);
      var responseJson = _response(response);
      return responseJson;
    } on Exception catch (ex) {
      throw ex;
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 204:
        return;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
        // Así sacamos el mensaje del JSON devuelto por el API
        //String message = jsonDecode(utf8.decode(response.bodyBytes))['message'];
        //throw AuthenticationException(message);

        // Así devolvemos un mensaje "genérico"
        throw AuthenticationException(
            "You have entered an invalid username or password");
      case 403:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 404:
        return NotFoundException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: annotate_overrides

class CustomException implements Exception {
  final message;
  final _prefix;

  CustomException([this.message, this._prefix]);

  String toString() {
    return "$_prefix$message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class AuthenticationException extends CustomException {
  AuthenticationException([message]) : super(message, "");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "");
}

class AuthorizationInterceptor implements InterceptorContract {
  late LocalStorageService _localStorageService;

  AuthorizationInterceptor() {
    //_localStorageService = getIt<LocalStorageService>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      var token = await _localStorageService.getFromDisk("user_token");
      data.headers["Authorization"] = "Bearer " + token;
    } catch (e) {
      print(e);
    }

    return Future.value(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401 || data.statusCode == 403) {
      var refreshToken = _localStorageService.getFromDisk("user_refresh_token");
      final response = await http.post(
          Uri.parse(ApiConstants.baseUrl + "/user/refreshtoken"),
          body: jsonEncode({"refreshToken": refreshToken}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          });
      if (response.statusCode == 201) {
        LoginResponse loginResponse =
            LoginResponse.fromJson(jsonDecode(response.body));

        await _localStorageService.saveToDisk(
            "user_token", loginResponse.token);
        await _localStorageService.saveToDisk(
            "user_refresh_token", loginResponse.refreshToken);

        var request = data.request;
        request!.headers["Authorization"] =
            "Bearer " + _localStorageService.getFromDisk("user_token");
        var retryResponseStream = await request.toHttpRequest().send();
        var retryResponse = await http.Response.fromStream(retryResponseStream);
        var datos = ResponseData.fromHttpResponse(retryResponse);
        return Future.value(datos);
      }
    }
    return Future.value(data);
  }
}

@Order(-10)
@singleton
class RestAuthenticatedClient extends RestClient {
  RestAuthenticatedClient()
      : super.withInterceptors(
            List.of(<InterceptorContract>[AuthorizationInterceptor()]));
}
