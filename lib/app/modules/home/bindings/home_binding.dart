import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    print("home binding started...");
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
