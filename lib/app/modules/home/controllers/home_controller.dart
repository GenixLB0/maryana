import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/config/constant.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart' hide Brands;
import '../../services/api_consumer.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();

  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();
  Rx<TestData> homeModel = TestData().obs;
  late VideoPlayerController videoController;
  List<int> activeCats = [];
  RxBool isHomeLoading = false.obs;
  final wishlistProductIds = <int>[].obs;

////////////////collections//////////////////////////
  RxBool isCollectionLoading = false.obs;
  final collections = Rx<List<Collections>>([]);

  RxBool isCollectionProductsLoading = false.obs;
  List<CollectionProducts> collectionProducts = <CollectionProducts>[].obs;

  RxBool isProductAddedToCollection = false.obs;
  RxBool isCollectionsReached = false.obs;

  /////////////////////////////////////////////////

  ////////////////brands//////////////////////////
  RxBool isBrandLoading = false.obs;
  final brands = Rx<List<Brands>>([]);
  RxBool isBrandProductsLoading = false.obs;
  List<BrandProducts> brandProducts = <BrandProducts>[].obs;

  RxBool isProductAddedToBrand = false.obs;
  RxBool isBrandsReached = false.obs;

  RxBool isOtherBrandLoading = false.obs;
  List<String> otherBrandsId = [];
  final otherBrands = Rx<List<Brands>>([]);
  RxBool isOtherBrandReached = false.obs;

  /////////////////////////////////////////////////

  ////////////////Coupons////////////////////////////////
  RxBool isCouponLoading = false.obs;
  final coupons = Rx<List<Coupons>>([]);
  RxBool isCouponsAdded = false.obs;

  RxBool isCouponReached = false.obs;

  //////////////////////////////////////////////////////////

  ////////////////Styles////////////////////////////////
  RxBool isStylesLoading = false.obs;
  final styles = Rx<List<Styles>>([]);
  RxBool isStylesAdded = false.obs;

  RxBool isStyleReached = false.obs;

  //////////////////////////////////////////////////////////

  /////////////GiftCard////////////////////////////

  RxBool isGiftCardLoading = false.obs;
  final giftCards = Rx<List<GiftCards>>([]);

  RxBool isGiftCardsAdded = false.obs;

  RxBool isGiftCardReached = false.obs;

  //////////////////////////////////////////////////

  ////////////////products In Brands////////////////////////////////
  RxBool isProductsInBrandsLoading = false.obs;
  final productsInBrands = Rx<List<dynamic>>([]);
  RxBool isProductsInBrandsAdded = false.obs;

  RxBool isProductsInBrandsReached = false.obs;

  //////////////////////////////////////////////////////////

  //////////////////////recommended////////////////////////
  RxBool isRecommendedReached = false.obs;

  //////////////////////////////////////////////////////////

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getHomeApi();

    // mimicCatsForActiveCats(false, null);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    print("on close ....");
  }

  getHomeApi() async {
    isHomeLoading.value = true;
    print('home api successful');

    final response = await apiConsumer.get(
      'homepage',
    );

    try {
      final apiResponse = CustomHomeModel.fromJson(response);
      if (apiResponse.status == 'success') {
        print('home data successful');
        isHomeLoading.value = false;
        homeModel.value = apiResponse.data!;
        List<String> banners = [];
        print("the type is ${homeModel.value.banners.runtimeType}");

        // Handle successful home data
        // await _cacheUser(apiResponse.data!);
        // AppConstants.userData = apiResponse.data!;

        print("the categories are ${apiResponse.data!.categories}");
        mimicCatsForActiveCats(false, null);
        // await getHomeScreenCollections();
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print('Registration failed: ${response.statusMessage}');
      }
      // isLoading.value = false;
    } catch (e, stackTrace) {
      isHomeLoading.value = false;
      // isLoading.value = false;
      print('home api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }

    await getWishlistProducts();
  }

  Future<void> _cacheUser(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('total_points', data.toJson().toString());
    print('User data cached: ${data.toJson()}');
  }

  setCats() {
    homeModel.value.categories!.toSet().toList();
    print("the setted cats are ${homeModel.value.categories!}");
    update();
  }

  runVideo() {
    print("started... 1");
    videoController = VideoPlayerController.asset(
        'assets/images/home/home_video.mp4',
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((_) {
        print("started... 2");
      });
    videoController.play(); // Autoplay the video
    videoController.setLooping(true); // Enable video looping
  }

  void mimicCatsForActiveCats(bool isCategoryFilter, int? incomingId) {
    print("testing ..");
    List<Categories> myCatList = [];
    activeCats = [];
    Categories allItemCategory =
        Categories(name: "All", slug: "", image: "", id: 0);

    myCatList.add(allItemCategory);

    for (var cat in homeModel.value.categories!) {
      myCatList.add(cat);
    }
    print("all cats are ${myCatList}");

    for (var cat in myCatList) {
      if (cat.name == "All") {
        activeCats.add(1);
      } else {
        activeCats.add(0);
      }
    }
    print("active cats are ${activeCats}");
    addActiveCats(activeCats);
  }

  addActiveCats(List<int> incomingActiveCats) {
    Future.delayed((Duration(seconds: 1)), () {
      activeCats = incomingActiveCats;
      update();
    });
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

//////////Collections////////////////
  getHomeScreenCollections() async {
    isCollectionLoading.value = true;
    print('Collections api loading ...');

    var formData = dio.FormData.fromMap({
      'home': "1",
    });

    final response = await apiConsumer.post(
      'collections',
      formDataIsEnabled: true,
      formData: formData,
    );

    try {
      final apiResponse = ApiCollectionsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('Collections data successful');
        isCollectionLoading.value = false;
        collections.value = apiResponse.data!.collections!;
        collections.value.isEmpty
            ? isProductAddedToCollection.value = true
            : null;
        print("collections are ${collections.value}");
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print('Collections fetch failed: ${response.statusMessage}');
        isCollectionLoading.value = false;
      }
    } catch (e, stackTrace) {
      isCollectionLoading.value = false;

      print('Collections fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  Future<List<dynamic>> getProductsInCollection(
      Collections mycollection) async {
    isProductAddedToCollection.value = false;
    List _products = [];

    var bodyFields = {
      'collection_ids[0]': "${mycollection.id}",
      'per_page': "4"
    };

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

    if (mycollection.id != null || mycollection.id != 0) {
      isCollectionProductsLoading.value = true;
      try {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);

          for (var product in responseData['data']) {
            _products.add(product);
          }
          collectionProducts.add(CollectionProducts(
              collectionName: mycollection.name!, products: _products));
          print(collectionProducts.length);
          isCollectionProductsLoading.value = false;
          print("the prod are $collectionProducts");

          isProductAddedToCollection.value = true;

          return _products;
        } else {
          print(response.reasonPhrase);
          isCollectionProductsLoading.value = false;
          print('the prod are failed2 :  ${response.reasonPhrase}');

          return [];
        }
      } catch (e, stackTrace) {
        isCollectionProductsLoading.value = false;
        print('the prod are failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        return [];
      }
    } else {
      print("sorry the prod are empty");
      return [];
    }
  }

////////////////////////////////////

////////Brands  ///////////////////////////////
  getHomeScreenBrands() async {
    isBrandLoading.value = true;
    print('Brands api loading ...');

    var formData = dio.FormData.fromMap({
      'home': "1",
    });

    final response = await apiConsumer.post(
      'brands',
      formDataIsEnabled: true,
      formData: formData,
    );

    try {
      final apiResponse = ApiBrandsResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print('Brands data successful');
        isBrandLoading.value = false;
        brands.value = apiResponse.data!.brands!;
        brands.value.isEmpty ? isProductAddedToBrand.value = true : null;

        print("brands are ${brands.value}");
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print('Brands fetch failed: ${response.statusMessage}');
        isBrandLoading.value = false;
      }
    } catch (e, stackTrace) {
      isBrandLoading.value = false;

      print('Brands fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }
  }

  Future<List<dynamic>> getProductsInBrand(Brands mybrand) async {
    isProductAddedToBrand.value = false;
    List _products = [];

    var bodyFields = {'brand_ids[0]': "${mybrand.id}", 'per_page': "4"};

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
          _products.add(product);
        }
        isProductAddedToBrand.value = true;

        return _products;
      } else {
        print(response.reasonPhrase);
        isProductAddedToBrand.value = false;
        return [];
      }
    } catch (e, stackTrace) {
      isProductAddedToBrand.value = false;
      print('brand fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      return [];
    }
  }

  getHomeScreenOtherBrands() async {
    if (otherBrands.value.isEmpty) {
      otherBrandsId.clear();
      isOtherBrandLoading.value = true;
      print('Other Brands api loading ...');

      var formData = dio.FormData.fromMap({
        'home': "0",
      });

      final response = await apiConsumer.post(
        'brands',
        formDataIsEnabled: true,
        formData: formData,
      );

      try {
        final apiResponse = ApiBrandsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Other Brands data successful');
          isOtherBrandLoading.value = false;
          otherBrands.value = apiResponse.data!.brands!;
          print("brands are ${otherBrands.value}");
          for (var brand in otherBrands.value) {
            otherBrandsId.add(brand.id.toString());
          }
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Other Brands fetch failed: ${response.statusMessage}');
          isOtherBrandLoading.value = false;
        }
      } catch (e, stackTrace) {
        isOtherBrandLoading.value = false;

        print('Brands fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

////////////////////////////////////

  listenForFirstScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 850.h) {
        // You're within 300 pixels before the maximum scroll extent
        print('Reached before max scroll by 350 pixels');
        // User reached the bottom of the screen
        // Rebuild your additional section here
        print("testnew 333");
        isCollectionsReached.value = true;

        if (isProductAddedToCollection.value) {
          print("testnew 33333333333 ");
          isBrandsReached.value = true;
        }

        if (isBrandsReached.value && isProductAddedToCollection.value) {
          print("testnew 4 new");
          isCouponReached.value = true;
        }

        if (isBrandsReached.value && isProductAddedToCollection.value) {
          print("testnew 4 new");
          isGiftCardReached.value = true;
          print("gifft card reached value is ${isGiftCardReached}");
        }

        if (isProductAddedToBrand.value && isProductAddedToCollection.value) {
          print("testnew 5 new");
          isStyleReached.value = true;
        }

        if (isProductAddedToBrand.value &&
            isProductAddedToCollection.value &&
            isStyleReached.value) {
          print("testnew 6 new");
          isOtherBrandReached.value = true;
        }
        if (isProductAddedToBrand.value &&
            isProductAddedToCollection.value &&
            isStyleReached.value &&
            isOtherBrandReached.value) {
          print("testnew 7 new");
          isProductsInBrandsReached.value = true;
        }
      }

      if (isProductAddedToBrand.value &&
          isProductAddedToCollection.value &&
          isStyleReached.value &&
          isOtherBrandReached.value &&
          isProductsInBrandsReached.value) {
        print("testnew 7 new");
        isRecommendedReached.value = true;
      }

      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent - 50) {
          // User reached the top of the screen
        } else if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {}
      }
    });
  }

  getHomeScreenCoupons() async {
    if (coupons.value.isEmpty && userToken!.isNotEmpty && userToken != null) {
      isCouponLoading.value = true;
      isCouponsAdded.value = false;

      coupons.value.clear();
      print('Coupon api loading ...');

      final response = await apiConsumer.post(
        'coupons',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = ApiCouponResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Coupon data successful');
          for (var coupon in apiResponse.data!.coupons!) {
            coupons.value.add(coupon);
          }

          print("coupons are ${coupons.value}");
          isCouponLoading.value = false;
          isCouponsAdded.value = true;
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Coupons fetch failed: ${response.statusMessage}');
          isCouponLoading.value = false;
          isCouponsAdded.value = false;
        }
      } catch (e, stackTrace) {
        isCouponLoading.value = false;

        print('Coupons fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isCouponsAdded.value = false;
      }
    }
  }

  getHomeScreenStyles() async {
    if (styles.value.isEmpty && !isStylesAdded.value) {
      isStylesLoading.value = true;
      isStylesAdded.value = false;
      styles.value.clear();
      print('styles api loading ...');

      final response = await apiConsumer.post(
        'styles',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = ApiStylesResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('styles data successful');

          styles.value = apiResponse.data!.styles!;
          print("styles are ${styles.value}");
          isStylesLoading.value = false;
          isStylesAdded.value = true;
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('styles fetch failed: ${response.statusMessage}');
          isStylesLoading.value = false;
          isStylesAdded.value = false;
        }
      } catch (e, stackTrace) {
        isStylesLoading.value = false;

        print('Styles fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isStylesAdded.value = false;
      }
    }
  }

  getHomeScreenGiftCards() async {
    if (giftCards.value.isEmpty && !isGiftCardsAdded.value) {
      isGiftCardLoading.value = true;
      isGiftCardsAdded.value = false;
      giftCards.value.clear();
      print('gift Cards api loading ...');

      final response = await apiConsumer.post(
        'gift-card-types',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = ApiGiftCardsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('gift Cards data successful');

          giftCards.value = apiResponse.data!.giftCards!;
          print("gift Cards are ${giftCards}");
          isGiftCardLoading.value = false;
          isGiftCardsAdded.value = true;
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('gift Cards fetch failed: ${response.statusMessage}');
          isGiftCardLoading.value = false;
          isGiftCardsAdded.value = false;
        }
      } catch (e, stackTrace) {
        isGiftCardLoading.value = false;

        print('Gift Card fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isGiftCardsAdded.value = false;
      }
    }
  }

  getProductsInBrands() async {
    if (productsInBrands.value.isEmpty) {
      isProductsInBrandsLoading.value = true;
      isProductsInBrandsAdded.value = false;

      await Future.forEach<Brands>(otherBrands.value, (Brands item) async {
        await getTheProductsInBrands(item);
      });

      isProductsInBrandsLoading.value = false;
      isProductsInBrandsAdded.value = true;
    }
  }

  Future<dynamic> getTheProductsInBrands(Brands brand) async {
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var bodyFields = {'brand_ids[0]': "${brand.id}", "per_page": "2"};
    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );
    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        for (var product in responseData['data']) {
          productsInBrands.value.add(product);
        }

        return productsInBrands.value;
      } else {
        print(response.reasonPhrase);
        isProductAddedToBrand.value = false;
        return [];
      }
    } catch (e, stackTrace) {
      isProductAddedToBrand.value = false;
      print('brand fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      return [];
    }
  }

  getWishlistProducts() async {
    wishlistProductIds.clear();
    print('Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      final response = await apiConsumer.post(
        'wishlist',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');
          for (var id in apiResponse.data!.wishlist!) {
            wishlistProductIds.addNonNull(id);
          }
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.setInitData(wishlistProductIds);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  removeFromWishlist(product_id) async {
    Get.snackbar('Removing ...', 'Removing From Wishlist',
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.white,
        backgroundColor: primaryColor,
        duration: const Duration(milliseconds: 1200),
        icon: Center(
            child: LoadingAnimationWidget.flickr(
          leftDotColor: Colors.purpleAccent,
          rightDotColor: Colors.white,
          size: 40.sp,
        )),
        isDismissible: true);
    print('removing from Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/remove',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.removeWhere((item) => item == product_id);
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.removeFromGrid(product_id);
          Get.snackbar('Removed', 'Removed from Wishlist',
              backgroundColor: primaryColor,
              icon: SvgPicture.asset(
                "assets/images/home/add_to_wishlist.svg",
                width: 43.w,
                height: 43.h,
                fit: BoxFit.cover,
              ),
              isDismissible: true);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  addToWishlist(product_id) async {
    Get.snackbar('Adding ...', 'Adding To Wishlist',
        showProgressIndicator: true,
        duration: const Duration(milliseconds: 1200),
        progressIndicatorBackgroundColor: Colors.white,
        backgroundColor: primaryColor,
        icon: Center(
            child: LoadingAnimationWidget.flickr(
          leftDotColor: Colors.purpleAccent,
          rightDotColor: Colors.white,
          size: 40.sp,
        )),
        isDismissible: true);
    print('removing from Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/add',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.add(product_id);
          Get.snackbar('Added', 'Added To Wishlist',
              backgroundColor: primaryColor,
              icon: SvgPicture.asset(
                "assets/images/home/wishlisted.svg",
                width: 43.w,
                height: 43.h,
                fit: BoxFit.cover,
              ),
              isDismissible: true);
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.addToGrid(product_id);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }
}
