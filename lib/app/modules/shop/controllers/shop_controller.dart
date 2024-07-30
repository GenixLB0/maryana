import 'dart:convert';
import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/model/test_model_response.dart' hide Brands;
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';
import 'package:flutter/material.dart';

class ShopController extends GetxController {
  RxList<Categories> categories = <Categories>[].obs;

  // Rx<Categories> currentCat = Categories().obs;

  RxList<ViewProductData> productsInCategories = <ViewProductData>[].obs;
  RxBool isCategoryLoading = false.obs;
  RxBool isProductLoading = false.obs;
  RxList<ViewProductData> products = <ViewProductData>[].obs;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  RxBool isProductsInCategoryLoading = false.obs;
  RxBool isBrandsLoading = false.obs;
  RxList<Brands> brands = <Brands>[].obs;
  String choosenCatId = "";
  ScrollController scrollController = ScrollController();
  RxBool showText = false.obs;
  RxBool showTextTop = false.obs;
  Rx<Categories> selectedCat = Categories().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getCategories();
    getProducts();

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  getCategories() async {
    print("searching 1");

    categories.clear();
    print('search api successful');
    isCategoryLoading.value = true;

    final response = await apiConsumer.post(
      'categories',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiCategoryResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('search data successful');

        for (var category in apiResponse.data!) {
          categories.add(category);
        }
        currentCatIndex.value = 1;
        selectedCat.value = categories.first;
        getBrandsInCategory(selectedCat.value.id!);
        getProductsInCategory(selectedCat.value.id!, "");
        update(["drawer_cats"]);
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
      isCategoryLoading.value = false;

      update();
    } catch (e, stackTrace) {
      print('search api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      isCategoryLoading.value = false;
      update();
    }
  }

  Rx<int> currentCatIndex = 0.obs;

  changeClickCurrentCat(
    int index,
  ) {
    currentCatIndex.value = index;
  }

  changeCurrentCat(bool swipeUp) {
    if (swipeUp) {
      print("yes swipe up");
      if (categories.length > currentCatIndex.value + 1) {
        currentCatIndex.value++;
      }

      changeClickCurrentCat(currentCatIndex.value);
      getBrandsInCategory(currentCatIndex.value + 1);
      getProductsInCategory(currentCatIndex.value + 1, "");
    } else {
      print("yes swipe down");
      if (categories.length > currentCatIndex.value - 1) {
        currentCatIndex.value = currentCatIndex.value - 1;
      }
      print("the real index = ${currentCatIndex.value}");
      changeClickCurrentCat(currentCatIndex.value);
      getBrandsInCategory(currentCatIndex.value + 1);
      getProductsInCategory(currentCatIndex.value + 1, "");
    }
  }

  getProducts() async {
    isProductLoading.value = true;
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var bodyFields = {};

    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );
    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        for (var product in responseData['data']) {
          products.add(ViewProductData.fromJson(product));
        }

        isProductLoading.value = false;
      } else {
        print(response.reasonPhrase);
        isProductLoading.value = false;
      }

      print("produc are ${products}");
    } catch (e, stackTrace) {
      isProductLoading.value = false;
      print('filter failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  int? selectedCatId;

  getProductsInCategory(int CatId, String? orderTag) async {
    orderTag = selectedOption;
    selectedCatId = CatId;
    isProductsInCategoryLoading.value = true;
    productsInCategories.clear();

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var bodyFields = {
      "category_ids[0]": "${CatId.toString()}",
      'orderBy': orderTag.isEmpty ? "featured" : orderTag
    };

    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print("response data ${responseData['data'].length}");
        for (var product in responseData['data']) {
          productsInCategories.add(ViewProductData.fromJson(product));
        }

        print("your result ${productsInCategories.first.id}");
        isProductsInCategoryLoading.value = false;
        handleScroll();
        return productsInCategories;
      } else {
        print(response.reasonPhrase);
        isProductsInCategoryLoading.value = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        return [];
      }
    } catch (e, stackTrace) {
      isProductsInCategoryLoading.value = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

  String selectedOption = 'featured'; // Ini
  changeDropDownValue(int? id, String option) {
    if (selectedCatId != null) {
      selectedOption = option;
      getProductsInCategory(id!, option);
      update(['products_in_categories']);
    } else {
      Get.snackbar("Pick A Category",
          "please pick a category first from the left side bar");
    }
  }

  getBrandsInCategory(int CatId) async {
    isBrandsLoading.value = true;
    brands.clear();
    var formData = dio.FormData.fromMap({
      'category_id': CatId,
    });
    final response = await apiConsumer.post('brands',
        formDataIsEnabled: true, formData: formData);

    try {
      final apiResponse = ApiBrandsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('brands data successful');

        for (var brand in apiResponse.data!.brands!) {
          brands.add(brand);
        }
        isBrandsLoading.value = false;
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        isBrandsLoading.value = false;
      }
    } catch (e, stackTrace) {
      print('Brands api failed:  $e $stackTrace');

      print(e.toString() + stackTrace.toString());
      isBrandsLoading.value = false;
    }
  }

  changeChoosenCat(Categories cat) {
    selectedCat.value = cat;
    print("changed id with 1 ${choosenCatId}");

    choosenCatId = cat.id.toString();
    print("changed id with 2 ${choosenCatId}");
  }

  handleScroll() {
    scrollController.addListener(() {
      print("start 11111");
      if (scrollController.position.atEdge) {
        final isTop = scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
          showTextTop.value = true;
          showText.value = false;
        } else {
          print('At the bottom');
          showText.value = true;
          showTextTop.value = false;
        }
      }
    });
  }

// changeCurrentCatOnSwipe() {
//   print("swipped");
//   changeCurrentCat(nextCat.value, currentCatIndex + 1, true);
//   getBrandsInCategory(nextCat.value.id!);
//   getProductsInCategory(nextCat.value.id!, "featured");
// }
//
// changeCurrentCatOnSwipeDown() {
//   print("swipped Down");
//   changeCurrentCat(nextCat.value, currentCatIndex - 1, false);
//   getBrandsInCategory(nextCat.value.id!);
//   getProductsInCategory(nextCat.value.id!, "featured");
// }
}
