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
  List<Attachments> productImages = [];

  // Rx<int> currentStock = 0.obs;
  List<String> colorsList = [];
  Rx<int> imageIndex = 0.obs;
  ViewProductData? product;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  final isShowDescription = true.obs;
  final isShowReviews = true.obs;
  List<String> sizeList = [];
  Rx<String> selectedSize = "S".obs;

  Rx<String> selectedColor = "0xffcc00cc".obs;

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
    isProductLoading.value = true;

    await apiConsumer.post("products/${id}").then((value) {
      try {
        product = ViewProductData.fromJson(value);

        print("the value is ${value.runtimeType}");
        print("the product is ${product!.name}");

        //adding attachments
        for (var attachment in product!.attachments!) {
          if (attachment.name == "app_show") {
            productImages.addNonNull(attachment);
          }
        }

        //adding attributes
        for (var size in product!.sizes!) {
          sizeList.addNonNull(size);
        }

        // //get Current Stock
        // for (var attribute in attributes) {
        //   if (attribute.size == selectedSize.value) {
        //     currentStock.value = attribute.stock!;
        //   }
        // }

        //adding colors
        for (var color in product!.colors!) {
          colorsList.addNonNull(color);
        }
        update();
        print("attachments are  ${productImages}");
        print("color are  ${colorsList}");

        isProductLoading.value = false;
      } catch (e) {
        isProductLoading.value = false;
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
