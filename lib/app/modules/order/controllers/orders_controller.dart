// lib/app/modules/order/controllers/orders_controller.dart

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/main.dart';

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var loading = true.obs;
  var selectedStatus = 'pending'.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;

    // fetchOrders();
    fetchOrdersTest('pending');
  }

  void fetchOrders() async {
    loading.value = true;
    try {
      final response = await apiConsumer.post(
        'orders',
        body: {'status': selectedStatus.value},
      );

      if (response['status'] == 'success') {
        List<dynamic> data = response['data']['orders'];
        orders.assignAll(data.map((e) => Order.fromJson(e)).toList());
      } else {
        print('Failed to fetch orders: ${response['data']}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      loading.value = false;
    }
  }

  void fetchOrdersTest(status) async {
    loading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    orders.assignAll([
      Order(
        id: 1524,
        trackingNumber: 'IK287368838',
        quantity: 2,
        subtotal: 110.0,
        status: status,
        date: '15/05/2024',
      ),
      // Add more mock orders as needed
    ]);
    loading.value = false;
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    fetchOrdersTest(status);
    //fetchOrders();
  }
}
