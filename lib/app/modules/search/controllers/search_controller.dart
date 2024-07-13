import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart';

import '../../services/api_consumer.dart';
import '../../services/api_service.dart';
import 'package:dio/dio.dart' as dio;

class CustomSearchController extends GetxController {
  List<ViewProductData> products = [];
  List<ViewProductData> resultSearchProducts = [];
  RxList<Categories> categories = <Categories>[].obs;
  late SharedPreferences prefs;
  final Rx<int> resultCount = 0.obs;

  List<String> searchKeywords = [];
  String titleResult = "";
  List<int> activeCats = [];
  RxBool isSearchLoading = false.obs;
  RxBool isFromSearch = false.obs;
  String selectedId = "";
  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    getSearchKeywords();
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getSearchKeywords() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? keyWords = prefs.getStringList("search_keywords");
    if (keyWords != null) {
      searchKeywords = keyWords;
    }
    print("list is ${searchKeywords}");
    update();
  }

  addSearchKeywords(searchValue) async {
    titleResult = searchValue;
    searchKeywords.add(searchValue);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("search_keywords", searchKeywords);

    getSearchKeywords();
    print("searching 5 ${titleResult}");
  }

  getSearchResultsFromApi() async {
    if (titleResult.isNotEmpty) {
      print("searching 1");
      resultSearchProducts.clear();
      isSearchLoading.value = true;
      print('search api successful');

      var formData = dio.FormData.fromMap({"keyword": titleResult});

      final response = await apiConsumer.post(
        'search',
        formDataIsEnabled: true,
        formData: formData,
      );

      try {
        final apiResponse = SearchResultModel.fromJson(response);
        if (apiResponse.status == 'success') {
          print('search data successful');

          for (var product in apiResponse.data!.products!) {
            resultSearchProducts.add(product);
          }
          print("searching 2 ${resultSearchProducts.length}");
          resultCount.value = resultSearchProducts.length;
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Search failed: ${response.statusMessage}');
          print("searching 3 ${resultSearchProducts}");
        }
        isSearchLoading.value = false;
        print("result from search ${resultSearchProducts}");
        update();
      } catch (e, stackTrace) {
        isSearchLoading.value = false;
        print('search api failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        print("searching 4 ${resultSearchProducts}");

        update();
      }
    } else {
      print("Searching 6 ${titleResult}");
    }
  }

  Future<List<dynamic>> getProductsInSection(
      {required String sectionName, required payload}) async {
    // if (categories.isEmpty) {
    //   await getCategoriesList();
    // }
    // mimicCatsForActiveCats(false, 1);
    isFromSearch.value = false;
    titleResult = sectionName;
    resultSearchProducts.clear();
    isSearchLoading.value = true;

    List _products = [];
    print("getting started...");
    var bodyFields = payload;

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
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
        isSearchLoading.value = false;
        print("your map ${payload}");

        print("your result ${resultSearchProducts}");

        return resultSearchProducts;
      } else {
        print(response.reasonPhrase);
        isSearchLoading.value = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        return [];
      }
    } catch (e, stackTrace) {
      isSearchLoading.value = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

  addActiveCats(List<int> incomingActiveCats) {
    Future.delayed((Duration(seconds: 1)), () {
      activeCats = incomingActiveCats;
      update();
    });
  }

  deleteSearchKeyword(keyword) async {
    var favoriteList = prefs.getStringList('search_keywords') ?? [];

    favoriteList.removeWhere((item) => item == keyword);
    prefs.setStringList('search_keywords', favoriteList);
    await getSearchKeywords();
  }

  changeActiveCats(int incomingIndex) {
    for (var i = 0; i < activeCats.length; i++) {
      if (i != incomingIndex) {
        activeCats[i] = 0;
      } else {
        activeCats[i] = 1;
      }
    }

    print(activeCats);
    update();
  }

  void mimicCatsForActiveCats(bool isCategoryFilter, int? incomingId) {
    List<Categories> myCatList = [];
    List<int> activeCats = [];
    Categories allItemCategory =
        Categories(name: "All", slug: "", image: "", id: 0);

    myCatList.add(allItemCategory);

    for (var cat in categories) {
      myCatList.add(cat);
    }
    print("test cats are ${myCatList}");
    if (isCategoryFilter) {
      for (var cat in myCatList) {
        if (cat.id == incomingId) {
          activeCats.add(1);
        } else {
          activeCats.add(0);
        }
      }
    } else {
      for (var cat in myCatList) {
        if (cat.name == "All") {
          activeCats.add(1);
        } else {
          activeCats.add(0);
        }
      }
    }

    addActiveCats(activeCats);
  }

  filterProductsAccordingToCat(
      int id, bool isCategoryFilter, List<Categories>? mycategories) async {
    isSearchLoading.value = true;
    categories.clear();
    resultSearchProducts.clear();
    print("my cats are ${mycategories}");
    if (mycategories != null) {
      for (var cat in mycategories) {
        cat.name != "All Items" ? categories.add(cat) : null;
      }
      mimicCatsForActiveCats(isCategoryFilter, id);

      update();
    } else {
      getCategoriesList();
    }

    print('filter api successful');

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var bodyFields = {};
    if (isCategoryFilter) {
      if (id == 00) {
        bodyFields = {};
      } else {
        bodyFields = {'category_ids[0]': id.toString()};
      }
    } else {
      id == 00
          ? bodyFields = {
              'keywords': titleResult,
            }
          : bodyFields = {'category_ids[0]': id.toString()};
    }

    if (isCategoryFilter) {
      print("cat filter 1");
      final response = await http.post(
        Uri.parse('https://mariana.genixarea.pro/api/products'),
        headers: headers,
        body: bodyFields,
      );
      try {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          for (var product in responseData['data']) {
            resultSearchProducts.add(product);
          }

          print(resultSearchProducts.length);
          isSearchLoading.value = false;
          update();
        } else {
          print(response.reasonPhrase);
          isSearchLoading.value = false;
          update();
        }
        update();
        print("cat filter 1 ${resultSearchProducts}");
      } catch (e, stackTrace) {
        isSearchLoading.value = false;
        print('filter failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        update();
      }
    } else {
      if (titleResult.isNotEmpty) {
        final response = await http.post(
          Uri.parse('https://mariana.genixarea.pro/api/products'),
          headers: headers,
          body: bodyFields,
        );
        try {
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            for (var product in responseData['data']) {
              resultSearchProducts.add(product);
            }

            print(resultSearchProducts.length);
            isSearchLoading.value = false;
          } else {
            print(response.reasonPhrase);
            isSearchLoading.value = false;
          }
        } catch (e, stackTrace) {
          isSearchLoading.value = false;
          print('filter failed:  ${e} $stackTrace');

          print(e.toString() + stackTrace.toString());
        }
      } else {
        final response = await http.post(
          Uri.parse('https://mariana.genixarea.pro/api/products'),
          headers: headers,
          body: bodyFields,
        );
        try {
          if (response.statusCode == 200) {
            var responseData = json.decode(response.body);
            for (var product in responseData['data']) {
              resultSearchProducts.add(product);
            }

            print(resultSearchProducts.length);
            isSearchLoading.value = false;
          } else {
            print(response.reasonPhrase);
            isSearchLoading.value = false;
          }
        } catch (e, stackTrace) {
          isSearchLoading.value = false;
          print('filter failed:  ${e} $stackTrace');

          print(e.toString() + stackTrace.toString());
        }
      }
    }
  }

  getCategoriesList() async {
    print("searching 1");

    categories.clear();
    print('search api successful');

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

      update();
    } catch (e, stackTrace) {
      print('search api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      update();
    }
  }

  setArgs() {
    getSearchKeywords();
    if (Get.arguments == null) {
    } else {
      print("the arguments are ${Get.arguments}");
      products = Get.arguments[0] as List<ViewProductData>;
      categories.value = Get.arguments[1] as List<Categories>;
      print("products from args ${products}");
      mimicCatsForActiveCats(false, null);
    }
  }
}
