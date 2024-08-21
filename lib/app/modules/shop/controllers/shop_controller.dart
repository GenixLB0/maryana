import 'dart:convert';
import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/model/test_model_response.dart' hide Brands;
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';

class ShopController extends GetxController {
  RxList<Categories> categories = <Categories>[].obs;
  RxList<Categories> subCategories = <Categories>[].obs;
  RxBool isCategoryLoading = false.obs;
  RxBool isProductLoading = false.obs;
  RxList<ViewProductData> products = <ViewProductData>[].obs;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  RxBool isSubCategoriesLoading = false.obs;
  RxBool isBrandsLoading = false.obs;
  RxList<Brands> brands = <Brands>[].obs;
  RxString choosenCatId = "".obs;
  RxString choosenCatName = "".obs;

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
        ;
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

  getSubCategoriesInCategory(int CatId) async {
    isSubCategoriesLoading.value = true;
    subCategories.clear();
    var formData = dio.FormData.fromMap({
      'parent_id': CatId,
    });
    final response = await apiConsumer.post('categories',
        formDataIsEnabled: true, formData: formData);

    try {
      final apiResponse = ApiCategoryResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('');

        for (var category in apiResponse.data!) {
          subCategories.add(category);
        }

        if (subCategories.isNotEmpty) {
          subCategories.insert(0, Categories());
        }

        isSubCategoriesLoading.value = false;
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        isSubCategoriesLoading.value = false;
      }
    } catch (e, stackTrace) {
      print('subCat api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      isSubCategoriesLoading.value = false;
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

  changeChoosenCatId(id, name) {
    print("changed id with 1 ${choosenCatId}");

    choosenCatId.value = id;
    choosenCatName.value = name;
    print("changed id with 2 ${choosenCatId}");
  }
}
