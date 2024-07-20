import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    print("onboadring binding started...");

    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
  }
}
