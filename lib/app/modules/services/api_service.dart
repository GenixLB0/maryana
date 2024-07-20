import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/controller/controller.dart';

GlobalController globalController = GlobalController();
String? userToken;
void handleApiError(int? statusCode) {
  globalController.errorMessage.value =
      errorMessages[statusCode] ?? 'Unexpected error occurred';
}

const Map<int, String> errorMessages = {
  400: '400 Invalid data provided',
  401: '401 Unauthorized . Please check your credentials',
  403: '403 You don\'t have permission to access this resource.',
  404: '404  not found. Please check the endpoint.',
  500: '500 Server error, please try again later',
};

void handleApiErrorUser(String? message) {
  String displayMessage;
  if (message == 'Invalid Credentials') {
    displayMessage = 'Password or email is incorrect';
  } else if (message == 'Invalid Credintials.') {
    displayMessage = 'Current Password is incorrect';
  } else {
    displayMessage = message ?? 'An unexpected error occurred';
  }

  Get.snackbar(
    'Error',
    displayMessage,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.withOpacity(0.9),
    colorText: Colors.white,
    icon: Icon(
      Icons.error,
      color: Colors.white,
      size: 25.sp,
    ),
    shouldIconPulse: true,
    barBlur: 20,
    isDismissible: true,
    duration: Duration(seconds: 1),
    snackStyle: SnackStyle.FLOATING,
    margin: EdgeInsets.all(15),
    borderRadius: 10,
  );
}

class ApiService extends GetxService {
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: BASE_URL,
      headers: {
        if (userToken != null) 'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Future<dio.Response> request({
  //   required String endpoint,
  //   required String method,
  //   Map<String, dynamic>? data,
  // }) async {
  //   try {
  //     if (method == 'GET') {
  //       return await _dio.get(endpoint);
  //     } else if (method == 'POST') {
  //       logWithColor(endpoint, color: 'yallow');

  //       logWithColor(' POST Request : $data', color: 'yallow');
  //       return await _dio.post(endpoint, data: data);
  //     } else {
  //       throw UnsupportedError('Method not supported');
  //     }
  //   } on dio.DioException catch (e) {
  //     if (e.response != null) {
  //       logWithColor('${e.response!.statusCode} Response: ${e.response}',
  //           color: e.response!.statusCode == 200 ? 'green' : 'red');
  //       handleApiError(e.response!.statusCode);
  //       return e.response!;
  //     } else {
  //       logWithColor('Response: ${e.response}', color: 'red');
  //       handleApiError(500);
  //       return dio.Response(
  //         requestOptions: e.requestOptions,
  //         statusCode: 500,
  //         statusMessage: 'Unexpected error occurred',
  //       );
  //     }
  //   } catch (e) {
  //     return dio.Response(
  //       requestOptions: dio.RequestOptions(path: endpoint),
  //       statusCode: 500,
  //       statusMessage: 'Unexpected error occurred',
  //     );
  //   }
  // }

  void logWithColor(String message, {String color = 'reset'}) {
    final colors = {
      'red': '\x1B[31m',
      'green': '\x1B[32m',
      'yellow': '\x1B[33m',
      'blue': '\x1B[34m',
      'magenta': '\x1B[35m',
      'cyan': '\x1B[36m',
      'reset': '\x1B[0m',
    };
    print('${colors[color]}$message${colors['reset']}');
  }

  void updateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
