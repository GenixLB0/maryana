import 'package:get/get.dart';
import 'package:maryana/app/modules/main/controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    print("Main binding started...");
    Get.lazyPut<MainController>(
      () => MainController(),
    );
  }
}
