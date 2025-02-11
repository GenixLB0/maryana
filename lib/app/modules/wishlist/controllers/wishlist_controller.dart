import 'dart:convert';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';

import '../../home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;

import '../../services/api_service.dart';

class WishlistController extends GetxController {
  //TODO: Implement WishlistController

  final count = 0.obs;
  final resultCount = 0.obs;
  final List<ViewProductData> resultSearchProducts = <ViewProductData>[].obs;
  RxBool isWishlistLoading = false.obs;
  RxBool isAuth = false.obs;

  @override
  void onInit() {
    if (userToken == null) {
      isAuth.value = false;
    } else {
      isAuth.value = true;
    }

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

  setInitData(List<int> wishlistProductIds) async {
    List<String> _product_ids = [];
    resultCount.value = wishlistProductIds.length;
    for (var id in wishlistProductIds) {
      _product_ids.addNonNull(id.toString());
    }
    print("the ids are ${_product_ids}");

    // String _product_ids_inString = _product_ids.join(",");
    await getProductsInSection(_product_ids);
  }

  Future<List<dynamic>> getProductsInSection(List<String> product_ids) async {
    int _index = 0;
    resultSearchProducts.clear();
    isWishlistLoading.value = true;

    print("getting started...");

    final Map<dynamic, dynamic> bodyFields = {};

    product_ids.forEach((id) {
      bodyFields["ids[${_index}]"] = id;
      _index++;
    });

    print("the body is ${bodyFields}");
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://panel.mariannella.com/api/products'),
      headers: headers,
      body: bodyFields,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        for (var product in responseData['data']) {
          resultSearchProducts.add(ViewProductData.fromJson(product));
        }
        resultCount.value = resultSearchProducts.length;
        isWishlistLoading.value = false;
        print("your result length ${resultSearchProducts.length}");

        return resultSearchProducts;
      } else {
        print(response.reasonPhrase);
        isWishlistLoading.value = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        return [];
      }
    } catch (e, stackTrace) {
      isWishlistLoading.value = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

  removeFromGrid(id) {
    resultSearchProducts.removeWhere((product) => product.id! == id);

  }

  addToGrid(id) async {
    await getProductWithId(id);
    if (productData != null) {
      resultSearchProducts.add(productData!);
    }
    print("getting grid after added ${resultSearchProducts.length}");
  }

  ViewProductData? productData;

  getProductWithId(id) async {
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://panel.mariannella.com/api/products/${id}'),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        productData = ViewProductData.fromJson(responseData['data']);

        return productData;
      } else {
        print(response.reasonPhrase);

        print('products fetch failed 1: ${response.reasonPhrase} ');

        return productData;
      }
    } catch (e, stackTrace) {
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return productData;
    }
  }
}
