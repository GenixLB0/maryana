import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';

import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../services/api_consumer.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
// Rx<Product>? product = Product().obs;
  RxBool isProductLoading = false.obs;
  RxBool isAddToCartActive = false.obs;
  List<Attachments> productImages = [];

  // Rx<int> currentStock = 0.obs;
  List<ColorData> colorsList = [];
  Rx<int> imageIndex = 0.obs;
  Rx<ViewProductData> product = ViewProductData().obs;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  final isShowDescription = true.obs;
  final isShowReviews = true.obs;
  List<String> sizeList = [];
  Rx<String> selectedSize = "S".obs;

  Rx<String> selectedColor = "0xffcc00cc".obs;
  Rx<SizeGuide> productSizeGuide = SizeGuide().obs;

  @override
  void onInit() {
    super.onInit();
    print('tesadasw5');

    // if (Get.arguments != null && Get.arguments is ViewProductData) {
    //   product = Get.arguments as ViewProductData;
    // } else {
    //   // Handle the case where no valid arguments are passed
    //   // You can navigate back or show an error message
    //   Get.back();
    //   Get.snackbar('Error', 'No product data available');
    // }
  }

  @override
  void onReady() {
    print('tesadasw5');
    ViewProductData comingProduct = Get.arguments as ViewProductData;
    if (Get.arguments != null && Get.arguments is ViewProductData) {
      var myProduct = Get.arguments as ViewProductData;
      getProduct(myProduct.id);
      if (colorsList.isNotEmpty) {
        setColor(colorsList.first.name);
      }
    } else {
      // Handle the case where no valid arguments are passed
      // You can navigate back or show an error message
      Get.back();
      Get.snackbar('Error', 'No product data available');
    }

    super.onReady();
    // product?.value = Get.arguments as Product;
    // print("product module is ${product!.value.image!}");
  }

  @override
  void onClose() {
    super.onClose();
    print('tesadas');
  }

  void increment() => count.value++;

  switchShowDescription() {
    isShowDescription.value = !isShowDescription.value;
    print("desc is ${isShowDescription.value}");
  }

  switchShowReviews() {
    isShowReviews.value = !isShowReviews.value;
    print("desc is ${isShowReviews.value}");
  }

  setSize(customSize) {
    selectedSize.value = customSize;
    for (var size in sizeList) {
      if (size == selectedSize.value) {}
    }
    update();
  }

  setColor(customColor) {
    selectedColor.value = customColor;
    for (var color in colorsList) {
      if (color == selectedColor.value) {}
    }
    update();
    selectedColor.value = customColor;
  }

  getProduct(id) async {
    productImages.clear();
    colorsList.clear();
    sizeList.clear();
    productSizeGuide.value = SizeGuide();
    isProductLoading.value = true;
    try {
      final response = await apiConsumer.post(
        'products/$id',
      );

      product.value = ViewProduct.fromJson(response).data!;
      print("the value is ${product.runtimeType}");
      print("the product is ${product.value.name}");

      //adding attachments
      for (var attachment in product.value.attachments!) {
        if (attachment.name == "app_show") {
          productImages.addNonNull(attachment);
        }
      }
      print('test images with app show are ${productImages}');
      //adding attributes
      for (var size in product.value.sizes!) {
        sizeList.addNonNull(size);
        print(size.toString() + 'test sizesss');
      }

      //adding colors
      for (var color in product.value.colors!) {
        colorsList.addNonNull(color);
      }

      //adding Size Guide

      if (product.value.sizeGuide?.fitType != null) {
        print("the value is not null and adding ");
        productSizeGuide.value = product.value.sizeGuide!;
      }
      print("your size guide is ${product.value.sizeGuide}");

      print("attachments are  ${productImages}");
      print("color are  ${colorsList}");

      isProductLoading.value = false;
      update();
    } catch (e, stackTrace) {
      print(stackTrace.toString() + ' test error');
      isProductLoading.value = false;
    }
  }

  changeIndex() {
    int checkIndex = imageIndex.value + 1;
    if (checkIndex < productImages.length) {
      imageIndex.value = checkIndex;
    }

    print("cur index is ${imageIndex.value}");
  }

  minusIndex() {
    int checkIndex = imageIndex.value - 1;
    if (checkIndex >= 0) {
      imageIndex.value = checkIndex;
    }

    print("cur index is ${imageIndex.value}");
  }

  setIndex() {
    imageIndex.value = 0;
  }

  changeAddToCartStatus() {
    isAddToCartActive.value = true;
    Future.delayed(Duration(milliseconds: 1900), () {
      isAddToCartActive.value = false;
    });
  }
}
