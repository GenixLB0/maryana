import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';

import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../services/api_consumer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;

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
  final isShowReviews = false.obs;
  List<String> sizeList = [];
  Rx<String> selectedSize = "".obs;

  Rx<String> selectedColor = "".obs;
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

  Rx<String> placeHolderImg = "".obs;

  @override
  void onReady() {
    isFirstTimeGettingReviews = true;
    print('tesadasw5');
    ViewProductData comingProduct = Get.arguments as ViewProductData;
    if (Get.arguments != null && Get.arguments is ViewProductData) {
      var myProduct = Get.arguments as ViewProductData;
      placeHolderImg.value = myProduct.image!;
      print("new product name 2 ${myProduct.name} ");
      getProduct(myProduct.id);

      if (colorsList.isNotEmpty) {
        setColor(colorsList.first.name);
      }
    } else {
      // Handle the case where no valid arguments are passed
      // You can navigate back or show an error message
      Get.back();
      Get.closeCurrentSnackbar();
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
    if (isShowReviews.value) {
      getProductReviews();
    }
  }

  List<ReviewsModel> reviews = [];
  bool isFirstTimeGettingReviews = false;
  bool isReviewsLoading = false;

  getProductReviews() async {
    print("start getting review 11");

    if (isFirstTimeGettingReviews == true) {
      print("start getting review 2");
      isReviewsLoading = false;
      print("review value is 1 ${isReviewsLoading}");
      update(['reviews']);
      var result = await apiConsumer.post(
        "products/ratings/${product.value.id!}",
      );

      if (result['status'] == "success") {
        for (var review in result['data']) {
          reviews.addNonNull(ReviewsModel.fromJson(review));
        }
        isFirstTimeGettingReviews = false;
        isReviewsLoading = false;
        update(['reviews']);
      } else {
        update(['reviews']);
      }
    } else {
      print("start getting review 3");
    }
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
      getRelatedProducts(product.value.category!.id);
    } catch (e, stackTrace) {
      print(stackTrace.toString() + ' product test error' + '${e.toString()}');
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

  List<ViewProductData> relatedProducts = <ViewProductData>[];
  bool isRelatedProductsLoading = false;
  List<ViewProductData> finalRelatedProducts = <ViewProductData>[];

  void getRelatedProducts(int? id) async {
    relatedProducts.clear();
    isRelatedProductsLoading = true;
    update(['related-products']);
    print("should called once...");

    print("your coming cat id is ${id}");
    var formData = dio.FormData.fromMap(
        {'per_page': '4', 'category_ids[0]': id.toString()});
    var response = await apiConsumer.post("products",
        formDataIsEnabled: true, formData: formData);

    try {
      if (response['data'] != null) {
        for (var product in response['data']) {
          print("rach pro is ${product}");
          relatedProducts.add(ViewProductData.fromJson(product));
        }

        if (relatedProducts.isNotEmpty) {
          for (var myProduct in relatedProducts) {
            print("rounding....");
            if (myProduct.id != product.value.id) {
              print("firts id 1 ${myProduct.id}");
              print("firts id 2 ${product.value.id}");
              print("is it result ${myProduct.id == product.value.id}");
              finalRelatedProducts.add(myProduct);
            }
          }

          update(['related-products']);
        } else {
          print("sorry it's empty");
        }

        isRelatedProductsLoading = false;
        print("should called once... 2 ${response['data']} ");
        print("products related are ${relatedProducts}");
        update(['related-products']);
      } else {
        print(response.reasonPhrase);
        isRelatedProductsLoading = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        update(['related-products']);
      }
    } catch (e, stackTrace) {
      isRelatedProductsLoading = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      update(['related-products']);
    }
  }
}
