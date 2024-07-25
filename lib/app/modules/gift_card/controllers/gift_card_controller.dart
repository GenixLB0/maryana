import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GiftCardController extends GetxController {
  //TODO: Implement GiftCardController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

// String selectedOption = 'featured'; // Ini
// changeDropDownValue(int? id, String option) {
//   if (selectedCatId != null) {
//     selectedOption = option;
//     getProductsInCategory(id!, option);
//     update(['products_in_categories']);
//   } else {
//     Get.snackbar("Pick A Category",
//         "please pick a category first from the left side bar");
//   }
// }
}
