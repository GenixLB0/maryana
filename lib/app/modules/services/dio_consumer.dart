import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as gets;
import 'package:get/get_core/src/get_main.dart';
import 'package:maryana/app/modules/auth/controllers/auth_controller.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/log_utils.dart';
import 'package:maryana/app/modules/profile/controllers/profile_controller.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/services/error/exceptions.dart';
import 'package:maryana/main.dart';

import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'status_code.dart';

final ProfileController controller = gets.Get.put(ProfileController());

class DioConsumer implements ApiConsumer {
  final Dio client;

  DioConsumer({required this.client}) {
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Map<String, String> header = {
      HttpHeaders.acceptHeader: 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'x-guest': '****',
    };

    client.options
      ..baseUrl = BASE_URL
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..contentType = 'application/json'
      ..headers = header;

    client.interceptors.add(sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(sl<LogInterceptor>());
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      if (userToken != null) {
        client.options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $userToken';
      }
      client.options.headers[HttpHeaders.acceptLanguageHeader] = 'en';

      final response = await client.get(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw Exception();
    }
  }

  AuthController authController = Get.put(AuthController());
  @override
  Future post(String path,
      {Map<String, dynamic>? body,
      FormData? formData,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      if (userToken != null) {
        client.options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $userToken';
      }
      client.options.headers[HttpHeaders.acceptLanguageHeader] = 'en';

      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? formData : body);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw Exception();
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    if (userToken != null) {
      client.options.headers[HttpHeaders.authorizationHeader] =
          'Bearer $userToken';
    }
    client.options.headers[HttpHeaders.acceptLanguageHeader] = 'en';

    try {
      final response =
          await client.put(path, queryParameters: queryParameters, data: body);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      if (userToken != null) {
        client.options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $userToken';
      }
      client.options.headers[HttpHeaders.acceptLanguageHeader] = 'en';

      final response =
          await client.delete(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw Exception();
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    final responseJson = jsonDecode(response.data.toString());
    return responseJson;
  }

  dynamic _handleDioError(DioError error) {
    Log.e(error.toString());
    switch (error.type) {
      case DioErrorType.connectTimeout:
        throw const InternalServerErrorException();
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw const FetchDataException();
      case DioErrorType.response:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
            userToken = null;
            authController.user.value = null;
            Get.snackbar("Unauthorized", "Session Expired");
            return const BadRequestException();
          case StatusCode.forbidden:
            throw UnauthorizedException(error.response?.toString());

          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.confilct:
            throw UnauthorizedException(error.response?.toString());
          case StatusCode.unProcessableContent:
            throw UnauthorizedException(error.response?.toString());
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
          default:
            throw const InternalServerErrorException();
        }
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw const NoInternetConnectionException(
            'NoInternetConnectionException');
    }
  }

  @override
  Future patch(String path, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) async {
    try {
      if (userToken != null) {
        client.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer $userToken';
      }
      client.options.headers[HttpHeaders.acceptLanguageHeader] = 'en';

      final response =
          await client.patch(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioError catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw Exception();
    }
  }
}
