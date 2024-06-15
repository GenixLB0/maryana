import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print("splash binding started...");
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
