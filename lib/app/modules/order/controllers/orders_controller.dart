// lib/app/modules/order/controllers/orders_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/main.dart';

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var loading = true.obs;
  var singelLoading = true.obs;
  var selectedStatus = 'pending'.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;

    fetchOrders();
    // fetchOrdersTest('pending');
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
    } catch (e, stackTrace) {
      print('Error fetching orders: $e $stackTrace');
    } finally {
      loading.value = false;
    }
  }

  var singelOrder =
      Rx<Order?>(null); // Observable that holds a single Order or null

  Future<Order?> fetchSingelOrder(String code) async {
    singelLoading.value = true;
    try {
      final response = await apiConsumer.get('orders/$code');

      if (response['status'] == 'success') {
        final data = response['data'];
        print('Succeeded in fetching the order');

        // Assign the fetched Order to singelOrder
        singelOrder.value = Order.fromJson(data);
        singelLoading.value = false;
        //update();
        return singelOrder.value; // Return the Order object
      } else {
        print('Failed to fetch order: ${response['data']}');
      }
    } catch (e, stackTrace) {
      singelLoading.value = false;
      //  update();

      print('Error fetching order: $e $stackTrace');
    } finally {
      singelLoading.value = false;
    }

    return null; // Return null if fetching failed
  }

  int productId = 0;
  var isloadingAddReview = false.obs;
  Future<void> submitRating(
      int productId, double rating, String comment) async {
    isloadingAddReview.value = true;
    try {
      final response = await apiConsumer.post(
        '/orders/rate',
        body: {
          'product_id': productId,
          'rating': rating,
          'title': 'Review Product',
          'comment': comment,
        },
      );
      isloadingAddReview.value = false;
    } catch (e) {
      isloadingAddReview.value = false;
    }
  }

  void fetchOrdersTest(status) async {
    loading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    // orders.assignAll([
    //   Order(
    //     id: 1524,
    //     trackingNumber: 'IK287368838',
    //     quantity: 2,
    //     subtotal: 110.0,
    //     status: status,
    //     date: '15/05/2024',
    //   ),
    //   // Add more mock orders as needed
    // ]);
    loading.value = false;
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    // fetchOrdersTest(status);
    fetchOrders();
  }
}
