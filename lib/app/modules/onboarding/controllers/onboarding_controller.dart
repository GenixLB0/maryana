import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
// import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../main.dart';
import '../../auth/views/login_view.dart';
import '../../global/model/model_response.dart';

class OnboardingController extends GetxController {
  RxInt currentIndex = 0.obs;
  final count = 0.obs;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.easeOut;
  PageController pageController = PageController();

  nextFunction() {
    print("current index is ${currentIndex.value}");
    if(currentIndex.value == splashes.length -1 ){
      Get.off(LoginView());
      return;
    }
    pageController.nextPage(duration: _kDuration, curve: _kCurve);
    currentIndex++;
  }

  previousFunction() {
    pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  @override
  void onInit() {
    print("init controller");
    getOnBoardingData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  startNavigation() {
    Future.delayed(Duration(milliseconds: 3000), () {
      // Get.off(OnboardingScreen1View());
    });
  }

  changeIndexValue(index) {
    currentIndex.value = index++;
    print('comming value is ${index++}');
    print('current value is ${currentIndex}');
    update();
  }

  increaseIndexValue() {
    currentIndex.value++;
    print('current value is ${currentIndex}');
    update();
  }

 RxBool isOnBoardingLoading = false.obs;
  RxList<Splash> splashes = <Splash>[].obs;
  getOnBoardingData() async{
    isOnBoardingLoading.value = true;
    splashes.clear();
    print('onBoarding api started ....');
try{
  final response = await apiConsumer.get(
    'splashes',
  );


if(response['status'] == 'success'){
  isOnBoardingLoading.value = false;
  OnBoardingData result = OnBoardingData.fromJson(response);
  for(var splash in result.data!.splashes){
    splashes.add(splash);
  }
  print('onBoarding api successful ${splashes.length}');
}else{
  print("error getting splashes }");
}

}catch(e){

  print('onBoarding api failed $e');

}

  }
}
