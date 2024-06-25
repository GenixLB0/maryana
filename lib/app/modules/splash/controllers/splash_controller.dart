import 'dart:convert';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main/views/main_view.dart';
import '../../onboarding/views/onboarding_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('testsssss $userToken');
  }

  void navigateToOnboarding() {
    Get.off(() => OnboardingView());
  }
}
