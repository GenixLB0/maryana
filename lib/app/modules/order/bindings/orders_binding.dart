// lib/app/modules/order/bindings/orders_binding.dart

import 'package:get/get.dart';
import 'package:maryana/app/modules/order/controllers/orders_controller.dart';
 
class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
