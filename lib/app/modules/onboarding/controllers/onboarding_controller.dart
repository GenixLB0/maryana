import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt currentIndex = 0.obs;
  final count = 0.obs;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.easeOut;

  FadingPageViewController pageController = FadingPageViewController();

  nextFunction() {
    pageController.next();
  }

  previousFunction() {
    pageController.previous();
  }

  @override
  void onInit() {
    print("init controller");
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
    currentIndex.value = index;
    print('comming value is ${index}');
    print('current value is ${currentIndex}');
    update();
  }

  increaseIndexValue() {
    currentIndex.value++;
    print('current value is ${currentIndex}');
    update();
  }
}
