import 'dart:ffi';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maryana/app/modules/product/controllers/product_controller.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'dart:convert';

import 'package:maryana/main.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import 'package:maryana/main.dart';

import '../../services/api_service.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var step = ''.obs;
  var total = ''.obs;
  var loading = true.obs;

  var shippingID = ''.obs;
  final box = GetStorage();
  RxBool isAuth = false.obs;

  @override
  void onInit() async {
    if (userToken == null) {
      isAuth.value = false;
    } else {
      super.onInit();

      bool cachedCart = await loadCartItems();
      if (!cachedCart) {
        print('retrived cart from api');
        fetchCartDetailsFromAPI();
      } else {
        //  fetchCartDetailsFromAPI(); // Fetch updated data in the background
      }
      print('Initialized');
    }
  }

  @override
  void onReady() async {
    super.onReady();

    print('teasdsad');

    print('Ready');
  }

  Future<void> fetchCartDetailsFromAPI() async {
    loading.value = true;
    try {
      final response = await apiConsumer.post('cart/details');

      if (response['status'] == 'success') {
        List<dynamic> items = response['data']['items'];
        total.value = response['data']['total'].toString();
        print(total.value.toString() + 'test total value');
        cartItems.assignAll(items.map((e) => CartItem.fromJson(e)).toList());
        saveCartItems();
        cartItems.refresh(); // Ensure the UI is updated

        loading.value = false;
        update();
      } else {
        print('Failed to fetch cart details: ${response['data']}');
        loading.value = false;
        update();
      }
    } catch (e) {
      print('Error fetching cart details: $e');
      loading.value = false;
      update();
    }
  }

  Future<void> checkoutApi() async {
    try {
      final response = await apiConsumer.post(
        'checkout',
        // body: {
        //   'shipping_id': shippingID.value,
        // },
      );

      if (response['status'] == 'success') {
        print('Checkout successful');
        clearCart();

        // Handle successful checkout logic here
      } else {
        print('Failed to checkout: ${response['data']}');
      }
    } catch (e) {
      print('Error during checkout: $e');
    }
  }

  Future<bool> loadCartItems() async {
    print('times');
    loading.value = true;

    // ignore: await_only_futures
    List<dynamic> storedItems =
        await box.read<List<dynamic>>('cartItems') ?? [];
    if (storedItems.isNotEmpty) {
      try {
        cartItems.assignAll(
            storedItems.map((e) => CartItem.fromJson(json.decode(e))).toList());
        print('cartItems cached retrived');
        loading.value = false;
        update();
        return true;
      } catch (e) {
        print('Error cartItems cached retrived');
        loading.value = false;
        update();
        return false;
      }
    } else {
      print('not found cartItems cached');
      loading.value = false;
      update();
      return false;
    }
  }

  void saveCartItems() {
    List<String> items = cartItems.map((e) => json.encode(e.toJson())).toList();
    try {
      box.write('cartItems', items);
    } catch (e, stackTrace) {
      print(e.toString() + ' test save items cached ' + stackTrace.toString());
      return;
    }
  }

  ProductController productController = ProductController();

  Future<void> addToCart(ViewProductData product, String size, String color,
      {int quantity = 1}) async {
    var existingItem =
        cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      cartItems.add(CartItem(
          product: product,
          selectedColor: color,
          selectedSize: productController.selectedSize.value,
          quantity: quantity));
    }
    cartItems.refresh(); // Ensure the UI is updated
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.post(
        'cart',
        body: {
          'product_id': product.id,
          'qty': quantity,
          'size': size,
          'color': color
        },
      );

      if (response['status'] == 'success') {
      } else {
        print('Failed to add to cart: ${response['data']}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeItem(CartItem item) async {
    cartItems.remove(item);
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.post(
        'cart/remove',
        body: {'id': item.product.id},
      );

      if (response['status'] == 'success') {
      } else {
        print('Failed to remove item: ${response['data']}');
      }
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    try {
      final response = await apiConsumer.post(
        'cart/update-qty',
        body: {'id': item.product.id, 'qty': quantity},
      );

      if (response['status'] == 'success') {
        item.quantity = quantity;
        cartItems.refresh(); // Ensure the UI is updated
        saveCartItems();
        update();
      } else {
        print('Failed to update quantity: ${response['data']}');
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.delete('cart');

      if (response['status'] == 'success') {
      } else {
        print('Failed to clear cart: ${response['data']}');
      }
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}

class CartItem {
  final ViewProductData product;
  int quantity;
  String? selectedSize;
  String? selectedColor;

  CartItem(
      {required this.product,
      this.quantity = 1,
      required this.selectedSize,
      required this.selectedColor});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ViewProductData.fromJson(json['product']),
      quantity: json['quantity'],
      selectedSize: json['size'] ?? 'L',
      selectedColor: json['color'] ?? 'Red',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': selectedSize,
      'color': selectedColor,
    };
  }
}
