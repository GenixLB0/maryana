import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart' hide Material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:maryana/app/modules/home/views/home_view.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/search/views/search_view.dart';
import 'package:maryana/app/modules/shop/views/shop_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart' as rootBundle;
import '../views/ai_loading_image.dart';
import '../views/result_view.dart';
import 'package:firebase_database/firebase_database.dart'; // For Realtime Database
import 'dart:async';

class CustomSearchController extends GetxController
    with GetTickerProviderStateMixin {
  List<ViewProductData> products = [];
  List<ViewProductData> resultSearchProducts = <ViewProductData>[].obs;
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
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  AnimationController? _bumpAnimationController;
  Animation<double>? _bumpAnimation;

  ////////////////////////////////////////////////////////////
  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward(); // Starts the animation when the widget is built

    // Scale transition for AI Powered badge
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.elasticOut, // Elastic bounce effect for scaling
      ),
    );
    _bumpAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // Add a continuous bump effect

    _bumpAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _bumpAnimationController!,
        curve: Curves.easeInOut,
      ),
    );
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
    _controller?.dispose();
    scrollController.dispose();
    _bumpAnimationController?.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _bumpAnimationController?.dispose();

    super.dispose();
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
      titleResult = searchValue;
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
      isFromSearch.value = true;
      resultCount.value = 0;
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

  int currentPage = 1;
  var controllerPayload = {};
  int total = 0;
  bool isFromAiPhase = false;

  Future<List<dynamic>> getProductsInSection(
      {required String sectionName,
      required payload,
      String orderTag = "featured",
      String keywords = "",
      bool isFromAi = false,
      bool isFromSection = true,
      String clothesType = ""}) async {
    isFromAiPhase = isFromAi;
    isEndScroll.value = false;
    controllerPayload = payload;
    total = 0;
    resultCount.value = 0;
    currentPage = 1;
    isFromSearch.value = false;
    titleResult = sectionName;
    resultSearchProducts.clear();
    isSearchLoading.value = true;

    print("the payload ${controllerPayload}");
    print("should called once...");
    var bodyFields = controllerPayload;

    bodyFields['current_page'] = currentPage.toString();
    if (!isFromAi) {
      bodyFields['per_page'] = "7";
    }
    bodyFields['orderBy'] = orderTag;

    if (isFromSection) {
    } else {
      bodyFields['keywords'] = keywords;
    }

    print("body feilds ${bodyFields}");
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
          if (isFromAi) {
            print("from ai 1 ${isFromAi}");
            print("from ai 3 ${product['name']}");
            print("from ai 4 ${clothesType}");
            if (product['name']
                .toString()
                .toLowerCase()
                .contains(clothesType)) {
              resultSearchProducts.add(ViewProductData.fromJson(product));
              print("from ai 2 ${product['name']}");
            } else {
              print("problem over dosee");
            }
          } else {
            resultSearchProducts.add(ViewProductData.fromJson(product));
          }
        }
        int total = isFromAi
            ? resultSearchProducts.length
            : responseData['meta']['total'];
        print("total is ${total}");
        isSearchLoading.value = false;
        if (total != 0) {
          resultCount.value = total;
        } else {
          resultCount.value = resultSearchProducts.length;
        }

        print("your map ${payload}");

        print("your result length 1 is ${resultSearchProducts.length}");

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

  RxBool isPaginationSearchLoading = false.obs;
  RxBool isEndScroll = false.obs;
  String sectionNameOld = '';

  Future<List<dynamic>> continueGettingProductsInSection(
      {required String sectionName, required payload}) async {
    if (isFromSearch.value) {
      print("none NOW 1");
      return [];
    } else {
      print("none NOW 2");
      if (isPaginationSearchLoading.value) {
        print("none NOW 3");
        isSearchLoading.value = true;
        return [];
      } else {
        currentPage++;
        print("none NOW 4 ${currentPage}");
        isEndScroll.value = false;
        isFromSearch.value = false;
        titleResult = sectionName;

        var bodyFields = payload;

        bodyFields['current_page'] = currentPage.toString();
        bodyFields['per_page'] = "7";
        print("body feilds ${bodyFields}");
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
            if (responseData['data'].length == 0) {
              isEndScroll.value = true;
            } else {}
            for (var product in responseData['data']) {
              resultSearchProducts.add(ViewProductData.fromJson(product));
            }
            int total = responseData['meta']['total'];
            print("total is ${total}");

            if (total != 0) {
              resultCount.value = total;
            } else {
              resultCount.value = resultSearchProducts.length;
            }
            print(responseData['meta']['total'].toString() +
                ' test productss' +
                resultSearchProducts.length.toString());
            if (responseData['meta']['total'] == resultSearchProducts.length) {
              isDataFullyLoaded = true;
              print('sadsadsadsadsadadsadsad {resultSearchProducts.length}');
            } else {
              print('sadsadsadsadsadadsadsad2');

              isDataFullyLoaded = false;
            }
            print("your map ${payload}");

            print("your result length 2 is ${resultSearchProducts.length}");
            isPaginationSearchLoading.value = false;
            return resultSearchProducts;
          } else {
            print(response.reasonPhrase);
            isPaginationSearchLoading.value = false;
            print('products fetch failed 1: ${response.reasonPhrase} ');

            return [];
          }
        } catch (e, stackTrace) {
          isPaginationSearchLoading.value = false;
          print('products fetch failed 2:  ${e} $stackTrace');

          print(e.toString() + stackTrace.toString());

          return [];
        }
      }
    }
  }

  filterResultSearchProducts(filteredProducts) {
    resultSearchProducts = filteredProducts;
  }

  ScrollController scrollController = ScrollController();
  RxBool showBackToTopButton = false.obs;

  Timer? _debounce;

// Function to attach the scroll listener
  void attachScroll() {
    print("attached...");

    scrollController.addListener(() {
      // Avoid recalculating distance and running unnecessary code
      if (isPaginationSearchLoading.value) return;

      // حساب المسافة المتبقية لنهاية القائمة
      double remainingScrollDistance =
          scrollController.position.maxScrollExtent -
              scrollController.position.pixels;

      // Only proceed if data is not fully loaded
      if (isDataFullyLoaded) {
        if (sectionNameOld.isEmpty || sectionNameOld != titleResult) {
          isDataFullyLoaded = false;
          sectionNameOld = titleResult;
        }
      }

      // Proceed only if not already loading and close to the bottom
      if (!isDataFullyLoaded &&
          remainingScrollDistance < 500 &&
          !isPaginationSearchLoading.value &&
          !isFromSearch.value &&
          !isFromAiPhase) {
        // Debounce to prevent multiple triggers during fast scrolling
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        _debounce = Timer(Duration(milliseconds: 30), () {
          // Increased debounce time
          print("loading more data before reaching the end...");

          // Set the flag to prevent multiple API calls

          // Fetch new products for the section
          continueGettingProductsInSection(
                  sectionName: titleResult, payload: controllerPayload)
              .then((_) {
            // After successfully loading data, mark as fully loaded if no more data is available
            isPaginationSearchLoading.value = false;

            // Check if more data exists and set `isDataFullyLoaded` accordingly
            // For example, you might check the API response to see if there are more pages
          }).catchError((error) {
            // Handle any errors from the API call
            isPaginationSearchLoading.value =
                false; // Reset the loading state if error occurs
          });
        });
      } else if (isDataFullyLoaded) {
        print("Data is fully loaded, no need to load more.");
      } else {
        print("Not yet near the end or already loading.");
      }
    });
  }

// This can be called to reset the fully loaded flag,
// if needed when the user navigates to a new section
  void resetDataLoadFlag() {
    isDataFullyLoaded = false;
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

  ///////////////////////////////////////////////////////
////////////////////AI SEARCH //////////////////////////
  RxString myClothingType = "".obs;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> showPickerDialog(context) async {
    return showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        expand: false,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/product/aiSearch.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // "AI Powered" Badge with animation
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h, right: 10.w),
                  child: ScaleTransition(
                    scale: _scaleAnimation!,
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20.h),
                        child: AnimatedBuilder(
                            animation: _bumpAnimationController!,
                            // Use your AnimationController
                            builder: (context, child) {
                              return Transform.scale(
                                  scale: _bumpAnimation?.value,
                                  // Applying the bump scale effect
                                  child: OutlinedButton(
                                      onPressed: () {},
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.white,
                                          highlightColor: Colors.blue,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Add a robot icon or image
                                              Icon(
                                                Icons.android,
                                                // You can replace this with any robot icon or image
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                              SizedBox(width: 10.w),
                                              // Space between the icon and the text
                                              Text(
                                                'AI Powered',
                                                style: primaryTextStyle(
                                                  color: Colors.white,
                                                  weight: FontWeight.bold,
                                                  size: 12.sp.round(),
                                                ),
                                              ),
                                            ],
                                          ))));
                            })),
                  ),
                ),
              ),

              // Lightning-like shimmer scanning effect
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lightning shimmer effect
                      Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: Text(
                          'Search for an outfit by taking a photo or uploading an image',
                          textAlign: TextAlign.center,
                          style: primaryTextStyle(
                            size: 18.sp.round(),
                            weight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h), // Spacing

                      // Take Photo Button with animation
                      ElevatedButton.icon(
                        onPressed: () {
                          _pickImage(ImageSource.camera,
                              context); // Handle camera pick
                          //   Navigator.of(context).pop(); // Close the dialog
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text('TAKE PHOTO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h), // Spacing

                      // Upload a Photo Button with shimmer effect
                      OutlinedButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery,
                              context); // Handle gallery pick
                          //      Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          'UPLOAD A PHOTO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 50,
                          ),
                          side: BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }

  List<Categories> aiSearchCats = [];
  var ongoingPayload;

  Future<void> _pickImage(ImageSource source, context) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100, // Set the image quality to the highest
    );

    if (pickedFile != null) {
      clothingType = "";
      Navigator.pop(context);

      Get.to(FullScreenImageWithLoading(
        image: File(pickedFile.path),
      ));

      _image = pickedFile;
      await Future.delayed(Duration(seconds: 4));
      await detectClothesType();
    }
  }

  void currentFun() {
    if (CustomSearchController().initialized) {
      CustomSearchController controller = Get.find<CustomSearchController>();
      controller.getProductsInSection(
          sectionName: myClothingType.value,
          payload: {},
          isFromAi: true,
          clothesType: myClothingType.value.toLowerCase());

      Get.to(() => const ResultView(),
          transition: Transition.fadeIn,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400));
    } else {
      CustomSearchController controller =
          Get.put<CustomSearchController>(CustomSearchController());
      controller.getProductsInSection(
          sectionName: myClothingType.value,
          payload: {},
          isFromAi: true,
          clothesType: myClothingType.value.toLowerCase());

      Get.to(() => const ResultView(),
          transition: Transition.fadeIn,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400));
    }
  }

  Future<void> detectClothesType() async {
    try {
      ServiceAccountCredentials credentials;
      print('test email');

      if (Platform.isAndroid || Platform.isIOS) {
        // Fetch credentials from Firebase Realtime Database
        await Future.delayed(Duration(seconds: 2));
        final credentialsData = await fetchApiCredentials();
        await Future.delayed(Duration(seconds: 2));
        final clientEmail = credentialsData['client_email'];
        final privateKey = credentialsData['private_key'];

        if (clientEmail == null || privateKey == null) {
          throw Exception("Missing API credentials from Firebase.");
        }

        credentials = ServiceAccountCredentials(
          clientEmail,
          ClientId(""),
          privateKey,
        );
      } else {
        throw Exception("Unsupported platform");
      }

      // Authorize using the credentials
      final authClient = await clientViaServiceAccount(
        credentials,
        [vision.VisionApi.cloudPlatformScope],
      );

      // Initialize the Vision API client
      final visionApi = vision.VisionApi(authClient);

      // Read image file
      final imageFile = File(_image!.path);
      final bytes = imageFile.readAsBytesSync();
      final base64Image = base64Encode(bytes);

      // Prepare the request for image annotation
      final request = vision.BatchAnnotateImagesRequest.fromJson({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "LABEL_DETECTION", "maxResults": 10}
            ]
          }
        ]
      });

      // Define clothing types to detect
      final clothingTypes = [
        'shirt',
        'dress',
        'pants',
        'skirt',
        'jacket',
        'coat',
        'sweater',
        't-shirt',
        'jeans',
        'shorts',
        'bag',
        'sock',
        'shoes',
        'hat',
        'glove',
        'sweatpant',
        'sweatshirt',
        'jumper',
        'bottle',
        'bra',
        'underwear',
        'define',
        'legging',
        'sport',
        'hoodie',
        'set',
        'sleeve',
        'bra',
        'trouser',
        'top',
        'hat',
        'shoe',
        'sneaker',
        'glass'
      ];

      // Send the request to the Vision API
      final response = await visionApi.images.annotate(request);
      final annotateImageResponses = response.responses;

      for (var annotateImageResponse in annotateImageResponses!) {
        if (annotateImageResponse.labelAnnotations != null) {
          bool isMatching = false;
          for (var label in annotateImageResponse.labelAnnotations!) {
            print("Your label: ${label.description}");
            if (clothingTypes.contains(label.description?.toLowerCase())) {
              isMatching = true;
              myClothingType.value = label.description!;
            }
          }

          // If clothing type is detected, proceed; otherwise, show error
          if (isMatching) {
            currentFun();
            Get.back();
            Get.off(const ResultView());
          } else {
            Get.back();
            Get.snackbar(
                "Not Recognized", "No Clothing Detected, try another image");
          }
        }
      }

      // Close the auth client after use
      authClient.close();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<Map<String, String>> fetchApiCredentials() async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('api_credentials');
      print('asdsadsadsadsad2w');

      final DataSnapshot snapshot = await dbRef.get();
      print('asdsadsadsadsad2');

      final data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        return {
          'client_email': data['client_email'],
          'private_key': data['private_key']
        };
      } else {
        throw Exception("API credentials not found in Firebase.");
      }
    } catch (e, stackTrace) {
      print('$e $stackTrace credentials not found in Firebase.');
      throw Exception("API credentials not found in Firebase.");
    }
  }

  int? selectedCatId;
  String selectedOption = 'featured'; // Ini
  changeDropDownValue(String option) {
    String myValue = "Top Picks";
    if (option == "featured") {
      myValue = "Top Picks";
    }

    if (option == "best_selling") {
      myValue = "Most Popular";
    }

    if (option == "latest") {
      myValue = "New Arrivals";
    }

    if (option == "oldest") {
      myValue = "Earlier Products";
    }

    if (option == "low-high") {
      myValue = "Lowest Price First";
    }

    if (option == "high-low") {
      myValue = "Highest Price First";
    }

    if (option == "featured") {
      myValue = "Alphabetical: A to Z";
    }

    if (option == "z-a") {
      myValue = "Alphabetical: Z to A";
    }

    selectedOption = myValue;
    print("selected option is $selectedOption");
    getProductsInSection(
        sectionName: titleResult,
        payload: controllerPayload,
        orderTag: option,
        keywords: titleResult);

    // if (selectedCatId != null) {
    //
    //
    //   // update(['products_in_categories']);
    //   update();
    // } else {
    //   Get.snackbar("Pick A Category",
    //       "please pick a category first from the left side bar");
    // }
    update();
  }
}
