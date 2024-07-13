import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';

import '../../../../main.dart';
import '../../services/api_consumer.dart';

class ProductController extends GetxController {
// Rx<Product>? product = Product().obs;
  RxBool isProductLoading = false.obs;
  RxBool isAddToCartActive = false.obs;
  RxList<Attachments> productImages = <Attachments>[].obs;

  // Rx<int> currentStock = 0.obs;

  Rx<int> imageIndex = 0.obs;
  ViewProductData? product;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  final isShowDescription = true.obs;
  final isShowReviews = true.obs;

  List<String> sizeList = <String>[].obs;
  RxList<ProductColor> colorList = <ProductColor>[].obs;

  Rx<String> selectedSize = "S".obs;

  Rx<ProductColor> selectedColor = ProductColor(name: "", id: 0, hex: "").obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    // product?.value = Get.arguments as Product;
    // print("product module is ${product!.value.image!}");
  }

  @override
  void onClose() {
    super.onClose();
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
    print("setting...");
    selectedSize.value = customSize;
  }

  setColor(customColor) {
    selectedColor.value = customColor;
  }

  getProductSizesAndColors(id) async {
    colorList.clear();
    sizeList.clear();
    productImages.clear();
    isProductLoading.value = true;

    var result = await apiConsumer.post("products/${id}").then((value) {
      try {
        print("the real value is ${value}");
        var _resultProduct = ViewProductData.fromJson(value['data']);
        product = _resultProduct;
        print("the value is ${value.runtimeType}");
        print("the product is ${_resultProduct.sizes}");

        print("stop 00");
        //adding attachments
        for (var attachment in _resultProduct.attachments!) {
          if (attachment.name == "app_show") {
            productImages.addNonNull(attachment);
          }
        }
        print("stop 1");
        //adding attributes
        for (var size in _resultProduct.sizes!) {
          print("stop 2");
          sizeList.addNonNull(size);
        }
        print("stop 3");
        // //get Current Stock
        // for (var attribute in attributes) {
        //   if (attribute.size == selectedSize.value) {
        //     currentStock.value = attribute.stock!;
        //   }
        // }

        //adding colors
        for (var color in _resultProduct.colors!) {
          colorList.addNonNull(color);
        }

        print("sized are  ${sizeList}");
        print("color are  ${colorList}");
        selectedColor!.value = colorList[0];

        isProductLoading.value = false;
      } catch (e) {
        isProductLoading.value = false;
        print("exception here ${e.toString()}");
      }
    });
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
