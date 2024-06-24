import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../global/config/constant.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart';
import '../../services/api_consumer.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();
  Rx<TestData> homeModel = TestData().obs;

  RxBool isHomeLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getHomeApi();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  getHomeApi() async {
    isHomeLoading.value = true;
    print('home api successful');

    final response = await apiConsumer.get(
      'homepage',
    );

    try {
      final apiResponse = CustomHomeModel.fromJson(response);
      if (apiResponse.status == 'success') {
        print('home data successful');
        isHomeLoading.value = false;
        homeModel.value = apiResponse.data!;
        List<String> banners = [];
        print("the type is ${homeModel.value.banners.runtimeType}");

        // Handle successful home data
        // await _cacheUser(apiResponse.data!);
        // AppConstants.userData = apiResponse.data!;

        print("the categories are ${apiResponse.data!.categories}");
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print('Registration failed: ${response.statusMessage}');
      }
      // isLoading.value = false;
    } catch (e, stackTrace) {
      isHomeLoading.value = false;
      // isLoading.value = false;
      print('home api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  Future<void> _cacheUser(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('total_points', data.toJson().toString());
    print('User data cached: ${data.toJson()}');
  }

  setCats() {
    homeModel.value.categories!.toSet().toList();
    print("the setted cats are ${homeModel.value.categories!}");
    update();
  }
}
