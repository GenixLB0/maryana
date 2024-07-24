import 'package:get/get.dart';

import '../controllers/gift_card_controller.dart';

class GiftCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiftCardController>(
      () => GiftCardController(),
    );
  }
}
