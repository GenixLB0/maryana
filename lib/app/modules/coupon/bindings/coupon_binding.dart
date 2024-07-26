import 'package:get/get.dart';
import 'package:maryana/app/modules/coupon/controllers/coupon_controller.dart';
 
class CouponBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CouponController>(() => CouponController());
  }
}
