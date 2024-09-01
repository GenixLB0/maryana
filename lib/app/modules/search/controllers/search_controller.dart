import 'dart:convert';
import 'package:flutter/material.dart' hide Material;
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  RxList<String> searchKeywords = <String>[].obs;
  String titleResult = "";
  List<int> activeCats = [];
  RxBool isSearchLoading = false.obs;
  RxBool isFromSearch = false.obs;
  String selectedId = "";
  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();
  RxBool isFilterLoading = false.obs;

//////////////////////Filter//////////////////////////////
  RxList<ProductColor> colors = <ProductColor>[].obs;

  RxList<Brands> brands = <Brands>[].obs;

  RxList<Categories> categories_in_filter = <Categories>[].obs;

  RxList<Collections> collections = <Collections>[].obs;

  RxList<Styles> styles = <Styles>[].obs;
  RxList<String> sizes = <String>[].obs;

  RxList<Material> materials = <Material>[].obs;
  RxList<String> seasons = <String>[].obs;
  RxBool colorFullLength = false.obs;

  RxList<String> selectedSizes = <String>[].obs;
  RxList<Material> selectedMaterials = <Material>[].obs;
  RxList<Styles> selectedStyles = <Styles>[].obs;

  RxList<ProductColor> selectedColors = <ProductColor>[].obs;
  RxList<String> selectedSeasons = <String>[].obs;
  RxList<Brands> selectedBrands = <Brands>[].obs;
  RxList<Collections> selectedCollections = <Collections>[].obs;
  Rx<RangeValues> settedValue = RangeValues(1.0, 10000.0).obs;
  Rx<TextEditingController> minPriceController =
      TextEditingController(text: "0").obs;
  Rx<TextEditingController> maxPriceController =
      TextEditingController(text: "10000").obs;

  Rx<double> minPriceApi = 0.0.obs;
  Rx<double> maxPriceApi = 0.0.obs;

  ////////////////////////////////////////////////////////////
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    prefs = await SharedPreferences.getInstance();
    await getFilterResults();
    getSearchKeywords();
    attachScroll();
    // update();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getSearchKeywords() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? keyWords = prefs.getStringList("search_keywords");
    if (keyWords != null) {
      searchKeywords.value = keyWords;
    }
    print("list is ${searchKeywords}");
    update();
  }

  addSearchKeywords(searchValue) async {
    if (searchKeywords.contains(searchValue)) {
    } else {
      titleResult = searchValue;
      searchKeywords.add(searchValue);
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList("search_keywords", searchKeywords);

      getSearchKeywords();
      print("searching 5 ${titleResult}");
    }
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
    resultCount.value = 0;
    isFromSearch.value = false;
    titleResult = sectionName;
    resultSearchProducts.clear();
    isSearchLoading.value = true;

    print("the payload ${payload}");
    print("should called once...");
    var bodyFields = payload;

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
        print("response data ${responseData['data'].length}");
        for (var product in responseData['data']) {
          resultSearchProducts.add(ViewProductData.fromJson(product));
        }

        isSearchLoading.value = false;
        resultCount.value = resultSearchProducts.length;
        print("your map ${payload}");

        print("your resultt ${resultSearchProducts}");

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

  filterResultSearchProducts(filteredProducts) {
    resultSearchProducts = filteredProducts;
  }

  ScrollController scrollController = ScrollController();
  RxBool showBackToTopButton = false.obs;

  attachScroll() {
    print("attached...");
    scrollController.addListener(() {
      print("ttttttttttttttttttttt");
      if (scrollController.offset >= 100) {
        showBackToTopButton.value = true; // Show the back-to-top button
      } else {
        print("bbbbbbbbbbbbbbbbbbbbbbbbbb");
        showBackToTopButton.value = false; // Hide the back-to-top button
      }
    });
  }

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
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
        Uri.parse('https://panel.mariannella.com/api/products'),
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
          Uri.parse('https://panel.mariannella.com/api/products'),
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
          Uri.parse('https://panel.mariannella.com/api/products'),
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

  getFilterResults() async {
    isFilterLoading.value = true;
    // await getOneFilterModel();
    // await getColors();
    // await getBrands();
    // await getCategories();
    // await getCollections();
    // await getStyles();
    // await getSeasons();
    // await getMaterials();
    // await getSizes();
    await getOneFilterModel();

    isFilterLoading.value = false;
  }

  getColors() async {
    print("getting colors");

    colors.clear();
    print('colors api Loading ..');

    final response = await apiConsumer.post(
      'colors',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiColorsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('colors data successful');

        for (var color in apiResponse.data!.colors!) {
          colors.add(color);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('colors api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getBrands() async {
    print("getting brands");

    brands.clear();
    print('brands api Loading ..');

    final response = await apiConsumer.post(
      'brands',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiBrandsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('colors data successful');

        for (var brand in apiResponse.data!.brands!) {
          brands.add(brand);
        }
        print("gotten brands are ${brands}");
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('brands api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getCategories() async {
    print("categories getting");

    categories_in_filter.clear();
    print('categories api Loading ..');

    final response = await apiConsumer.post(
      'categories',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiCategoryResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('categories data successful');

        for (var category in apiResponse.data!) {
          categories_in_filter.add(category);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('categories api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getCollections() async {
    print("collections getting");

    collections.clear();
    print('collections api Loading ..');

    final response = await apiConsumer.post(
      'collections',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiCollectionsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('collections data successful');

        for (var collection in apiResponse.data!.collections!) {
          collections.add(collection);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('collection api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getStyles() async {
    print("styles getting");

    styles.clear();
    print('styles api Loading ..');

    final response = await apiConsumer.post(
      'styles',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiStylesResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('styles data successful');

        for (var style in apiResponse.data!.styles!) {
          styles.add(style);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('styles api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getSeasons() async {
    print("seasons getting");

    seasons.clear();
    print('seasons api Loading ..');

    final response = await apiConsumer.post(
      'seasons',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiSeasonsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('seasons data successful');

        for (var season in apiResponse.data!.seasons!) {
          seasons.add(season);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('seasons api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getMaterials() async {
    print("Materials getting");

    materials.clear();
    print('Materials api Loading ..');

    final response = await apiConsumer.post(
      'materials',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiMaterialsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('Materials data successful');

        for (var material in apiResponse.data!.materials!) {
          // materials.add(material);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('Materials api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  getSizes() async {
    print("Sizes getting");

    sizes.clear();
    print('Sizes api Loading ..');

    final response = await apiConsumer.post(
      'sizes',
      formDataIsEnabled: true,
    );

    try {
      final apiResponse = ApiSizesResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('Sizes data successful');

        for (var size in apiResponse.data!.sizes!) {
          sizes.add(size);
        }
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
      }
    } catch (e, stackTrace) {
      print('Sizes api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  changeLength(value) {
    value.value = !value.value;
  }

  addOrRemoveSize(size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }

    print("selected sizes are ${selectedSizes}");
  }

  addOrRemoveMaterial(material) {
    if (selectedMaterials.contains(material)) {
      selectedMaterials.remove(material);
    } else {
      selectedMaterials.add(material);
    }

    print("selected materials are ${selectedMaterials}");

    for (var material in selectedMaterials) {
      print("the id is ${material.id}");
    }
  }

  addOrRemoveStyle(style) {
    if (selectedStyles.contains(style)) {
      selectedStyles.remove(style);
    } else {
      selectedStyles.add(style);
    }

    print("selected styles are ${selectedStyles}");

    for (var style in selectedStyles) {
      print("the id is ${style.id}");
    }
  }

  addOrRemoveColor(color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }

    print("selected colors are ${selectedColors}");

    for (var color in selectedColors) {
      print("the id is ${color.name}");
    }
  }

  addOrRemoveSeason(season) {
    if (selectedSeasons.contains(season)) {
      selectedSeasons.remove(season);
    } else {
      selectedSeasons.add(season);
    }

    print("selected season are ${selectedSeasons}");

    for (var season in selectedSeasons) {
      print("the name is ${season}");
    }
  }

  addOrRemoveBrand(brand) {
    if (selectedBrands.contains(brand)) {
      selectedBrands.remove(brand);
    } else {
      selectedBrands.add(brand);
    }

    print("selected brand are ${selectedBrands}");

    for (var brand in selectedBrands) {
      print("the brand is ${brand}");
    }
  }

  addOrRemoveCollection(collection) {
    if (selectedCollections.contains(collection)) {
      selectedCollections.remove(collection);
    } else {
      selectedCollections.add(collection);
    }

    print("selected collection are ${selectedCollections}");

    for (var collection in selectedCollections) {
      print("the collection is ${collection}");
    }
  }

  clearSelectedFilters() {
    selectedSizes.clear();
    selectedMaterials.clear();
    selectedStyles.clear();
    selectedColors.clear();
    selectedSeasons.clear();
    selectedBrands.clear();
    selectedCollections.clear();
    minPriceController.value.text = minPriceApi.value.toString();
    maxPriceController.value.text = maxPriceApi.value.toString();
    setNewValue(const RangeValues(1.0, 10000.0));
  }

  setNewValue(RangeValues value) {
    if (value.end > value.start &&
        value.end <= maxPriceApi.value &&
        value.start >= minPriceApi.value) {
      settedValue.value = value;
      minPriceController.value.text = value.start.toInt().toString();
      maxPriceController.value.text = value.end.toInt().toString();
      print(
          "setted the start is ${minPriceController.value.text} and the end is ${maxPriceController.value.text}");
    } else {
      print("the con 1 ${value.end > value.start}");
      print("the con 2 ${value.end <= 10000.0}");
      print("the con 3 ${value.start >= 1.0}");
      print("cannot be setted");
    }
  }

  getOneFilterModel() async {
    // await getOneFilterModel();
    // await getColors();
    // await getBrands();
    await getCategories();
    // await getCollections();
    // await getStyles();
    // await getSeasons();
    // await getMaterials();
    final response = await apiConsumer.get(
      'filter',
    );

    try {
      final apiResponse = FilterOneModel.fromJson(response);
      if (apiResponse.status == "success") {
        minPriceApi.value = double.parse(apiResponse.data!.minPrice.toString());
        maxPriceApi.value = double.parse(apiResponse.data!.maxPrice.toString());
        minPriceController.value =
            TextEditingController(text: apiResponse.data!.minPrice!);
        maxPriceController.value =
            TextEditingController(text: apiResponse.data!.maxPrice!);

        setNewValue(RangeValues(
            double.parse(apiResponse.data!.minPrice.toString()),
            double.parse(apiResponse.data!.maxPrice.toString())));
        if (apiResponse.data?.colors != null) {
          for (var color in apiResponse.data!.colors!) {
            colors.add(color);
          }
        }

        if (apiResponse.data?.brands != null) {
          for (var brand in apiResponse.data!.brands!) {
            brands.add(brand);
          }
        }

        if (apiResponse.data?.collections != null) {
          for (var collection in apiResponse.data!.collections!) {
            collections.add(collection);
          }
        }

        if (apiResponse.data?.styles != null) {
          for (var style in apiResponse.data!.styles!) {
            styles.add(style);
          }
        }

        if (apiResponse.data?.seasons != null) {
          for (var season in apiResponse.data!.seasons!) {
            seasons.add(season);
          }
        }

        if (apiResponse.data?.materials != null) {
          for (var material in apiResponse.data!.materials!) {
            materials.add(material);
          }
        }

        if (apiResponse.data?.sizes != null) {
          for (var size in apiResponse.data!.sizes!) {
            sizes.add(size);
          }
        }
      }
    } catch (e) {
      print('filter api failed:  ${e} ');

      print(e.toString());
    }
  }

  clearSavedSearchKeyWords() async {
    searchKeywords.clear();
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("search_keywords", []);
  }
}
